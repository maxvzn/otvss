# worker/setup_worker.sh

# Запуск общих команд
source ../common_setup.sh

# Установка Docker
sudo apt install -y docker.io
sudo systemctl enable docker
sudo systemctl restart docker

# Настройка Docker для Kubernetes
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
}
EOF

sudo systemctl restart docker

# Установка Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Присоединение к кластеру
# После запуска скрипта на мастер-ноде, скопируйте команду kubeadm join и выполните её здесь
# Пример:
# sudo kubeadm join <master-ip>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
