provider "aws" {
    access_key ="sua_access_key"
    secret_key = "seu_secret_key"
    region = "us-east-1"
}

#dependência implícita, interpolação de atributos e recursos.
resource "aws_eip" "ip_address" {
    instance = "${aws_instance.ec2.id}"
      
}

resource "aws_instance" "ec2" {
    ami = "ami-07d0cf3af28718ef8"
    instance_type ="t2.micro"
  
}
