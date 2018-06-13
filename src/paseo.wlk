

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
  
   method niniosChiquitos() = ninios.filter({ninio=>ninio.edad() <= 4})
   
   method salirDePaseo() {
   	self.noPuedeSalirAPasear()
   	ninios.forEach({ninio=>ninio.salirDePaseo()})
   }
   
  
    
   
}

class Prenda {
	
	var talle
	var desgaste 
	var nivelDeAbrigo
    
    method nivelDeDesgaste() = desgaste
    
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
    	unNinio.decrementarComodidad(desgaste)
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
        
   }
   
   
   
   method agregarParNuevo(par){
   	pares.add(par)
   }
   
   
}
class PrendaPar inherits Prenda{
	var property numeroPar 
	
	override method nivelDeAbrigo() = 1
	
	override method efectoDeDesgasteDeUnNinio(unNinio) {}
}



class PrendaLiviana inherits Prenda{
	
	override method nivelDeAbrigo() = 1
	
	override method efectoDeDesgasteDeUnNinio(unNinio) {
		unNinio.decrementarComodidad(desgaste)
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
	if(self.cantidadDePrendasNecesariasParaSalir() >=self.cantidadDePrendas()){
		prendas.any({prenda=> prenda.nivelDeAbrigo()>=3}) and
		self.tieneNivelDeCalidadDePrendas()
	}else false
	
	
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