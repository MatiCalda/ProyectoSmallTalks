
|menu opcion salir


|

TranscriptShell show.
farmacia := Farmacia new initialize: 'Farmacia'.
menu:=1.

	[menu =1] whileTrue: [
		Transcript clear.
		Transcript show:  '0) SALIR'; cr.
		Transcript show:  '1) Agregar producto'; cr.
		Transcript show:  '2) Registrar venta' ;cr.
		Transcript show:  '3) Modificar detalle de venta' ;cr.
		Transcript show:  '4) Eliminar registro de venta por medicamento' ;cr.
		Transcript show:  '5) Aplicar 20% descuento por obra social' ;cr.
		Transcript show:  '6) Modificar importe por artriculo de perfumeria segun porcentaje' ;cr.
		Transcript show:  '7) Eliminar medicamento segun droga' ;cr.
		Transcript show:  '8) Eliminar perfume segun marca' ;cr.
		Transcript show:  '9) Lista de medicamentos segun obra social' ; cr.
		Transcript show:  '10) Generar ranking de tres perfumes mas vendidos' ;cr.
		Transcript show:  '11) Listar total de productos vendidos por dia' ;cr.

		opcion:= (Prompter prompt: 'Seleccione una opcion 0-11 ') asNumber .

"opcion de salir"
		(opcion = 0) ifTrue: [
			Transcript clear.
			salir := MessageBox confirm: 'Confirmar salir del menu'.
			salir ifTrue: [menu:=0].
			].


"opcion de agregar producto"

		(opcion = 1) ifTrue: [
			sigueAgregar:='S'.
			[sigueAgregar='S'] whileTrue: [

				Transcript clear.
				tipoProd := (Prompter prompt: 'Ingrese tipo de producto: Medicamento o Perfume (m/p)' ) asString asUppercase .
				((tipoProd='M') or: [tipoProd = 'P']) ifTrue: [

					codigoProd:=(Prompter prompt: 'Ingrese codigo de producto' ) asNumber.
					Transcript show: codigoProd printString ;cr .

					nombreProd:=(Prompter prompt: 'Ingrese nombre de producto' ) asString.
					Transcript show: nombreProd; cr.

					stockProd:=(Prompter prompt: 'Ingrese stock de producto' ) asNumber.
					Transcript show: stockProd printString ;cr .

					descripcionProd:=(Prompter prompt: 'Ingrese descripcion de producto' ) asString.
					Transcript show: descripcionProd; cr.

					precioProd:=(Prompter prompt: 'Ingrese precio de producto' ) asNumber.
					Transcript show: precioProd printString ;cr .

						(tipoProd='M') ifTrue: [
							drogaProd:=(Prompter prompt: 'Ingrese droga' ) asString.
							Transcript show: drogaProd; cr.

							laboratorioProd:=(Prompter prompt: 'Ingrese el laboratorio' ) asString.
							Transcript show: laboratorioProd;cr.		
							
							producto := Medicamento new initialize: codigoProd nombre: nombreProd descripcion: descripcionProd precio: precioProd stock: stockProd droga: drogaProd laboratorio: laboratorioProd.
						].

						(tipoProd='P') ifTrue: [

							tipoArtProd:=(Prompter prompt: 'Ingrese tipo de articulo de perfumeria' ) asString.
							Transcript show: tipoArtProd; cr.

							marcaProd:=(Prompter prompt: 'Ingrese la marca del producto de perfumeria' ) asString.
							Transcript show: marcaProd; cr.	
			
							producto := Medicamento new initialize: codigoProd nombre: nombreProd descripcion: descripcionProd precio: precioProd stock: stockProd tipoArt: tipoArtProd marca: marcaProd.
						].
					] ifFalse: [MessageBox notify: 'dato invalido'].
				 farmacia addProducto: producto.
				sigueAgregar:=(Prompter prompt: 'Desea agregar mas productos s/n') asString asUppercase .
			].

	].


"opcion de venta"

		sigueVenta:='S'.
		(opcion = 2) ifTrue: [
			Transcript clear.
			codigoVenta:=(Prompter prompt: 'Ingrese codigo de venta' ) asNumber. "falta comparar los codigos de venta ingresados anteriormente"
			Transcript show: codigoVenta printString ;cr .
			fecha:=Date today.
			hora:=Time now.
		 
			obraSocial:=(Prompter prompt: 'Tiene obra social s/n ')asString asUppercase . 
			((obraSocial ='S') or: [obraSocial='N']) ifTrue: [
				Transcript clear.
				(obraSocial ='S') ifTrue: [obraSocial:=(Prompter prompt: 'ingrese obra social')asString]. "validar obra social"
				(obraSocial ='N') ifTrue: [obraSocial:=nil.].
				]ifFalse: [
					[((obraSocial ='S') or: [obraSocial='N'])] whileFalse: [
						MessageBox notify: 'dato invalido' .
						obraSocial := (Prompter prompt: 'Tiene obra social s/n ')asString asUppercase .
				].				
			].
		venta := Venta new initialize: codigoVenta hasObraSocial: obraSocial. 
		].
		[(opcion = 2 ) and: [sigueVenta='S']] whileTrue: [
			codigoProd :=(Prompter prompt: 'Ingrese codigo producto' ) asNumber .
			Transcript show: codigoProd printString ; cr.
			"TODO: VALIDAR QUE EL CODIGO EXISTE"
			producto := farmacia getProducto: codigoProd.
			venta addProducto: producto.

			sigueVenta:=(Prompter prompt: 'Desea realizar otra venta s/n ')asString asUppercase .
			
			
			].
		farmacia addVenta: venta.

		(opcion = 3) ifTrue: [	
			Transcript clear.
			sigueModificar:='S'.
			[sigueModificar='S'] whileTrue: [
			
				codigoVentaModificar:=(Prompter prompt: 'Ingrese codigo de venta a modificar ')asNumber . "validar codigos"
				Transcript show: codigoVentaModificar printString ; cr.
				Transcript show: '1)  Fecha '; cr.
				Transcript show: '2)  Hora '; cr.
				Transcript show: '3)  Obra Social';cr.
				Transcript show: '4)  Agregar cantidad de Producto';cr.
				Transcript show: '5)  Eliminar Producto';cr. 
				Transcript show: '6)  Ver importe actual';cr. 
				Transcript show: '7)  salir';cr.

				detalleModificar:=(Prompter prompt: 'Que desea modificar?') asNumber .
				
				(detalleModificar=1) ifTrue: [
					Transcript clear.
					fecha:= Prompter prompt: ('Ingrese fecha: (dd/mm/aaaa) ').
					"modificar fecha"
					fecha:= (Date fromString: fecha).
				].
			
				(detalleModificar=2) ifTrue: [
					Transcript clear.
					hora:= Prompter prompt: ('Ingrese hora: (hh:mm')  .
					"modificar hora"
					hora:= (Time fromString: hora).
				].
		
				(detalleModificar=3) ifTrue: [
					Transcript clear.
					obraSocial:= Prompter prompt: ('Ingrese nueva obra social'). 
				].

				(detalleModificar=4) ifTrue: [
					Transcript clear.
					codigoProd := Prompter prompt: ('Ingrese codigo de producto') asNumber. "comparar codigos y buscar"
					cantidadAgregar:=Prompter prompt: ('Ingrese  cantidad del producto') asNumber . "modificar stock de productos productos"
					
				].

				(detalleModificar=5) ifTrue: [
					"aca va la funcion de eliminar producto, que actualizaria el importe total"
					Transcript clear.
					
				].
				
				
				(detalleModificar=6) ifTrue: [
					"Mostrar importe actualizado"
					Transcript clear.
					
				].
				
				(detalleModificar=7) ifTrue: [
				Transcript clear.
				salir := MessageBox confirm: 'Confirmar salir del menu'.
				salir ifTrue: [opcion:=0].	
					
				].
				
			sigueModificar:=(Prompter prompt: 'Desea modificar otro producto? s/n ')asString asUppercase .
			
			].

	].

		(opcion = 4) ifTrue: [	
			Transcript clear.
			sigueReg:='S'.
			[sigueReg='S'] whileTrue: [
				codigoProd:=(Prompter prompt: 'Ingrese codigo de producto (medicamento) ' ).
				"buscar medicamento y borrar venta"
				sigueReg:=(Prompter prompt: 'Desea eliminar otra venta? s/n ') asString asUppercase .
			
			].
	
	].


		(opcion = 5) ifTrue: [	
			Transcript clear.
			sigueDesc:='S'.
			[sigueDesc='S'] whileTrue: [
				obraSocial :=(Prompter prompt: 'Ingrese obra social' ). "buscar obra social"
				"Segun obra social, buscar IMPORTE asociado al medicamento y  aplicar descuento"
				sigueDesc :=(Prompter prompt: 'Desea aplicar otro 20% de descuentop ? s/n ') asString asUppercase .
					
			].
			

	].


		(opcion = 6) ifTrue: [	
				Transcript clear.
				siguePorc:='S'.
				[siguePorc='S'] whileTrue: [
					tipoArtProd :=(Prompter prompt: 'Ingrese tipo de articulo' ). "buscar tipo de articulo"
					"aplicar porcentaje"
					sigueDesc :=(Prompter prompt: 'Desea aplicar 20% de descuento a otro producto? s/n ') asString asUppercase .
							
				].
					

		].

		(opcion = 7) ifTrue: [	
					Transcript clear.
					sigueMed:='S'.
					[sigueMed='S'] whileTrue: [
						drogaProd :=(Prompter prompt: 'Ingrese droga para eliminar medicamento' ). "buscar droga en comun y eliminar medicamento"
						 sigueMed:=(Prompter prompt: 'Desea eliminar otro medicamento s/n ') asString asUppercase .
									
					].
							

			].


		(opcion = 8) ifTrue: [	
					Transcript clear.
					siguePerfume:='S'.
					[siguePerfume='S'] whileTrue: [
						marcaProd :=(Prompter prompt: 'Ingrese marca de perfume a borrar' ). "buscar marca en comun y eliminar perfume"
						 siguePerfume:=(Prompter prompt: 'Desea eliminar otro perfume s/n ') asString asUppercase .
									
					].
							

			].


		(opcion = 10) ifTrue: [	
					Transcript clear.
					salir:='N'.
					obraSocial :=(Prompter prompt: 'Ingrese obra social para listar medicamentos' ). "buscar obra social en comun y mostrar la lista"
						

			


].
]. "Corchete menu"


