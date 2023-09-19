# crushftp

> Build docker
sudo docker build -t docker.crossinx.com/crush-ftp:10-x .

> Push docker
docker push docker.crossinx.com/crush-ftp:10-

> Deploy command:
cd helm/crush-ftp && helm upgrade --install crush-ftp -n crushftp --set 'app.deployment.container.image.tag=10-8' -f values.yaml .