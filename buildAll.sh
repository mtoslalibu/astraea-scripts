cd /local/java-web-servlet-filter
git pull
sudo ./mvnw clean install -Dlicense.skip=true -Dcheckstyle.skip -DskipTests=true

cd /local/java-spring-web
git pull
sudo ./mvnw clean install -Dlicense.skip=true -Dcheckstyle.skip -DskipTests=true

cd /local/java-spring-jaeger
git pull
sudo ./mvnw clean install -Dlicense.skip=true -Dcheckstyle.skip -DskipTests=true

cd /local/train-ticket
sudo mvn clean package -Dmaven.test.skip=true
sudo docker-compose build

sudo docker-compose up -d
