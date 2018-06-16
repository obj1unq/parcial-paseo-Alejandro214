//Nota 5(cinco): Presenta problema en el manejo del estado interno de los objetos.

//test: solo el de niños chiquitos anda
//1) Regular+. Se marea al calcular la comoidad a partir de un atributo del niño. La comoidad no se mantiene en una variable, se debe calcular
//2) Regular+. Está bien el manejo de error, pero el uso de colecciones queda incómodo y lo lleva a cometer un importante bug
//3) Regular. Presenta problemas en el manejo del estado interno de los objetos
//4) Regular+. Se confunde con el manejo de booleanos. También tiene problemas cumpliendo la funcionalidad
//5) MB
//6) MB
//7) B (delegar mejor el conocimiento de cuando un niño es pequeño)
//8) REGULAR: La estrategia está bien, el error está bien, pero el manejo del estado interno del desgaste está mal





//Esta clase no debe existir, 
//está para que el test compile al inicio del examen
//al finalizar el examen hay que borrar esta clase
class Familia {
   var ninios 
   
   method puedeSalirDePaseo()  = ninios.all({ninio=>ninio.estaListoParaSalir()})
   
   method noPuedeSalirAPasear() {
   	 if(!self.puedeSalirDePaseo()){
   	 	self.error("no puede salir a pasear")
   	 }
   }
   method prendasInfaltables() = ninios.map({ninio=>ninio.prendaInfaltable()}).asSet()
  
  //TODO: Repite el código para saber si un ninio es chiquito.
   method niniosChiquitos() = ninios.filter({ninio=>ninio.edad() <= 4})
   
   method salirDePaseo() {
   	self.noPuedeSalirAPasear()
   	ninios.forEach({ninio=>ninio.salirDePaseo()})
   }
   
  
    
   
}

class Prenda {
	
	var talle
	var desgaste //TODO Esto no sirve para todas las prendas (las pares no lo requieren)
	var nivelDeAbrigo
    
    method nivelDeDesgaste() = desgaste
    
    //TODO: el mensaje sería min(3) ya que queres el numero mas chico entre el desgaste y el 3.
    //La comodidad no depende del niño, si no de la misma prenda 
    method nivelDeComodidaParaUnNinio(unNinio) = unNinio.comodida() - self.nivelDeDesgaste().max(3)
    
	
	method talle() = talle
	
	method nivelDeAbrigo()
	
	method cambiarNivelDeAbrigo(unValor) {nivelDeAbrigo = unValor}
	
	method nivelDeCalidad(unNinio) = self.nivelDeAbrigo() + self.nivelDeComodidaParaUnNinio(unNinio)
	
	method incrementarDesgaste(unaCantidad) {desgaste += unaCantidad}
	
	method efectoDeDesgasteDeUnNinio(unNinio)
	
	
}
class PrendaPares inherits Prenda{
	var pares = #{}
	
	override method nivelDeDesgaste() = pares.sum({par=>par.nivelDeDesgaste()}) /2
	
	override method nivelDeAbrigo() = pares.sum({par=>par.nivelDeAbrigo()})  
	
	 method tieneElMismoTalle(prendaPar) = self.talleDeUnaPrendaPar(prendaPar) == 
	 self.talleDeUnaPrendaPar(pares)
	 
	 
	 method talleDeUnaPrendaPar(prendaPar) = prendaPar.map({prenda=>prenda.talle()}).asSet()
	 
	  method noTienenElMismoTalle(unPar) {
    	if(!self.tieneElMismoTalle(unPar)){
    		self.error("el elemento unPar no tienen el mismo talle   ")
    	}
    }
    override method efectoDeDesgasteDeUnNinio(unNinio) {
    	//TODO: La comodidad del niño no tiene que ver. Esta linea quedo duplicada
    	unNinio.decrementarComodidad(desgaste)
    	//TODO: Aca hay que desgastar los elementos izquierdo y derecho
    	unNinio.aumentarComodidad(2)
    	
    	
    }
	override method nivelDeComodidaParaUnNinio(unNinio) = super(unNinio) - if(unNinio.edad()<4) 1 else 0
	 
	 method izquierdo() = self.buscarUnParN(1)
	 
	 method buscarUnParN(n) = pares.find({par=> par.numeroPar() == n})
	 
	 method derecho() = self.buscarUnParN(2)
	 
