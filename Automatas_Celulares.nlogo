;; razas
breed [ rich a-rich ]
breed [ poor a-poor ]
breed [ mid a-mid ]
breed [ jobs job ] ;; Los trabajos son lugares que emplean varias personas.
breed [university a-university] ;; Lugares que incrementan la educacion de las personas.
breed [school a-school]  ;; Lugares que incrementan la educacion de las personas.
breed [store a-store]  ;; Lugares de desvalorizan las viviendas al volverse comercial.
breed [hospital a-hospital] ;; Lugares que valorizan el precio y la calidad de las personas cercanas.
breed [industry a-industry]  ;; Lugares que ofrecen servicios que cuestan y desvalorizan las cercanias.

;; Propiedades / Variables de cada agente
rich-own [utility-r age education]
poor-own [utility-p age education]
mid-own [utility-m age education]
jobs-own [utility]
;; calidad, precio, distancia a trabajo, typo de barrio, color del barrio segun precio
patches-own [quality price sd-dist type-neighborhood color-neighborhood]
;; contador, modo de vista
globals [counter view-mode]


to setup
  ;; limpia el mapa/mundo
  clear-all
  ;; inicia el modo de vista por calidad del barrio
  set view-mode "quality"
  ;; crea trabajos
  setup-jobs
  ;; inicializa los barrios
  setup-patches
  ;; crea los ricos
  setup-rich
  ;; crea los clase media
  setup-mid
  ;; crea los pobres
  setup-poor

  ;; crea N escuelas/universidades segun la barra deslizable de la interfaz.
  create-university number-university [
    ;; les da una ubicacion aleatoria
    setxy random-xcor random-ycor
    ;; se le da un color rosado muy oscuro
    set color 131
    ;; defina la forma de la universidad
    set shape "university"
    ;; tamaño
    set size 2
    ;; valoriza los barrios cercanos.
    further-raise-price
    ;; incrementa la calidad
    further-raise-value
  ]

  ;; crea N escuelas segun la barra deslizable de la interfaz
    create-school number-school [
    ;; ubicacion aleatoria
    setxy random-xcor random-ycor
    ;; color violeta predefinido
    set color violet
    ;; forma
    set shape "school"
    ;; tramaño de 1 unidad
    set size 1
    ;; incrementa el valor de los barrios
    raise-price
    ;; incrementa la calidad de los barrios
    raise-value
  ]
  ;; crea N tiendas dependiendo la barra deslizable de la interfaz
    create-store number-store [
    ;; ubicacion aleatoria
    setxy random-xcor random-ycor
    ;; color anaranjado
    set color 25
    ;; forma de tienda
    set shape "store"
    ;; tamaño 2 unidades
    set size 2
    ;; disminuye el valor de los barrios
    decrease-price
    ;; disminuye la calidad de los barrios
    decrease-value
  ]
  ;; crea 5 agentes de raza hospital
    create-hospital number-hospital [
    ;; ubicacion aleatoria
    setxy random-xcor random-ycor
    ;; color rojo
    set color 14
    ;; forma de ambulancia
    set shape "ambulance"
    ;; tamaño de 3 unidades
    set size 3
    ;; incrementa el valor de los barrios cercanos
    further-raise-price
    ;; incrementa la calidad de los barrios cercanos
    further-raise-value
  ]
  ;; crea las industrias/servicios
      create-industry number-industry [
    ;; ubicacion aleatoria
    setxy random-xcor random-ycor
    ;; color rojo oscuro
    set color 12
    ;; forma de icono de alarma
    set shape "warning"
    ;; tamaño 2 unidades
    set size 2
    ;; reduce el precio de los barrios
    further-decrease-price
    ;; reduce la calidad de los barrios
    further-decrease-value
  ]

  ;; pinta los barrios segun el modo de vista.
  ask patches [ update-patch-color ]

  ;; reinicia los tick que se usan para generar un paso a paso rapido y continuo.
  reset-ticks
end


;; crea los trabajos
to setup-jobs
  ;; crea 1 trabajo
  create-jobs 1
  ask jobs
  [
    ;; les asigna color rojo
    set color red
    ;; forma de fabrica
    set shape "factory"
    ;; tamaño de 2 unidades
    set size 2
  ]
end

;; inicialia los barrios
to setup-patches
  ask patches [
    ;; todos inician con una calidad y precio de 40
    set quality 40
    set price 40
  ]

  ;; se les asigna una distancia teniendo en cuenta el trabajo mas cercano
  ask patches
  [
    ;; sd-dist es la variable que guarda la distancia
    set sd-dist min [distance myself] of jobs
  ]
end


;; crea los ricos
to setup-rich
  ;;inicialmente crea 5 ricos
  create-rich 5
  ask rich
  [
    ;; les asigan un color magenta
    set color 126
    ;; forma de cada
    set shape "house"
    ;; edad entre 0 y 99 años
    set age random 100
    ;; educacion inicialmente vacia
    set education 0
    ;; define el radio para ubicarlos en una region cercana
    let radius 10
    ;; los ubica de una manera semi aleatoria en una region
    setxy ( ( radius / 2 ) - random-float ( radius * 1.0 ) ) ( ( radius / 2 ) - random-float ( radius * 1.0 ) )
    ;; incrementa el precio de los barrios
    further-raise-price
    ;; incrementa la calidad de los barrios
    further-raise-value
  ]
end

