| menu opcion unaAgencia unDni unCliente unPaquete unIdReserva unaReserva aux reserva reservasPorPaquete |

unaAgencia := Agencia crearAgencia: 1 nombre: 'Mi Agencia' direccion: 'Hipolito Yrigoyen 1702' correoElectronico: 'Travel@gmail.com' listaClientes: OrderedCollection new listaEmpleados: OrderedCollection new listaReservas: OrderedCollection new listaPaquetes: OrderedCollection new.
unIdReserva := 0.0.
menu := true.
reservasPorPaquete := Dictionary new.

"Agregar paquetes"
paquete := PaqueteTuristico crearPaquete: 1 idGuia: 1 origen: 'quilmes' destino: 'Chascomuss' cupo: 4 fechaInicio: '2023-10-16' fechaFin: '2023-10-16' precio: 200.
unaAgencia agregarPaquete: paquete.
paquete := PaqueteTuristico crearPaquete: 3 idGuia: 3 origen: 'Ezeiza' destino: 'Rosario' cupo: 30 fechaInicio: '2023-10-16' fechaFin: '2023-10-21' precio: 1200.
unaAgencia agregarPaquete: paquete.
paquete := PaqueteTuristico crearPaquete: 4 idGuia: 3 origen: 'varela' destino: 'Camboriu' cupo: 2 fechaInicio: '2023-10-16' fechaFin: '2023-10-24' precio: 600.
unaAgencia agregarPaquete: paquete.
paquete := PaqueteTuristico crearPaquete: 5 idGuia: 3 origen: 'Peru' destino: 'Rosario' cupo: 1 fechaInicio: '2023-10-16' fechaFin: '2023-10-30' precio: 1200.
unaAgencia agregarPaquete: paquete.

