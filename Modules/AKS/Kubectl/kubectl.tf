

resource "kubectl_manifest" "deploy" {
  yaml_body =file("serviceaccount.yaml")
  force_new="false"
 
  
}