;; crea los clase media
to setup-mid
  ;; crea 5 clase media
  create-mid 5
  ask mid
  [
    ;; les da un color cyan
    set color 85
    ;; forma de casa
    set shape "house"
    ;; edad entre 0 y 99 años
    set age random 100
    ;; educacion vacia incialmente
    set education 0
    ;; los ubica de manera semi aleatoria en un radio usando la siguiente formula ((r/2) - (a)) siendo 'a' un aleatorio decimal
    let radius 10
    setxy ( ( radius / 2 ) - random-float ( radius * 1.0 ) ) ( ( radius / 2 ) - random-float ( radius * 1.0 ) )
    ;; disminuye el precio de los barrios
    decrease-price
    ;; incrementa la calidad de los barrios
    raise-value
  ]
end

;; crea los pobres
to setup-poor
  ;; inicialmente genera 5
  create-poor 5
  ask poor
  [
    ;; se le da un color azul
    set color 105
    ;; forma de casa
    set shape "house"
    ;; edad entre 0 y 99 años
    set age random 100
    ;; educacion inicial de 0
    set education 0
    ;; ubica de manera semi aletoria en una area.
    let radius 10
    setxy ( ( radius / 2 ) - random-float ( radius * 1.0 ) ) ( ( radius / 2 ) - random-float ( radius * 1.0 ) )
    ;; disminuye el precio de los barrios
    decrease-price
    ;; disminuye la calidad de los barrios
    decrease-value
  ]
end

;; disminuye la calidad del barrio o celda y sus vecinos al rededor
to decrease-value
  ask patch-here [ set quality ( quality * 0.95 ) ] ;; -5%
  ask patches in-radius 1 [ set quality ( quality * 0.96 ) ] ;; -4%
  ask patches in-radius 2 [ set quality ( quality * 0.97 ) ] ;; -3%
  ask patches in-radius 3 [ set quality ( quality * 0.98 ) ] ;; -2%
  ask patches in-radius 4 [ set quality ( quality * 0.99 ) ;; -1%
    if (quality < 1) [ set quality 1] ;; en el borde a 4 casillas si la calidad es menor a 1 pone el imite en 1. para que no baje a valores negativos.
  ]
end

;; disminuye la calidad del barrio o celda y los vecinos
to further-decrease-value
  ask patch-here [ set quality ( quality * 0.90 ) ] ;; -10%
  ask patches in-radius 1 [ set quality ( quality * 0.91 ) ] ;; -9%
  ask patches in-radius 2 [ set quality ( quality * 0.92 ) ] ;; -8%
  ask patches in-radius 3 [ set quality ( quality * 0.93 ) ] ;; -7%
  ask patches in-radius 4 [ set quality ( quality * 0.94 ) ;; -6%
    if (quality < 1) [ set quality 1] ;; limita a un valor minimo de 1
  ]

end

;; incrementa el precio de los barrios
to raise-price
  ask patch-here [ set price ( price * 1.05 ) ] ;; +5%
  ask patches in-radius 1 [ set price ( price * 1.04 ) ] ;; +4%
  ask patches in-radius 2 [ set price ( price * 1.03 ) ] ;; +3%
  ask patches in-radius 3 [ set price ( price * 1.02 ) ] ;; +2%
  ask patches in-radius 4 [ set price ( price * 1.01 ) ;; +1%
   if price > 100 [ set price 100 ] ] ;; limita el precio a un maximo de 100
end

;; incrementa el valor de los barrios cercanos
;; esta funcion es usada por las universidades
to further-raise-price
  ask patch-here [ set price ( price * 1.10 ) ] ;; +10%
  ask patches in-radius 1 [ set price ( price * 1.09 ) ] ;; +9%
  ask patches in-radius 2 [ set price ( price * 1.08 ) ] ;; +8%
  ask patches in-radius 3 [ set price ( price * 1.07 ) ] ;; +7%
  ask patches in-radius 4 [ set price ( price * 1.06 ) ;; + 6%
   if price > 100 [ set price 100 ] ] ;; define como limite de precio 100
end

;; incrementa el valor de los barrios cercanos
to raise-value
  ask patch-here [ set quality ( quality * 1.05 ) ] ;; +5%
  ask patches in-radius 1 [ set quality ( quality * 1.04 ) ];; +4%
  ask patches in-radius 2 [ set quality ( quality * 1.03 ) ];; +3%
  ask patches in-radius 3 [ set quality ( quality * 1.02 ) ];; +2%
  ask patches in-radius 4 [ set quality ( quality * 1.01 )  ;; +1%
    if quality > 100 [ set quality 100 ] ;; limita a un valor de calidad maximo de 100
  ]
end

;; incrementa la calidad de los barrios cercanos
to further-raise-value
  ask patch-here [ set quality ( quality * 1.10 ) ]  ;; +10%
  ask patches in-radius 1 [ set quality ( quality * 1.09 ) ];; +9%
  ask patches in-radius 2 [ set quality ( quality * 1.08 ) ];; +8%
  ask patches in-radius 3 [ set quality ( quality * 1.07 ) ];; +7%
  ask patches in-radius 4 [ set quality ( quality * 1.06 )  ;; +6%
    if quality > 100 [ set quality 100 ] ;; limita la calidad a maximo 100
  ]
end

;; disminuye el precio de los barrios
to decrease-price
  ask patch-here [ set price ( price * 0.95 ) ] ;; -5%
  ask patches in-radius 1 [ set price ( price * 0.96 ) ];; -4%
  ask patches in-radius 2 [ set price ( price * 0.97 ) ];; -3%
  ask patches in-radius 3 [ set price ( price * 0.98 ) ];; -2%
  ask patches in-radius 4 [ set price ( price * 0.99 )  ;; -1%
    if (price < 1) [ set price 1]   ;; limita el precio a minimo 1
  ]
