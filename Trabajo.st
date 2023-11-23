
|menu opcion salir

lista codigo productosPerfumeriaAux
listaVentas
|
TranscriptShell show.
farmacia := Farmacia crear: 'Farmacia'.
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
			codigoProd:=(Prompter prompt: 'Ingrese codigo de producto o ENTER para salir' ) asNumber.
			Transcript show: codigoProd printString ;cr .
			(farmacia productos keys includes: codigoProd ) ifTrue: [MessageBox notify: 'Producto ya registrado'.codigoProd :=0 ].
			[codigoProd=0] whileFalse: [

				Transcript clear.
				tipoProd := (Prompter prompt: 'Ingrese tipo de producto: Medicamento o Perfume (m/p)' ) asString asUppercase .
				((tipoProd='M') or: [tipoProd = 'P']) ifTrue: [
					[
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
			
							producto := ArtPerfumeria new initialize: codigoProd nombre: nombreProd descripcion: descripcionProd precio: precioProd stock: stockProd tipoArt: tipoArtProd marca: marcaProd.
						].
					farmacia addProducto: producto.] on: Error do: [:ex | MessageBox notify: 'producto ingresado incorrectamente' ].
					codigoProd:=(Prompter prompt: 'Ingrese codigo de producto o ENTER para salir' ) asNumber.
					(farmacia productos keys includes: codigoProd ) ifTrue: [MessageBox notify: 'Producto ya registrado'.codigoProd :=0 ].
					Transcript show: codigoProd printString ;cr .
					] ifFalse: [MessageBox notify: 'dato invalido'].
				].
			].


