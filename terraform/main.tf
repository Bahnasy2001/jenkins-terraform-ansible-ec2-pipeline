resource "aws_instance" "my_ec2" {
  ami           = "ami-02b7d5b1e55a7b5f1" 
  instance_type = "t2.micro"
  key_name      = aws_key_pair.jenkins_key.key_name

  tags = {
    Name = "Jenkins-Terraform-EC2"
  }
}