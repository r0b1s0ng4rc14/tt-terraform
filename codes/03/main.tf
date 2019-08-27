provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}


resource "aws_s3_bucket" "bucket" {
    bucket = "${var.bucket}"
    acl    = "private"

    tags = "${var.tags}"
}


#liberação de acesso 
resource "aws_security_group" "fw-terraform" {
  name        = "fw-terraform"
  description = "Libera geral ssh e nginx"
  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    
  }
}

#Chave de acesso criado via ssh-keygen

resource "aws_key_pair" "ssh_access" {
  key_name   = "ssh_access"
  public_key = "ssh-rsa sua_chave_pub_gerada_via_ssh_keygen"
}
#dependência implícita, interpolação de atributos e recursos.
resource "aws_eip" "ip_address" {
    instance = "${aws_instance.ec2.id}"
  
}

#dependência explicita, interpolação de atributos e recursos.
resource "aws_instance" "ec2" {
    ami = "ami-07d0cf3af28718ef8"
    instance_type ="t2.micro"
    key_name = "${aws_key_pair.ssh_access.key_name}"
    security_groups = ["${aws_security_group.fw-terraform.name}"]
    tags = "${var.tags}"
    depends_on = ["aws_s3_bucket.bucket"]

provisioner "remote-exec" {
    inline = [
        "sudo apt-get update -y",
        "sudo apt-get install nginx -y"
    ]
  
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file("devproj")}"
    agent = "false"
  }
}


}


