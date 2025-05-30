resource "aws_key_pair" "jenkins_key" {
  key_name   = "my-jenkins-key"
  public_key = file(var.public_key_path)
}