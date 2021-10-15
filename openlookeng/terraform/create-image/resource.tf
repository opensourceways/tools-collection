data "huaweicloud_availability_zones" "test" {}


data "huaweicloud_vpc_subnet" "test" {
  name = var.subnet
}

resource "huaweicloud_compute_keypair" "test-keypair" {
  name       = "terraform-test"
  public_key = var.public
}


resource "huaweicloud_vpc_eip" "myeip" {
  publicip {
    type = "5_bgp"
  }
  bandwidth {
    name        = "test"
    size        = 8
    share_type  = "PER"
    charge_mode = "traffic"
  }
}


resource "huaweicloud_compute_instance" "test" {
  name              = "my_image"
  image_name        = "CentOS 7.6 64bit"
  security_groups   = ["default"]
  availability_zone = "cn-south-1e"
  flavor_id         = "s6.2xlarge.4"
  

  key_pair  = "terraform-test"
  user_data = <<-EOF
#!/bin/bash
echo '${file("./java.sh")}' > /home/java.sh
echo '${file("./maven.sh")}' > /home/maven.sh
echo "${file("./id_rsa")}" > /home/id_rsa
echo "${file("./id_rsa.pub")}" > /home/id_rsa.pub
echo '${file("./useradd.sh")}' > /home/useradd.sh
echo '${file("./daemon.json")}' > /home/daemon.json

EOF

  network {
    uuid = data.huaweicloud_vpc_subnet.test.id
  }
}

resource "huaweicloud_compute_eip_associate" "associated" {
  public_ip   = huaweicloud_vpc_eip.myeip.address
  instance_id = huaweicloud_compute_instance.test.id
}


resource "null_resource" "provision" {
  depends_on = [huaweicloud_compute_eip_associate.associated]
  
  provisioner "remote-exec" {
    connection {
      user     = "root"
      private_key = file("./id_rsa")
      host     = huaweicloud_vpc_eip.myeip.address
    }
 
    inline = [
      
      "chmod 777 /home/java.sh",
      "chmod 777 /home/useradd.sh",
      "echo 'source /etc/profile' >> ~/.bashrc",
      "cd /home",
      
 #     "wget -c '${var.privateUrl}' -O id_rsa",
 #     "wget -c '${var.publicUrl}' -O id_rsa.pub",
      "sh /home/java.sh", 
      "sh /home/useradd.sh",      

    ]
  }

}


resource "huaweicloud_images_image" "test" {
  depends_on  = [null_resource.provision]

  name        = "my_image"
  instance_id = huaweicloud_compute_instance.test.id
  description = "created by Terraform"

  tags = {
    key = "hetu-core"
    hetu = null
  }
}




