## Diferencia _Terraform Provider_ y _Terraform Resource_

> :bulb: Terraform se basa en plugins, de los cuales los más importantes son los _providers_  
>  Un _resource_ es un bloque de código que describe uno o más objetos en nuestra infraestructura

<figure>
  <img src="./tf-resource-diagram.svg">
  <figcaption><sub>Fig. 1 - Esquema de la interacción entre componentes Terraform</sub></figcaption>
</figure>
<p><br /></p>

- **Terraform Core**: Binario o CLI que nosotros ejecutamos al escribir `terraform`
- **Terraform Provider**: Binario estático que se comunica con el *core* usando RPC. Los *providers* tienen las
  siguientes responsabilidades:  (1) inicializar las bibliotecas para hacer llamadas a la API de nuestra infraestructura
  (AWS en el ejemplo); (2) autenticación con nuestra infraestructura; y (3) definir los _resources_ que se relacionarán
  con servicios específicos de la infraestructura

### :computer: Ejemplo 

```HCL
provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "mi_servidor" {
  ami                    = "ami-0e169fa5b2b2f88ae"
  instance_type          = "t2.micro"
}
```
En el ejemplo anterior declara un provider `aws` y un recurso `aws_instance`. Con el provider decimos los recursos que
podemos instanciar y en qué infraestructura. Con el recurso estamos referenciando a una instancia en nuestra cuenta de
AWS. En el caso de no existir, esta instancia será creada.
