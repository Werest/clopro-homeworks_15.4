# clopro-homeworks_15.4

# Домашнее задание к занятию «Кластеры. Ресурсы под управлением облачных провайдеров»

### Цели задания 

1. Организация кластера Kubernetes и кластера баз данных MySQL в отказоустойчивой архитектуре.
2. Размещение в private подсетях кластера БД, а в public — кластера Kubernetes.

---
## Задание 1. Yandex Cloud

1. Настроить с помощью Terraform кластер баз данных MySQL.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно подсеть private в разных зонах, чтобы обеспечить отказоустойчивость. 
 - Разместить ноды кластера MySQL в разных подсетях.
 - Необходимо предусмотреть репликацию с произвольным временем технического обслуживания.
 - Использовать окружение Prestable, платформу Intel Broadwell с производительностью 50% CPU и размером диска 20 Гб.
 - Задать время начала резервного копирования — 23:59.
 - Включить защиту кластера от непреднамеренного удаления.
 - Создать БД с именем `netology_db`, логином и паролем.

2. Настроить с помощью Terraform кластер Kubernetes.

 - Используя настройки VPC из предыдущих домашних заданий, добавить дополнительно две подсети public в разных зонах, чтобы обеспечить отказоустойчивость.
 - Создать отдельный сервис-аккаунт с необходимыми правами. 
 - Создать региональный мастер Kubernetes с размещением нод в трёх разных подсетях.
 - Добавить возможность шифрования ключом из KMS, созданным в предыдущем домашнем задании.
 - Создать группу узлов, состояющую из трёх машин с автомасштабированием до шести.
 - Подключиться к кластеру с помощью `kubectl`.
 - *Запустить микросервис phpmyadmin и подключиться к ранее созданной БД.
 - *Создать сервис-типы Load Balancer и подключиться к phpmyadmin. Предоставить скриншот с публичным адресом и подключением к БД.

---
<img width="1127" height="1326" alt="1" src="https://github.com/user-attachments/assets/45dae016-1d92-4f71-b0f3-15cdd5c1454f" />
<img width="1776" height="327" alt="2" src="https://github.com/user-attachments/assets/29c5741c-79a3-4499-aa97-a81640bf48c9" />
<img width="1600" height="354" alt="3" src="https://github.com/user-attachments/assets/d186e255-c976-476a-8421-3f3a3d34838d" />
<img width="714" height="318" alt="4" src="https://github.com/user-attachments/assets/a53e164f-97ca-4db0-9277-15f30704e8ba" />
<img width="2076" height="938" alt="5" src="https://github.com/user-attachments/assets/d18bcdfc-2837-4fae-9432-f8231b3a5ffd" />
<img width="1331" height="1100" alt="6" src="https://github.com/user-attachments/assets/ccc1fcfb-0aa8-48fe-836a-30ed4a8b7c06" />
<img width="1244" height="842" alt="7" src="https://github.com/user-attachments/assets/4b197847-c119-48bd-af9f-bf23e8381935" />
<img width="1566" height="519" alt="8" src="https://github.com/user-attachments/assets/67f45a8a-25ce-4622-b8b1-c299b904d50c" />
<img width="1909" height="647" alt="9" src="https://github.com/user-attachments/assets/66c890cd-f12a-4bb1-8dc3-2e4298d9316d" />
<img width="1309" height="791" alt="10" src="https://github.com/user-attachments/assets/c96c65ae-03c6-40e3-9f5a-daaf725e5054" />
<img width="2030" height="468" alt="11" src="https://github.com/user-attachments/assets/a41bce27-dfef-4736-bf0e-035542c9ddf7" />

Попытка destroy
<img width="1439" height="188" alt="image" src="https://github.com/user-attachments/assets/4bcb9f4e-cc2f-4b40-a566-67a25bef0aca" />


---

<img width="1253" height="960" alt="k8-1" src="https://github.com/user-attachments/assets/99407d9b-dd38-4f90-8cdb-b3d7947e37e8" />
<img width="850" height="347" alt="k8-2" src="https://github.com/user-attachments/assets/373f4305-ff23-4cf6-b7f5-9cf845c7c013" />
<img width="1211" height="792" alt="k8-3" src="https://github.com/user-attachments/assets/650a1273-22a5-4798-8cf2-f75815281340" />
<img width="1612" height="1106" alt="k8-4" src="https://github.com/user-attachments/assets/0b4c595f-4be7-4340-9838-dcd6a7d56963" />
<img width="1296" height="1283" alt="k8-5" src="https://github.com/user-attachments/assets/21902855-227d-4ed5-818b-011cd14f5c1d" />

---

Полезные документы:

- [MySQL cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/mdb_mysql_cluster).
- [Создание кластера Kubernetes](https://cloud.yandex.ru/docs/managed-kubernetes/operations/kubernetes-cluster/kubernetes-cluster-create)
- [K8S Cluster](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster).
- [K8S node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group).

--- 
## Задание 2*. Вариант с AWS (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

1. Настроить с помощью Terraform кластер EKS в три AZ региона, а также RDS на базе MySQL с поддержкой MultiAZ для репликации и создать два readreplica для работы.
 
 - Создать кластер RDS на базе MySQL.
 - Разместить в Private subnet и обеспечить доступ из public сети c помощью security group.
 - Настроить backup в семь дней и MultiAZ для обеспечения отказоустойчивости.
 - Настроить Read prelica в количестве двух штук на два AZ.

2. Создать кластер EKS на базе EC2.

 - С помощью Terraform установить кластер EKS на трёх EC2-инстансах в VPC в public сети.
 - Обеспечить доступ до БД RDS в private сети.
 - С помощью kubectl установить и запустить контейнер с phpmyadmin (образ взять из docker hub) и проверить подключение к БД RDS.
 - Подключить ELB (на выбор) к приложению, предоставить скрин.

Полезные документы:

- [Модуль EKS](https://learn.hashicorp.com/tutorials/terraform/eks).

### Правила приёма работы

Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
Файл README.md должен содержать скриншоты вывода необходимых команд, а также скриншоты результатов.
Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
