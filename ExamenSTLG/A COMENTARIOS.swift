//
//  A COMENTARIOS.swift
//  ExamenSTLG
//
//  Created by Sergio Torres Landa González on 07/12/22.
//
//COMENTARIOS:
//1. NO se utilizaron UITableViews para los View controllers solicitados ya que las UITableViews funcionan mejor para mostrar objetos de una misma clase.
//2. Se utilizó arquitectura MVVM y su correspondiente patron de diseño observer para la implementacion de una Tabla donde se muestran 50 usuarios, que en este caso se generan por codigo, pero perfectamente podrían haberse llamado de una API desde TablaModel.swift. Solo para ejemplificar que se conoce la arquitectura y el patron de diseño.
//4. La tabla fue creada hardcoded, sinembargo estamos acostumbrados a crear la tabla directamente desde storyboards y llenarla de forma similar como se hace en el ejemplo. Pero configurando mejor su diseño y llenado de datos desde un UITableViewCell cuyo delegado sería el ViewController.
//5. La tabla se edita segun los datos que se hayan guardado desde la sección de edición de datos
//
//
//
//