	 method intercambiarPares(unPar){
	 	self.noTienenElMismoTalle(unPar)
	    var izquierdodeUnPar = unPar.izquierdo()
	 	var derechoDeUnPar = unPar.derecho()
	 	var izquierdoMio = self.izquierdo()
        var derechoMio =  self.derecho()
        self.agregarParNuevo(izquierdodeUnPar)
        self.agregarParNuevo(derechoMio)
        unPar.agregarParNuevo(izquierdoMio)
        unPar.agregarParNuevo(derechoDeUnPar)
        //TODO: Estás dejando los cuatro elementos en cada par!
        
   }
   
   
   method agregarParNuevo(par){
   	pares.add(par)
   }
   
   
}
//TODO: MALISIMA HERENCIA! que necesita de Prenda? hereda cosas que no necesita
class PrendaPar inherits Prenda{
	var property numeroPar 
	
	//TODO= NO! dice que el deault es 1, pero puede variar!
	override method nivelDeAbrigo() = 1
	
	
	override method efectoDeDesgasteDeUnNinio(unNinio) {}
}



class PrendaLiviana inherits Prenda{
	
	//TODO: Este valor debería poder ser cambiado!
	override method nivelDeAbrigo() = 1
	
	override method efectoDeDesgasteDeUnNinio(unNinio) {
		//TODO: No hay nada que modificar en el niño, y si lo hubiera esta linea quedo duplicada
		unNinio.decrementarComodidad(desgaste)
		//TODO: Esta linea que modifica el desgaste está duplicada en PrendaPEsada
		desgaste +=1
		self.sumarComodidaANinio(unNinio)
	}
	
    
	method sumarComodidaANinio(unNinio) {unNinio.aumentarComodidad(2)}
	
}


class PrendaPesada inherits Prenda{
	
	override method nivelDeAbrigo() = nivelDeAbrigo
	
	
	override method efectoDeDesgasteDeUnNinio(unNinio) {
		unNinio.decrementarComodidad(desgaste)
		desgaste +=1
	}
}


class Ninio {
	var edad
	var prendas = #{}
	//Esto no es algo que se recuerde, la comodidad se calcula según la prenda
	var comodidad 
	
	method comodidad() = comodidad
	
	method salirDePaseo() = prendas.forEach({prenda=>self.usarUnaPrenda(prenda)})
	
	method usarUnaPrenda(unaPrenda) {unaPrenda.efectoDeDesgaste()}
	
	method aumentarComodidad(unaCantidad) {comodidad+=unaCantidad}
	
	method edad() = edad
	
	method agregarPrenda(unaPrenda) {prendas.add(unaPrenda)}
	
	method prendas() = prendas
	
	method decrementarComodidad(unaCantidad) {comodidad -= unaCantidad.max(3)}
	
	method estaListoParaSalir() = 
	//TODO: EL if es innecesario! La condición es el mismo booleano que necesitás devolver!
	//Faltan los returns!
	if(self.cantidadDePrendasNecesariasParaSalir() >=self.cantidadDePrendas()){
		prendas.any({prenda=> prenda.nivelDeAbrigo()>=3}) and
		self.tieneNivelDeCalidadDePrendas()
	}else false
	
	
	//TODO: El promedio debe superar 8, no todas las prendas!
	method tieneNivelDeCalidadDePrendas() = prendas.all({prenda=>prenda.nivelDeCalidad(self) > 8 })
	
	method cantidadDePrendas() = prendas.size()
	
	method cantidadDePrendasNecesariasParaSalir() = 5
	
	method prendaInfaltable()= prendas.max({prenda=>prenda.nivelDeCalidad(self)})
}

class NinioProblematico inherits Ninio {
	var juguete
	
	override method cantidadDePrendasNecesariasParaSalir() = 4
	
	override method estaListoParaSalir() = super() and self.tieneEdadACordeAJuguete()
	
	method tieneEdadACordeAJuguete() = juguete.puedeUsajugueteNinio(self)
	
}

class Juguete{
	var property edadMinimaRecomendada
	
	var property edadMaximaRecomendada
	
	method puedeUsajugueteNinio(unNinio)= unNinio.edad() >= self.edadMinimaRecomendada() and
	self.edadMaximaRecomendada() <= unNinio.edad()
}


//Objetos usados para los talles
object xs {
}

object s {
}
object m {
	
}
object l{
	
}
object xl{
	
}