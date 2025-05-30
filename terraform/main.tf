resource "aws_instance" "my_ec2" {
  ami           = "ami-03d8b47244d950bbb" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jenkins_key.key_name

  tags = {
    Name = "Jenkins-Terraform-EC2"
  }
}