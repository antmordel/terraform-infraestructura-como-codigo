## Terraform Variables 

> :bulb: Usaremos **variables** siempre que necesitemos tener un valor estático en nuestra configuración.  
> Un cambio en el este valor estático debería producirse en solo un lugar, es decir, en la instanciación de la variable.
 
### :computer: Jerarquía de Precedencia 

**Si asignamos a una variable un valor por diferentes mecanismos, ¿cuál es la precedencia y qué valor final tendrá?**

Precedencia de menos a más, es decir, más abajo en la lista tiene precedencia sobre los primeros puntos:
1. Variables de entorno
2. Fichero `terraform.tfvars`
3. Fichero `terraform.tfvars.json`
4. Ficheros acabados en `.auto.tfvars` o `.auto.tfvars.json`, si hay más de uno, será en orden lexicográfico
5. Cualquier variable `-var` o `-var-file`, en el orden que son especificadas