[menu] whileTrue: [
    Transcript show: '===================== MENU de Agencia ====================='; cr.
    Transcript show: '1. Reservar paquete por ID.'; cr.
    Transcript show: '2. Ver reservas del cliente.'; cr.
    Transcript show: '3. Dar de baja reserva.'; cr.
    Transcript show: '0. Salir'; cr.

    opcion := (Prompter prompt: 'Ingrese una opci�n: ') asNumber.
    Transcript show: 'Se ingres� la opci�n: ', opcion printString; cr.

    (opcion = 1) ifTrue: [
        unaAgencia eliminarPaquetesAgotados.
        unDni := (Prompter prompt: 'Ingrese el DNI de un cliente.') asNumber.
        unCliente := unaAgencia getClienteByDNI: unDni.

        (unCliente = nil) ifTrue: [
            Transcript show: 'El DNI no se encuentra, por favor reg�strelo.'; cr.
            unDni := (Prompter prompt: 'Ingrese su DNI') asNumber.
            unNombre := Prompter prompt: 'Ingrese su nombre'.
            unApellido := Prompter prompt: 'Ingrese su apellido'.
            unEmail := Prompter prompt: 'Ingrese un email'.
            unosPuntos := 0.

            "Instanciar cliente."
            unCliente := Cliente CrearCliente: unDni nombre: unNombre apellido: unApellido email: unEmail puntosAcumulados: unosPuntos.

            "Mostrar datos del cliente creado"
            Transcript show: '=================== Cliente creado exitosamente ==================='; cr.
            Transcript show: 'Apellido: ', unCliente verApellido; cr.
            Transcript show: 'Nombre: ', unCliente verNombre; cr.
            Transcript show: 'DNI: ', unCliente verDni printString; cr.
            Transcript show: 'Email: ', unCliente verEmail ; cr.
            Transcript show: 'Puntos acumulados: ', unCliente verPuntosAcumulados printString; cr.

            "Agregar cliente a la agencia"
            unaAgencia agregarCliente: unCliente.
        ].

	Transcript show: 'Lista de Paquetes Disponibles:'; cr.
            unaAgencia verListaPaquetes do: [:each | 
                Transcript show: 'ID: ', each verIdPaquete printString, 
                                ' | Origen: ', each verOrigen,
                                ' | Destino: ', each verDestino,
                                ' | Cupo: ', each verCupo printString,
                                ' | Fecha inicio: ', each verFechaInicio,
                                ' | Fecha fin: ', each verFechaFin,
                                ' | Precio: ', each verPrecio printString; cr.
            ].

        aux := (Prompter prompt: 'Ingrese el ID de un paquete') asNumber.
        unPaquete := unaAgencia buscarPaquetePorCodigo: aux.

        [unPaquete = nil] whileTrue: [
            Transcript show: 'No existe el ID de paquete ingresado'; cr.
            aux := (Prompter prompt: 'Ingrese un ID de paquete v�lido') asNumber. 
            unPaquete := unaAgencia buscarPaquetePorCodigo: aux.        
        ].

	

        (unCliente verPuntosAcumulados > 19) ifTrue: [
            unPaquete aplicarDescuento.
            Transcript show: '�Usted cuenta con m�s de 20 puntos acumulados! Recibe un descuento del 20%. Nuevo precio: ', unPaquete verPrecio printString ; cr.
        ].

        "Crear reserva"
        unIdReserva := unIdReserva + 1.
        unaReserva := Reserva CrearReserva: unIdReserva cliente: unCliente paqueteTuristico: unPaquete fechaReserva: '11-11-2023'.
	unaAgencia agregarReserva: 	unaReserva.
        unPaquete modCupo: (unPaquete verCupo - 1).
        unCliente acumularPuntos: 10.
	
	(reservasPorPaquete at: unPaquete verIdPaquete ifAbsent: [0]) >= unPaquete verCupo ifTrue: [
			Transcript show: 'Este paquete se ha quedado sin cupo!'; cr.
	] ifFalse: [
		reservasPorPaquete at: unPaquete verIdPaquete put: ((reservasPorPaquete at: unPaquete verIdPaquete ifAbsent: [0]) + 1).
	].

	Transcript show: '=================== Puntos acumulados hasta el momento: ' , unCliente verPuntosAcumulados printString ,' ======================'; cr.

        Transcript show: '=================== Reserva realizada con �xito, disfrute su viaje ==================='; cr.
    ].
    (opcion = 2) ifTrue: [
	unDni := (Prompter prompt: 'Ingrese su DNI para ver sus reservas.') asNumber.
	unCliente := unaAgencia getClienteByDNI: unDni.
	(unCliente = nil) 
	ifTrue: [
		Transcript show: 'El cliente no existe.'; cr.
	]
	ifFalse: [
		Transcript show: 'Lista de reservas del cliente: ', unCliente verApellido, ', ', unCliente verNombre; cr.
		(unaAgencia verListaReservas select: [:each | each verCliente verDni = unDni]) do: [:reserva |
		Transcript show: ' | ID reserva: ', reserva verIdReserva printString ,
				' | Fecha de reserva: ', reserva verFechaReserva ,
				' | ID paquete tur�stico: ', reserva verPaqueteTuristico verIdPaquete printString, 
				' | Origen: ', reserva verPaqueteTuristico verOrigen,
				' | Destino: ', reserva verPaqueteTuristico verDestino,
				' | Cupo: ', reserva verPaqueteTuristico verCupo printString,
				' | Fecha inicio: ', reserva verPaqueteTuristico verFechaInicio,
				' | Fecha fin: ', reserva verPaqueteTuristico verFechaFin,
				' | Precio: ', reserva verPaqueteTuristico verPrecio printString; cr.
		].
	].
		((unaAgencia verListaReservas select: [:each | each verCliente verDni = unDni]) isEmpty) ifTrue: [
			Transcript show: 'No hay reservas hechas por este cliente'; cr.
		].
	].

    (opcion = 3) ifTrue: [
	unDni := (Prompter prompt: 'Ingrese su DNI para ver sus reservas.') asNumber.
	unCliente := unaAgencia getClienteByDNI: unDni.
	(unCliente = nil) 
		ifTrue: [
			Transcript show: 'El cliente no existe.'; cr.
		]
		ifFalse: [
			Transcript show: 'Lista de reservas del cliente: ', unCliente verApellido, ', ', unCliente verNombre; cr.
			(unaAgencia verListaReservas select: [:each | each verCliente verDni = unDni]) do: [:reserva |
			Transcript show: ' | ID reserva: ', reserva verIdReserva printString ,
					' | Fecha de reserva: ', reserva verFechaReserva ,
					' | ID paquete tur�stico: ', reserva verPaqueteTuristico verIdPaquete printString, 
					' | Origen: ', reserva verPaqueteTuristico verOrigen,
					' | Destino: ', reserva verPaqueteTuristico verDestino,
					' | Cupo: ', reserva verPaqueteTuristico verCupo printString,
					' | Fecha inicio: ', reserva verPaqueteTuristico verFechaInicio,
					' | Fecha fin: ', reserva verPaqueteTuristico verFechaFin,
					' | Precio: ', reserva verPaqueteTuristico verPrecio printString; cr.
			].

			aux := (Prompter prompt: 'Ingrese el ID de la reserva de la cual se desea darse de baja:') asNumber.
			reserva := unaAgencia verReservaPorId: aux.

			[reserva = nil] whileTrue: [
			    Transcript show: 'No existe el ID de la reserva ingresada'; cr.
			    aux := (Prompter prompt: 'Ingrese un ID de reserva v�lido') asNumber. 
			    reserva := unaAgencia verReservaPorId: aux.        
			].

			unPaquete := unaAgencia buscarPaquetePorCodigo: reserva verPaqueteTuristico verIdPaquete.
			unaAgencia BajaDeReserva: reserva.
			unPaquete modCupo: (unPaquete verCupo + 1).
			unCliente descontarPuntos: 10.

			reservasPorPaquete at: reserva verPaqueteTuristico verIdPaquete put: ((reservasPorPaquete at: reserva verPaqueteTuristico verIdPaquete ifAbsent: [0]) - 1).

			Transcript show: '=================== Baja de reserva realizada con �xito ==================='; cr.
		].

	].
				

    (opcion = 0) ifTrue: [
        menu := false.
    ].
].

