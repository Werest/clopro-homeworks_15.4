# Создание KMS-ключа для шифрования Kubernetes
resource "yandex_kms_symmetric_key" "k8s_key" {
  name              = "k8s-encryption-key"
  description       = "KMS key for Kubernetes cluster encryption"
  default_algorithm = "AES_256"
  rotation_period   = "720h"  # 30 дней
}

# Предоставление сервис-аккаунту прав на использование ключа
resource "yandex_kms_symmetric_key_iam_binding" "k8s_key_encrypter_decrypter" {
  symmetric_key_id = yandex_kms_symmetric_key.k8s_key.id
  role             = "kms.keys.encrypterDecrypter"
  members          = [
    "serviceAccount:${yandex_iam_service_account.k8s_nodes.id}"
  ]
}