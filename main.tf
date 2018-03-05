provider "aws" {
  region = "us-west-1"
  access_key = "${var.AWS_ACCESS_KEY}"
  secret_key = "${var.AWS_SECRET_KEY}"
}

data "aws_security_group" "sec_group" {
  id = "${var.security_group}"
}

output "vpc_id" { value = "${data.aws_security_group.sec_group.vpc_id}"}

resource "aws_key_pair" "personal" {
  key_name   = "North"
  public_key = "${file("North.pem")}"
}

data "aws_ami" "ubuntu" {
  most_recent=true
  filter{
    name ="name"
    values =["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter{
    name = "virtualization-type"
    values =["hvm"]
  
  }
  owners =["099720109477" ]
}

resource "aws_instance" "web" {
  ami ="${data.aws_ami.ubuntu.id}"
  instance_type= "t2.micro"
  key_name="Ncali"
  security_groups=["${data.aws_security_group.sec_group.name}"]

  tags{
    Name = "helloworld"
  }
}