end

;; disminuye el precio de los barrios
to further-decrease-price
  ask patch-here [ set price ( price * 0.90 ) ] ;; -10%
  ask patches in-radius 1 [ set price ( price * 0.91 ) ];; -9%
  ask patches in-radius 2 [ set price ( price * 0.92 ) ];; -8%
  ask patches in-radius 3 [ set price ( price * 0.93 ) ];; -7%
  ask patches in-radius 4 [ set price ( price * 0.94 )  ;; -6%
    if (price < 1) [ set price 1] ;; limita el precio a minimo 1
  ]
end


;; Con esta funcion dependiento del precio se define el tipo de barrio.
;; guardar el tipo y color del barrio.
to update-neighborhood

  ;; estables los limites o lineas entre barrios pobres, medios o ricos segun el precio
  let limite-clase-media 33
  let limite-ricos 66

  ;; pregunta a todos los barrios
  ask patches [
    ;; si su precio es < al limite inferior de clase media, es pobre
    ifelse (price < limite-clase-media)[
      ;; type-neighborhood solo se usa para especificar. ya que lo importante es el color para diferenciar los barrios en la vista
      set type-neighborhood "poor"
      set color-neighborhood red ;; color de barrio para pobres
    ][
      ;; en otro caso pregunta si esta entre medio y ricos
      ifelse (price >= limite-clase-media and price < limite-ricos)[
        set type-neighborhood "mid"
        set color-neighborhood orange ;; color de barrio para clase media
      ][
        ;; en otro caso si el precio es mayor al limite inferior de ricos es un barrio de ricos
        if (price >= limite-ricos)[
          set type-neighborhood "rich"
          set color-neighborhood green ;; color de barrio para clase rica
        ]
      ]
    ]
  ]
end


;;
;; Runtime Procedures
;;

to go
  ;; crea nuevos pobres en cada paso
  locate-poor
  ;; crea nuevos ricos en cada paso
  locate-rich
  ;; crea nuevos clase media en cada paso
  locate-mid

  ;; si la cantidad supera el numero de trabajadores por trabjo
  if counter > residents-per-job
  [
    ;; crea un nuevo trabajo
    locate-service
    ;; reinicia el contador
    set counter 0
  ]

  ;; envejece los pobres 1 año cada paso
  ask poor [
    set age age + 1
  ]
  ;; envejece los clase media 1 año cada paso
  ask mid [
    set age age + 1
  ]
  ;; envejece los ricos 1 año cada paso
  ask rich [
    set age age + 1
  ]
  ;; evalua y aplica la probabilidad de muerte de los agentes.
  apply-mortality
  ;; segun la cercania a
  increase-education
  semi-increase-education
  if count (jobs) >= max-jobs [kill-service]
  ;; cambia el tipo de barrio y el color para la vista por tipo de barrio.
  update-neighborhood
  ;; cambia en tiempo real el color de las celdas/patches.
  ;; si no se quiere cambiar el color del fondo osea las celdas. Solo debe comentar la linea abajo de esta.
  ask patches [update-patch-color]
  ;;
  tick
end

;; aumenta la educacion a los agentes cercanos a la universdiad
to increase-education
  ask university [
    ;; elije a los pobres cercanos en un radio de 5 unidades
    let nearby-turtles poor in-radius 5
    ask nearby-turtles [
      ;;si su educacion es menor a 10 aumenta en 1
      if education < 10 [
        set education education + 1
      ]
    ]
    ;; funciona de la misma forma para clase media y ricos
    set nearby-turtles mid in-radius 5
    ask nearby-turtles [
      if education < 10 [
        set education education + 1
      ]
    ]
    set nearby-turtles rich in-radius 5
    ask nearby-turtles [
      if education < 10 [
        set education education + 1
      ]
    ]
  ]
end

;; aumenta la educacion de los agentes cercanos a escuelas
to semi-increase-education
  ask school [
    ;; elije a los pobres en un radio de 5 cerca a la escuela
    let nearby-turtles poor in-radius 5
    ask nearby-turtles [
      ;; si su educacion es inferior a 5 aumenta en 1
      if education < 5 [
        set education education + 1
      ]
    ]
    ;; funciona de la misma forma para clase media y para ricos
    set nearby-turtles mid in-radius 5
    ask nearby-turtles [
      if education < 5 [
        set education education + 1
      ]
    ]
    set nearby-turtles rich in-radius 5
    ask nearby-turtles [
      if education < 5 [
        set education education + 1
      ]
    ]
  ]
end

;; crea o genera nacimiento de poblacion pobre en cada paso.
;; dependiendo de la barra "poor-per-step"
to locate-poor
  ;; actualiza el contador de pobres
  set counter ( counter + poor-per-step )
  ;; crea los nuevos pobres
  create-poor poor-per-step
  [
    ;; asigna un color azul
    set color 105
    ;; forma de casa
    set shape "house"
    ;; les asigna una edad de 0 a 99 años de manera aleatoria
    set age random 100

    ;; ubica en el barrio mas barato
    evaluate-poor
    ;; disminuye la calidad de los barrios
    decrease-value
    ;; disminye el precio de los barrios
    decrease-price
  ]
end