"opcion de venta"

		(opcion = 2) ifTrue: [
			Transcript clear.
			fecha:=Date today.
			hora:=Time now.
			obraSocial:=(Prompter prompt: 'Tiene obra social s/n ')asString asUppercase . 
			((obraSocial ='S') or: [obraSocial='N']) ifTrue: [
				Transcript clear.
				(obraSocial ='N') ifTrue: [obraSocial:=nil.].
				(obraSocial ='S') ifTrue: [obraSocial:=Prompter prompt: 'ingrese obra social']. "validar obra social"
				]ifFalse: [
					[((obraSocial ='S') or: [obraSocial='N'])] whileFalse: [
						MessageBox notify: 'dato invalido' .
						obraSocial := (Prompter prompt: 'Tiene obra social s/n ')asString asUppercase .
					].				
				].
			venta := Venta new initialize: (farmacia nuevoCodigoVenta) hasObraSocial: obraSocial. 
			venta setFecha: Date today setHora: Time now.
			codigoProd :=(Prompter prompt: 'Ingrese codigo producto o ENTER para finalizar' ) asNumber.
			[Transcript show: (farmacia productos at: codigoProd ) nombre ; cr.] on: Error do: [:ex | ].
			[(opcion = 2 ) and: [codigoProd ~= 0]] whileTrue: [
				
				((farmacia productos keys includes: codigoProd) and: [(farmacia productos at: codigoProd ) stock ~= 0]) ifTrue: [
					venta addProducto: (farmacia getProducto: codigoProd)] 
					ifFalse: [
						MessageBox notify: 'producto no encontrado o sin stock'.
						Transcript clear.
					].
				codigoProd :=(Prompter prompt: 'Ingrese codigo producto o ENTER para finalizar' ) asNumber .
				[Transcript show: (farmacia productos at: codigoProd ) nombre ; cr.] on: Error do: [:ex | ].
				].

			(venta detalles size > 0) ifTrue: [farmacia addVenta: venta] ifFalse: [farmacia contador: (farmacia contador - 1) ]. 
			].


		(opcion = 3) ifTrue: [	
			Transcript clear.
			sigueModificar:=1.
			farmacia regVentas do: [:venta | Transcript show: 'codigo: ', venta codigo printString, ' importe: $', venta importe printString; cr].
			[codigoVentaModificar:=(Prompter prompt: 'Ingrese codigo de venta a modificar ')asNumber] on: Error do: [:ex | MessageBox notify: 'caracter invalido'].
			[venta := farmacia getVenta: codigoVentaModificar] on: Error do: [:ex | MessageBox notify: 'venta no encontrada'. sigueModificar := 0 ].
			[sigueModificar=0] whileFalse: [
				Transcript show: '1)  Fecha '; cr.
				Transcript show: '2)  Hora '; cr.
				Transcript show: '3)  Obra Social';cr.
				Transcript show: '4)  Agregar Producto';cr.
				Transcript show: '5)  Eliminar Producto';cr. 
				Transcript show: '6)  Ver importe actual';cr. 
				Transcript show: '7)  salir';cr.

				detalleModificar:=(Prompter prompt: 'Que desea hacer?') asNumber .
				Transcript clear.
				
				(detalleModificar=1) ifTrue: [
					Transcript clear.
					[fecha:= (Prompter prompt: 'Ingrese fecha: (DDMMYYYY)')asNumber .
					"modificar fecha"
					venta fecha: (Date fromString: fecha asString)] on: Error do: [:ex | MessageBox notify: 'datos ingresados incorrectos' ].
					Transcript clear.
				].
				(detalleModificar=2) ifTrue: [
					Transcript clear.
					hora:= Prompter prompt: ('Ingrese hora: (hh:mm)') .
					"modificar hora"
					[venta hora: (Time fromString: hora)] on: Error do: [:ex | MessageBox notify: 'datos ingresados incorrectos' ].
				].
		
				(detalleModificar=3) ifTrue: [
					Transcript clear.
					[Transcript show: 'Obra Social actual: ', venta obraSocial]on: Error do: [:ex | Transcript show: 'Obra Social actual: '].
					venta obraSocial: (Prompter prompt: ('Ingrese nueva obra social')asString ).
					Transcript clear.
				].

				(detalleModificar=4) ifTrue: [
					Transcript clear.
					codigoProd := Prompter prompt: 'Ingrese codigo de producto'.
					[(farmacia productos keys includes: codigoProd asNumber)ifTrue: [
						((farmacia productos at: codigoProd asNumber) stock = 0)ifTrue: [MessageBox notify: 'no hay stock disponible'] ifFalse: [venta addProducto: (farmacia getProducto: codigoProd asNumber)].
						]ifFalse:[
						MessageBox notify: 'producto no encontrado'.
						]] on: Error do: [:ex | MessageBox notify: 'codigo ingresado invalido' ].
				].

				(detalleModificar=5) ifTrue: [
					"aca va la funcion de eliminar producto, que actualizaria el importe total"
					Transcript clear.
					codigoProd := (Prompter prompt: 'Ingrese codigo de producto')asNumber. "comparar codigos y buscar"
					venta delProducto: (farmacia getProducto: codigoProd).
					
					
				].
				
				
				(detalleModificar=6) ifTrue: [
					"Mostrar importe actualizado"
					Transcript clear.
					Transcript show: 'Importe: $' ,venta importe printString; cr; cr.
					
				].
				
				(detalleModificar=7) ifTrue: [
					Transcript clear.
					salir := MessageBox confirm: 'Confirmar salir del menu'.
					salir ifTrue: [sigueModificar:=0].	
					
				].
			].
		].

		(opcion = 4) ifTrue: [	
			Transcript clear.
			codigoMed:=(Prompter prompt: 'Ingrese codigo de producto (medicamento) ' )asNumber .
			"TODO: hacer las validaciones para no meter un codigo que no exista"
			(((farmacia productos keys) includes: codigoMed) and: [(farmacia productos at: codigoMed) getTipo = 'medicamento']) ifFalse: [
				MessageBox notify: 'Codigo no encontrado'.
			] ifTrue: [
				(farmacia regVentas select: [:venta | (venta detalles keys) includes: codigoMed ]) keys do: [:key | 
				Transcript show: 'Venta codigo: ', key printString, ' eliminada.'; cr.
				farmacia regVentas removeKey: key
				].
				MessageBox notify: 'Precione Aceptar para continuar'.
			].
		].


		(opcion = 5) ifTrue: [	
			Transcript clear.
			obraSocial :=(Prompter prompt: 'Ingrese obra social' ) asLowercase . "buscar obra social"
			"Segun obra social, buscar IMPORTE asociado al medicamento y  aplicar descuento"
			(farmacia regVentas select: [:venta | (venta obraSocial = obraSocial) and: [venta tieneDescuento not] ])keys do: [:key |
				subTotal := 0.
				Transcript show: 'venta codigo: ', key printString, ' : $', (farmacia regVentas at: key) importe printString, ' -> $'.
				((farmacia regVentas at: key) detalles select: [:detalle | detalle producto getTipo = 'medicamento']) do: [:detalle | 
					subTotal := subTotal + detalle producto precio * 0.2 * detalle cantidad.
				].
				(farmacia regVentas at: key) importe: ((farmacia regVentas at: key) importe - subTotal).
				(farmacia regVentas at: key) tieneDescuento: true.
				Transcript show: (farmacia regVentas at: key) importe printString; cr.
			].
			MessageBox notify: 'Precione Aceptar para continuar'.
		].

		(opcion = 6) ifTrue: [	
			Transcript clear.
			tipoArtProd :=(Prompter prompt: 'Ingrese tipo de articulo' ). "buscar tipo de articulo"
			[porcentaje := (Prompter prompt: 'Ingrese porcentaje a aplicar (positivo si incrementa y negativo si reduce el precio)')asNumber]on: Error do: [:ex | MessageBox notify:'Dato invalido'. porcentaje := 0].
			"aplicar porcentaje"
			(porcentaje ~= 0) ifTrue: [
				[((farmacia productos select: [:producto | producto getTipo = 'artPerfumeria']) select: [:producto | producto tipoArticulo = tipoArtProd]) keys do: [:key | 
					Transcript show: 'codigo: ', key printString, ' - ', (farmacia productos at: key) precio printString,' -> '.
					precioAux := (farmacia productos at: key) precio.
					(farmacia productos at: key) precio: (precioAux + (porcentaje / 100 * precioAux)).
					Transcript show: (farmacia productos at: key) precio printString; cr.
				]]on: Error do: [:ex | MessageBox notify:'No se encontro el tipo de articulo'].
			].
			MessageBox notify: 'Precione Aceptar para continuar'.
		].

		(opcion = 7) ifTrue: [	
			Transcript clear.
			drogaProd :=(Prompter prompt: 'Ingrese droga para eliminar medicamento' ). "buscar droga en comun y eliminar medicamento"
			Transcript show: 'Producto/s eliminados:';cr.
			((farmacia productos select: [:producto | producto getTipo = 'medicamento']) select: [:producto | producto droga = drogaProd]) keys do: [:key | 
				Transcript show: 'codigo: ', key printString, ' nombre: ', (farmacia productos at: key) nombre; cr.
				farmacia productos removeKey: key
			].
			MessageBox notify: 'Precione Aceptar para continuar'.

		].

		(opcion = 8) ifTrue: [	
			Transcript clear.
			Transcript show: 'Producto/s eliminados:';cr.
			marcaProd :=(Prompter prompt: 'Ingrese marca de perfume a borrar' ). "buscar marca en comun y eliminar perfume"
			((farmacia productos select: [:producto | producto getTipo = 'artPerfumeria']) select: [:producto | producto marca = marcaProd]) keys do: [:key | 
				Transcript show: 'codigo: ', key printString, ' nombre: ', (farmacia productos at: key) nombre; cr.
				farmacia productos removeKey: key
			].
			MessageBox notify: 'Precione Aceptar para continuar'.
		].

		(opcion = 9) ifTrue: [	
			Transcript clear.
			obraSocial :=(Prompter prompt: 'Ingrese obra social para listar medicamentos' ). "buscar obra social en comun y mostrar la lista"
			medicamentos := Set new.
			((farmacia regVentas select: [:venta | venta obraSocial = obraSocial]) do: [:venta | 
				(venta detalles do: [:detalle | 
					((detalle producto getTipo) = 'medicamento') ifTrue: [medicamentos add: (detalle producto)]])]).
			medicamentos do: [:medicamento | Transcript show: medicamento nombre; cr ].
			MessageBox notify: 'Precione Aceptar para continuar'.
		].
		(opcion = 10) ifTrue: [
			Transcript clear.
			lista := OrderedCollection new.

			productosPerfumeriaAux := Dictionary new.
			farmacia regVentas do: [:venta | venta detalles do: [:detalle | ((detalle producto getTipo) = 'artPerfumeria') ifTrue: [
				productosPerfumeriaAux at: detalle producto codigo add: detalle cantidad.
			] ] ].
			(productosPerfumeriaAux asSortedCollection reverse) do: [:cant | 
				codigo := productosPerfumeriaAux keyAtValue: cant.
				productosPerfumeriaAux removeKey: codigo.
				lista add: codigo.
			].
			[(lista size >= 3) ifTrue: [
				(1 to: 3) do: [:index| Transcript show: ((farmacia productos at: (lista at: index )) nombre ) ; cr ].
				] ifFalse: [
				lista do: [:index| Transcript show: ((farmacia productos at: (index)) nombre ) ; cr ].
				]] on: Error do: [:ex | Transcript show: 'Elementos no encontrados'; cr].
			MessageBox notify: 'Precione Aceptar para continuar'.
		].
		(opcion = 11) ifTrue: [
			Transcript clear.
			fecha:= Prompter prompt: ('Ingrese fecha: (DDMMYYYY)').
			listaVentas := Dictionary new.
			(farmacia regVentas select: [:venta | venta fecha asDDMMYYYYstring = fecha]) do: [:venta | venta detalles do: [:detalle | listaVentas at: detalle producto codigo add: detalle cantidad ]].
			listaVentas keys do: [:key| [Transcript show: ((farmacia productos at: key) nombre ). Transcript show:'   ',(listaVentas at: key )printString, ' unidades'; cr ]on: Error do: [:ex | Transcript show: 'Elementos no encontrados'; cr]].
			MessageBox notify: 'Precione Aceptar para continuar'.
		].
		((0 to: 11) includes: opcion) ifFalse: [
			Transcript clear.
			MessageBox notify: 'opcion invalida'.
		].

]. "Corchete menu"