;; genera nuevos clase media
to locate-mid
  ;; actualiza el contador
  set counter ( counter + mid-per-step )
  ;; crea los nuevos clase media segun la barra deslizable de la interfaz
  create-mid mid-per-step
  [
    ;; les da un color cyan
    set color 85
    ;; forma de casa
    set shape "house"
    ;; edad entre 0 y 99 años
    set age random 100
    ;; ubica en el mejor barrio calidad precio
    evaluate-mid
    ;; disminuye el precio de los barrios
    decrease-price
    ;; incrementa la calidad de los barrios
    raise-value
  ]
end

;; genera nuevos ricos
to locate-rich
  ;; actualiza el contador
  set counter ( counter + rich-per-step )
  ;;crea los nuevos ricos segun la barra deslizable de la interfaz
  create-rich rich-per-step
  [
    ;; color magenta
    set color 126
    ;; forma de casa
    set shape "house"
    ;; edad entre 0 y 99 años
    set age random 100
    ;; ubica los ricos en el mejor barrio
    evaluate-rich
    ;; incrementa el precio de los barrios
    further-raise-price
    ;; incrementa la calidad de los barrios
    further-raise-value
  ]
end


;;
to evaluate-poor
  ;; guarda una lista de barrios candidatos
  let candidate-patches n-of number-of-tests patches
  ;; filtra los barrios para guardar los que no tienen personas viviendo
  set candidate-patches candidate-patches with [ not any? turtles-here ]
  ;; si no hay mas candidatos se detiene
  if (not any? candidate-patches)
    [ stop ]

  ;; selecciona uno de los candidatos
  let best-candidate max-one-of candidate-patches
  ;; reporta
    [ patch-utility-for-poor ]
  ;; el agente persona se mueve al barrio candidato
  move-to best-candidate
  ;; guarda en la persona la utilidad
  set utility-p [ patch-utility-for-poor ] of best-candidate
end

;; formula para calcular la utilidad de los pobres al vivir en ese barrio
to-report patch-utility-for-poor
    report ( ( 1 / (sd-dist / 100 + 0.1) ) ^ ( 1 - price-priority ) ) * ( ( 1 / price ) ^ ( 1 + price-priority ) )
end

;; evalua y ubica la persona clase media en dicha casilla
to evaluate-mid
  ;; selecciona los barrios candidatos, la cantidad depende dela barra deslizable de la interfaz.
  let candidate-patches n-of number-of-tests patches
  ;; filtra y guarda los barrios vacios.
  set candidate-patches candidate-patches with [ not any? turtles-here ]

  ;; si no hay candidatos se detiene
  if (not any? candidate-patches)
    [ stop ]

  ;; elije uno de los candidatos, calculando la mejor utilidad
  let best-candidate max-one-of candidate-patches
        [ patch-utility-for-mid ]
  ;; se mueve al barrio candidato
  move-to best-candidate
  ;; guarda la utilidad del clase media en ese barrio.
  set utility-m [ patch-utility-for-mid ] of best-candidate
end

;; calcula la utilidad segun el precio y la calidad para promediando entre las 2 variables.
to-report patch-utility-for-mid
  let quality-component ( ( 1 / (sd-dist + 0.1) ) ^ ( 1 - (quality-priority - 1) ) ) * ( quality ^ ( 1 + (quality-priority - 1)) )
  let price-component ( ( 1 / (sd-dist / 100 + 0.1) ) ^ ( 1 - (price-priority + 1) ) ) * ( ( 1 / price ) ^ ( 1 + (price-priority + 1) ) )
  report (quality-component + price-component) / 2
end


;; evalua y ubica el rico en un barrio
to evaluate-rich
  ;; elije N candidatos a partir de la barra deslizable de la interfaz
  let candidate-patches n-of number-of-tests patches
  ;; filtra y guarda los candidatos sin habitantes
  set candidate-patches candidate-patches with [ not any? turtles-here ]
  ;; si no hay candidatos se detiene
  if (not any? candidate-patches)
    [ stop ]

  ;; elije el mejor candidato segun la utilidad
  let best-candidate max-one-of candidate-patches
        [ patch-utility-for-rich ]
  ;; se mueve al candidato elejido
  move-to best-candidate
  ;; guarda la utilidad del rico en ese barrio
  set utility-r [ patch-utility-for-rich ] of best-candidate
end


;; la formula para calcular la utilidad que les queda a los ricos al vivir en ese barrio
to-report patch-utility-for-rich
  report ( ( 1 / (sd-dist + 0.1) ) ^ ( 1 - quality-priority ) ) * ( quality ^ ( 1 + quality-priority) )
end


;; elimina el trabajo mas antiguo y actualiza las distancias.
to kill-service
  ; always kill the oldest job
  ;; los trabajos viejos desaparecen
  ask min-one-of jobs [who]
    [ die ]
  ;; guarda en los barrios la distancia en una escala que incrementa de a 0.01 desde el barrio al trabajo mas cercano.
  ask patches
  ;; min elije la distancia mas cercana si tiene varios trabajos cerca.
    [ set sd-dist min [distance myself + .01] of jobs ]
end

;; crea un trabajo
to locate-service
  ;; selecciona los barrios vacios
  let empty-patches patches with [ not any? turtles-here ]

  ;; si hay barrios vacios
  if any? empty-patches
  [
    ;; pregunta a uno de los barrios
    ask one-of empty-patches
    [
      ;; crea un agente de raza trabajo
      sprout-jobs 1
      [
        ;; se les asigna color rojo
        set color red
        ;; la forma de fabrica
        set shape "factory"
        ;; tamaño
        set size 2
        ;; evalua el lugar donde posicionarse
        evaluate-job
      ]
    ]

    ;; actualiza la distancia de los barrios al trabajo mas cercano
    ask patches
      [ set sd-dist min [distance myself + .01] of jobs ]
  ]
end

;; evalua el mejor lugar para posicionar el trabajo
to evaluate-job
  ;; seleccion N barrios candidatos a partir de la barra deslizadora.
  let candidate-patches n-of number-of-tests patches
  ;; filtra y guarda los que estan vacios
  set candidate-patches candidate-patches with [ not any? turtles-here ]
  ;; si no quedan candidatos se detiene
  if (not any? candidate-patches)
    [ stop ]

  ;; selecciona uno que tenga mayor precio.
  let best-candidate max-one-of candidate-patches [ price ]
  ;; se mueve al barrio candidato
  move-to best-candidate
  ;; guarda el precio del barrio
  set utility [ price ] of best-candidate
end

;;
;; Visualization Procedures
;;

;; muestra la media de edad de los pobres
to-report average-age-poors
  if any? poor [
    report mean [age] of poor
  ]
  report 0  ; Retorna 0 si no hay poors
end

;; muestra la media de edad de los clase media
to-report average-age-mids
  if any? mid [
    report mean [age] of mid
  ]
  report 0  ; Retorna 0 si no hay mids
end

;; muestra la media de edad de los ricos
to-report average-age-richs
  if any? rich [
    report mean [age] of rich
  ]
  report 0  ; Retorna 0 si no hay richs
end

;; muestra la media de educacion de los pobres
to-report average-education-poors
  if any? poor [
    report mean [education] of poor
  ]
  report 0  ; Retorna 0 si no hay poors
end

;; muestra la media de educacion de los clase media
to-report average-education-mids
  if any? mid [
    report mean [education] of mid
  ]
  report 0  ; Retorna 0 si no hay mids
end

;; muestra la media de educacion que tienen los ricos
to-report average-education-richs
  if any? rich [
    report mean [education] of rich
  ]
  report 0  ; Retorna 0 si no hay richs
end


to-report death-probability [turtle-age turtle-breed]
  ;; la mitad de la vida dividido su espectativa de vida, segun la interfaz.
  let base-probability (turtle-age / 2) / life-expectancy-max
  let adjusted-probability base-probability

  ;; si es pobre la probabilidad de muerte se incremente en 5%
  if turtle-breed = "poor" [
    set adjusted-probability adjusted-probability + 0.05
  ]
  ;; los clase media tienen una probabilidad balanceada
  if turtle-breed = "mid" [
    set adjusted-probability adjusted-probability + 0.00
  ]
  ;; los ricos tienen una 'reduccion' de la probabilidad de muerte en 5%
  if turtle-breed = "rich" [
    set adjusted-probability adjusted-probability - 0.05
  ]

  report min list adjusted-probability 1  ; Asegura que la probabilidad no supere 100%
end


;; aplica la probabilidad de muerte de los agentes
to apply-mortality

  ask poor [
    ;; evalua la probabilidad de muerte segun la edad al tipo pobre
    let prob (death-probability age "poor")
    ;; si la probabilidad es mayor muere
    if random-float 1 < prob [
      die
    ]
  ]

  ;; evalua la probabilidad de muerte segun la edad en clase media
  ask mid [
    let prob (death-probability age "mid")
    ;; si la probabilidad es mayor muere
    if random-float 1 < prob [
      die
    ]
  ]

  ask rich [
    ;; evalua la probabilidad de muerte segun la edad y tipo rico
    let prob (death-probability age "rich")
    ;; si la probabilidad es mayor muere
    if random-float 1 < prob [
      die
    ]
  ]
end


to update-patch-color

  ;; muestra los barrios de colores segun el tipo de vista
  ;; por defecto esta en modo calidad
  ifelse view-mode = "quality" [
    ;; en una escala del color verde segun la calidad
    set pcolor scale-color green quality 1 100
  ] [
    ;; en una escala de amarillos segun el precio
    ifelse view-mode = "price" [
      set pcolor scale-color yellow price 0 100
    ] [
      ;; segun la distancia a los trabajos en una escala de azules
      ifelse view-mode = "dist" [
        set pcolor scale-color blue sd-dist (0.45 * (max-pxcor * 1.414)) (0.05 * (max-pxcor * 1.414))
      ][
        ;; segun el tipo de barrio, pobre, medio, rico. el propio barrio guarda el color en la variable color-neighborhood
        if view-mode = "neighborhood" [
          set pcolor color-neighborhood
        ]
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
475
10
1322
525
-1
-1
8.31
1
10
1
1
1
0
0
0
1
-50
50
-30
30
1
1
1
ticks
30.0

BUTTON
95
490
173
523
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
175
490
251
523
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
270
60
430
93
number-of-tests
number-of-tests
0
60
34.0
1
1
NIL
HORIZONTAL

BUTTON
253
490
331
523
go-once
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
25
10
112
43
Ver precio
set view-mode \"price\"\nask patches [\n  update-patch-color\n]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
120
10
212
43
Ver calidad
set view-mode \"quality\"\nask patches [\n  update-patch-color\n]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
20
55
180
88
residents-per-job
residents-per-job
0
500
180.0
10
1
NIL
HORIZONTAL

SLIDER
270
170
430
203
poor-per-step
poor-per-step
0
15
3.0
1
1
NIL
HORIZONTAL

SLIDER
270
205
430
238
rich-per-step
rich-per-step
0
15
5.0
1
1
NIL
HORIZONTAL

BUTTON
215
10
367
43
Ver distancia a trabajo
set view-mode \"dist\"\nask patches [\n  update-patch-color\n]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
270
95
430
128
price-priority
price-priority
-1
1
0.0
.1
1
NIL
HORIZONTAL

SLIDER
270
130
430
163
quality-priority
quality-priority
-1
1
0.0
0.1
1
NIL
HORIZONTAL

SLIDER
20
90
180
123
max-jobs
max-jobs
5
20
10.0
1
1
NIL
HORIZONTAL

MONITOR
20
355
95
400
# of jobs
count jobs
17
1
11

MONITOR
20
415
95
460
population
count poor + count rich + count mid
17
1
11

MONITOR
105
435
180
480
poor pop
count poor
17
1
11

MONITOR
105
335
180
380
rich pop
count rich
17
1
11

SLIDER
270
240
430
273
mid-per-step
mid-per-step
0
15
5.0
1
1
NIL
HORIZONTAL

MONITOR
105
385
180
430
mid pop
count mid
17
1
11

MONITOR
185
435
300
480
average age poors
average-age-poors
17
1
11

SLIDER
20
125
180
158
life-expectancy-max
life-expectancy-max
1
200
200.0
1
1
NIL
HORIZONTAL

MONITOR
185
385
300
430
average age mids
average-age-mids
17
1
11

MONITOR
185
335
300
380
average age richs
average-age-richs
17
1
11

MONITOR
305
435
440
480
average education poors
average-education-poors
17
1
11

MONITOR
305
385
440
430
average education mids
average-education-mids
17
1
11

MONITOR
305
335
440
380
average education richs
average-education-richs
17
1
11

SLIDER
20
160
180
193
number-university
number-university
0
15
5.0
1
1
NIL
HORIZONTAL

SLIDER
20
195
180
228
number-school
number-school
0
15
5.0
1
1
NIL
HORIZONTAL

SLIDER
20
230
180
263
number-store
number-store
0
15
6.0
1
1
NIL
HORIZONTAL

BUTTON
370
10
472
43
Ver Barrios
set view-mode \"neighborhood\"\nask patches [\n  update-patch-color\n]
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
20
265
180
298
number-industry
number-industry
0
15
13.0
1
1
NIL
HORIZONTAL

SLIDER
20
300
180
333
number-hospital
number-hospital
0
15
5.0
1
1
NIL
HORIZONTAL

@#$#@#$#@
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

ambulance
false
0
Rectangle -7500403 true true 30 90 210 195
Polygon -7500403 true true 296 190 296 150 259 134 244 104 210 105 210 190
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Circle -16777216 true false 69 174 42
Rectangle -1 true false 288 158 297 173
Rectangle -1184463 true false 289 180 298 172
Rectangle -2674135 true false 29 151 298 158
Line -16777216 false 210 90 210 195
Rectangle -16777216 true false 83 116 128 133
Rectangle -16777216 true false 153 111 176 134
Line -7500403 true 165 105 165 135
Rectangle -7500403 true true 14 186 33 195
Line -13345367 false 45 135 75 120
Line -13345367 false 75 135 45 120
Line -13345367 false 60 112 60 142

ant
true
0
Polygon -7500403 true true 136 61 129 46 144 30 119 45 124 60 114 82 97 37 132 10 93 36 111 84 127 105 172 105 189 84 208 35 171 11 202 35 204 37 186 82 177 60 180 44 159 32 170 44 165 60
Polygon -7500403 true true 150 95 135 103 139 117 125 149 137 180 135 196 150 204 166 195 161 180 174 150 158 116 164 102
Polygon -7500403 true true 149 186 128 197 114 232 134 270 149 282 166 270 185 232 171 195 149 186
Polygon -7500403 true true 225 66 230 107 159 122 161 127 234 111 236 106
Polygon -7500403 true true 78 58 99 116 139 123 137 128 95 119
Polygon -7500403 true true 48 103 90 147 129 147 130 151 86 151
Polygon -7500403 true true 65 224 92 171 134 160 135 164 95 175
Polygon -7500403 true true 235 222 210 170 163 162 161 166 208 174
Polygon -7500403 true true 249 107 211 147 168 147 168 150 213 150

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

bee
true
0
Polygon -1184463 true false 151 152 137 77 105 67 89 67 66 74 48 85 36 100 24 116 14 134 0 151 15 167 22 182 40 206 58 220 82 226 105 226 134 222
Polygon -16777216 true false 151 150 149 128 149 114 155 98 178 80 197 80 217 81 233 95 242 117 246 141 247 151 245 177 234 195 218 207 206 211 184 211 161 204 151 189 148 171
Polygon -7500403 true true 246 151 241 119 240 96 250 81 261 78 275 87 282 103 277 115 287 121 299 150 286 180 277 189 283 197 281 210 270 222 256 222 243 212 242 192
Polygon -16777216 true false 115 70 129 74 128 223 114 224
Polygon -16777216 true false 89 67 74 71 74 224 89 225 89 67
Polygon -16777216 true false 43 91 31 106 31 195 45 211
Line -1 false 200 144 213 70
Line -1 false 213 70 213 45
Line -1 false 214 45 203 26
Line -1 false 204 26 185 22
Line -1 false 185 22 170 25
Line -1 false 169 26 159 37
Line -1 false 159 37 156 55
Line -1 false 157 55 199 143
Line -1 false 200 141 162 227
Line -1 false 162 227 163 241
Line -1 false 163 241 171 249
Line -1 false 171 249 190 254
Line -1 false 192 253 203 248
Line -1 false 205 249 218 235
Line -1 false 218 235 200 144

bird1
false
0
Polygon -7500403 true true 2 6 2 39 270 298 297 298 299 271 187 160 279 75 276 22 100 67 31 0

bird2
false
0
Polygon -7500403 true true 2 4 33 4 298 270 298 298 272 298 155 184 117 289 61 295 61 105 0 43

boat1
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

boat2
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 157 54 175 79 174 96 185 102 178 112 194 124 196 131 190 139 192 146 211 151 216 154 157 154
Polygon -7500403 true true 150 74 146 91 139 99 143 114 141 123 137 126 131 129 132 139 142 136 126 142 119 147 148 147

boat3
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 37 172 45 188 59 202 79 217 109 220 130 218 147 204 156 158 156 161 142 170 123 170 102 169 88 165 62
Polygon -7500403 true true 149 66 142 78 139 96 141 111 146 139 148 147 110 147 113 131 118 106 126 71

box
true
0
Polygon -7500403 true true 45 255 255 255 255 45 45 45

butterfly1
true
0
Polygon -16777216 true false 151 76 138 91 138 284 150 296 162 286 162 91
Polygon -7500403 true true 164 106 184 79 205 61 236 48 259 53 279 86 287 119 289 158 278 177 256 182 164 181
Polygon -7500403 true true 136 110 119 82 110 71 85 61 59 48 36 56 17 88 6 115 2 147 15 178 134 178
Polygon -7500403 true true 46 181 28 227 50 255 77 273 112 283 135 274 135 180
Polygon -7500403 true true 165 185 254 184 272 224 255 251 236 267 191 283 164 276
Line -7500403 true 167 47 159 82
Line -7500403 true 136 47 145 81
Circle -7500403 true true 165 45 8
Circle -7500403 true true 134 45 6
Circle -7500403 true true 133 44 7
Circle -7500403 true true 133 43 8

circle
false
0
Circle -7500403 true true 35 35 230

factory
false
0
Rectangle -7500403 true true 76 194 285 270
Rectangle -7500403 true true 36 95 59 231
Rectangle -16777216 true false 90 210 270 240
Line -7500403 true 90 195 90 255
Line -7500403 true 120 195 120 255
Line -7500403 true 150 195 150 240
Line -7500403 true 180 195 180 255
Line -7500403 true 210 210 210 240
Line -7500403 true 240 210 240 240
Line -7500403 true 90 225 270 225
Circle -1 true false 37 73 32
Circle -1 true false 55 38 54
Circle -1 true false 96 21 42
Circle -1 true false 105 40 32
Circle -1 true false 129 19 42
Rectangle -7500403 true true 14 228 78 270

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

person
false
0
Circle -7500403 true true 155 20 63
Rectangle -7500403 true true 158 79 217 164
Polygon -7500403 true true 158 81 110 129 131 143 158 109 165 110
Polygon -7500403 true true 216 83 267 123 248 143 215 107
Polygon -7500403 true true 167 163 145 234 183 234 183 163
Polygon -7500403 true true 195 163 195 233 227 233 206 159

school
false
0
Rectangle -7500403 true true 0 60 300 270
Rectangle -16777216 true false 130 196 168 256
Rectangle -16777216 false false 0 255 300 270
Polygon -7500403 true true 0 60 150 15 300 60
Polygon -16777216 false false 0 60 150 15 300 60
Circle -1 true false 135 26 30
Circle -16777216 false false 135 25 30
Rectangle -16777216 false false 0 60 300 75
Rectangle -16777216 false false 218 75 255 90
Rectangle -16777216 false false 218 240 255 255
Rectangle -16777216 false false 224 90 249 240
Rectangle -16777216 false false 45 75 82 90
Rectangle -16777216 false false 45 240 82 255
Rectangle -16777216 false false 51 90 76 240
Rectangle -16777216 false false 90 240 127 255
Rectangle -16777216 false false 90 75 127 90
Rectangle -16777216 false false 96 90 121 240
Rectangle -16777216 false false 179 90 204 240
Rectangle -16777216 false false 173 75 210 90
Rectangle -16777216 false false 173 240 210 255
Rectangle -16777216 false false 269 90 294 240
Rectangle -16777216 false false 263 75 300 90
Rectangle -16777216 false false 263 240 300 255
Rectangle -16777216 false false 0 240 37 255
Rectangle -16777216 false false 6 90 31 240
Rectangle -16777216 false false 0 75 37 90
Line -16777216 false 112 260 184 260
Line -16777216 false 105 265 196 265

sheep
false
15
Rectangle -1 true true 90 75 270 225
Circle -1 true true 15 75 150
Rectangle -16777216 true false 81 225 134 286
Rectangle -16777216 true false 180 225 238 285
Circle -16777216 true false 1 88 92

spacecraft
true
0
Polygon -7500403 true true 150 0 180 135 255 255 225 240 150 180 75 240 45 255 120 135

store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

thin-arrow
true
0
Polygon -7500403 true true 150 0 0 150 120 150 120 293 180 293 180 150 300 150

truck-down
false
0
Polygon -7500403 true true 225 30 225 270 120 270 105 210 60 180 45 30 105 60 105 30
Polygon -8630108 true false 195 75 195 120 240 120 240 75
Polygon -8630108 true false 195 225 195 180 240 180 240 225

truck-left
false
0
Polygon -7500403 true true 120 135 225 135 225 210 75 210 75 165 105 165
Polygon -8630108 true false 90 210 105 225 120 210
Polygon -8630108 true false 180 210 195 225 210 210

truck-right
false
0
Polygon -7500403 true true 180 135 75 135 75 210 225 210 225 165 195 165
Polygon -8630108 true false 210 210 195 225 180 210
Polygon -8630108 true false 120 210 105 225 90 210

turtle
true
0
Polygon -7500403 true true 138 75 162 75 165 105 225 105 225 142 195 135 195 187 225 195 225 225 195 217 195 202 105 202 105 217 75 225 75 195 105 187 105 135 75 142 75 105 135 105

university
false
0
Polygon -7500403 true true 45 120 150 180 240 90 150 30 45 120 150 180 150 180 150 180
Polygon -7500403 true true 60 225 75 240 75 135 60 120 60 225 75 240
Polygon -7500403 true true 90 165 150 195 150 225 90 195 90 165 150 195 150 225 90 195 90 165 150 195
Polygon -7500403 true true 90 165 150 195 225 135 225 195 150 225 90 195 90 165 150 195

warning
false
0
Polygon -7500403 true true 0 240 15 270 285 270 300 240 165 15 135 15
Polygon -16777216 true false 180 75 120 75 135 180 165 180
Circle -16777216 true false 129 204 42

wolf
false
0
Rectangle -7500403 true true 15 105 105 165
Rectangle -7500403 true true 45 90 105 105
Polygon -7500403 true true 60 90 83 44 104 90
Polygon -16777216 true false 67 90 82 59 97 89
Rectangle -1 true false 48 93 59 105
Rectangle -16777216 true false 51 96 55 101
Rectangle -16777216 true false 0 121 15 135
Rectangle -16777216 true false 15 136 60 151
Polygon -1 true false 15 136 23 149 31 136
Polygon -1 true false 30 151 37 136 43 151
Rectangle -7500403 true true 105 120 263 195
Rectangle -7500403 true true 108 195 259 201
Rectangle -7500403 true true 114 201 252 210
Rectangle -7500403 true true 120 210 243 214
Rectangle -7500403 true true 115 114 255 120
Rectangle -7500403 true true 128 108 248 114
Rectangle -7500403 true true 150 105 225 108
Rectangle -7500403 true true 132 214 155 270
Rectangle -7500403 true true 110 260 132 270
Rectangle -7500403 true true 210 214 232 270
Rectangle -7500403 true true 189 260 210 270
Line -7500403 true 263 127 281 155
Line -7500403 true 281 155 281 192

wolf-left
false
3
Polygon -6459832 true true 117 97 91 74 66 74 60 85 36 85 38 92 44 97 62 97 81 117 84 134 92 147 109 152 136 144 174 144 174 103 143 103 134 97
Polygon -6459832 true true 87 80 79 55 76 79
Polygon -6459832 true true 81 75 70 58 73 82
Polygon -6459832 true true 99 131 76 152 76 163 96 182 104 182 109 173 102 167 99 173 87 159 104 140
Polygon -6459832 true true 107 138 107 186 98 190 99 196 112 196 115 190
Polygon -6459832 true true 116 140 114 189 105 137
Rectangle -6459832 true true 109 150 114 192
Rectangle -6459832 true true 111 143 116 191
Polygon -6459832 true true 168 106 184 98 205 98 218 115 218 137 186 164 196 176 195 194 178 195 178 183 188 183 169 164 173 144
Polygon -6459832 true true 207 140 200 163 206 175 207 192 193 189 192 177 198 176 185 150
Polygon -6459832 true true 214 134 203 168 192 148
Polygon -6459832 true true 204 151 203 176 193 148
Polygon -6459832 true true 207 103 221 98 236 101 243 115 243 128 256 142 239 143 233 133 225 115 214 114

wolf-right
false
3
Polygon -6459832 true true 170 127 200 93 231 93 237 103 262 103 261 113 253 119 231 119 215 143 213 160 208 173 189 187 169 190 154 190 126 180 106 171 72 171 73 126 122 126 144 123 159 123
Polygon -6459832 true true 201 99 214 69 215 99
Polygon -6459832 true true 207 98 223 71 220 101
Polygon -6459832 true true 184 172 189 234 203 238 203 246 187 247 180 239 171 180
Polygon -6459832 true true 197 174 204 220 218 224 219 234 201 232 195 225 179 179
Polygon -6459832 true true 78 167 95 187 95 208 79 220 92 234 98 235 100 249 81 246 76 241 61 212 65 195 52 170 45 150 44 128 55 121 69 121 81 135
Polygon -6459832 true true 48 143 58 141
Polygon -6459832 true true 46 136 68 137
Polygon -6459832 true true 45 129 35 142 37 159 53 192 47 210 62 238 80 237
Line -16777216 false 74 237 59 213
Line -16777216 false 59 213 59 212
Line -16777216 false 58 211 67 192
Polygon -6459832 true true 38 138 66 149
Polygon -6459832 true true 46 128 33 120 21 118 11 123 3 138 5 160 13 178 9 192 0 199 20 196 25 179 24 161 25 148 45 140
Polygon -6459832 true true 67 122 96 126 63 144
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
1
@#$#@#$#@
