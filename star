<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<title>Starbucks Tracker</title>

<style>
body{
font-family:Arial;
background:#f4f1ea;
padding:20px;
}

h1{
color:#006241;
}

table{
border-collapse:collapse;
width:100%;
background:white;
margin-bottom:25px;
}

th,td{
border:1px solid #ddd;
padding:10px;
text-align:center;
}

th{
background:#006241;
color:white;
}

select{
padding:5px;
}

.rating span{
font-size:22px;
cursor:pointer;
}

input{
padding:8px;
margin-bottom:10px;
width:250px;
}

.stats{
background:white;
padding:15px;
border:1px solid #ddd;
margin-bottom:20px;
}
</style>
</head>

<body>

<h1>Starbucks Combo Tracker</h1>

<input type="text" id="buscador" placeholder="Buscar bebida">

<div class="stats">
<h3>Estadísticas</h3>
<p id="topDrink">Bebida favorita: -</p>
<p id="topMilk">Leche más usada: -</p>
<p id="topSyrup">Jarabe más usado: -</p>
</div>

<table id="tabla">
<tr>
<th>Bebida</th>
<th>Leche</th>
<th>Shots</th>
<th>Jarabe</th>
<th>Rating</th>
</tr>
</table>

<h3>Combinaciones calificadas</h3>

<table id="historial">
<tr>
<th>Bebida</th>
<th>Leche</th>
<th>Shots</th>
<th>Jarabe</th>
<th>Rating</th>
</tr>
</table>

<script>

const bebidas=[
"Latte","Cappuccino","Americano","Flat White",
"Caramel Macchiato","Mocha","White Mocha",
"Chai Latte","Matcha Latte","Cold Brew",
"Frappuccino Café","Frappuccino Caramel",
"Frappuccino Mocha","Frappuccino Fresa"
];

const leches=[
"Entera","Deslactosada","Almendra","Coco","Avena","Soya"
];

const shots=["0","1","2","3","4"];

const jarabes=[
"Ninguno","Vainilla","Caramelo","Avellana",
"Canela Dolce","Toffee Nut","Chocolate",
"Chocolate Blanco","Frambuesa"
];

function selectHTML(lista){
let html="<select>";
lista.forEach(i=>html+="<option>"+i+"</option>");
html+="</select>";
return html;
}

function estrellasHTML(){
let html='<div class="rating">';
for(let i=1;i<=5;i++){
html+='<span data-val="'+i+'">☆</span>';
}
html+="</div>";
return html;
}

const tabla=document.getElementById("tabla");

bebidas.forEach(b=>{
let row=tabla.insertRow();
row.dataset.nombre=b.toLowerCase();

row.insertCell().innerText=b;
row.insertCell().innerHTML=selectHTML(leches);
row.insertCell().innerHTML=selectHTML(shots);
row.insertCell().innerHTML=selectHTML(jarabes);
row.insertCell().innerHTML=estrellasHTML();
});

let datos=JSON.parse(localStorage.getItem("ratings")||"[]");

function guardar(combo){
datos.push(combo);
localStorage.setItem("ratings",JSON.stringify(datos));
actualizarHistorial();
calcularStats();
}

document.addEventListener("click",function(e){

if(e.target.dataset.val){

let fila=e.target.closest("tr");

let bebida=fila.cells[0].innerText;
let leche=fila.cells[1].querySelector("select").value;
let shot=fila.cells[2].querySelector("select").value;
let jarabe=fila.cells[3].querySelector("select").value;
let rating=e.target.dataset.val;

let estrellas=e.target.parentElement.children;

for(let i=0;i<estrellas.length;i++){
estrellas[i].textContent=(i<rating)?"★":"☆";
}

guardar({bebida,leche,shot,jarabe,rating});

}

});

function actualizarHistorial(){

let tabla=document.getElementById("historial");

tabla.innerHTML="<tr><th>Bebida</th><th>Leche</th><th>Shots</th><th>Jarabe</th><th>Rating</th></tr>";

datos.forEach(d=>{

let row=tabla.insertRow();

row.insertCell().innerText=d.bebida;
row.insertCell().innerText=d.leche;
row.insertCell().innerText=d.shot;
row.insertCell().innerText=d.jarabe;
row.insertCell().innerText="⭐".repeat(d.rating);

});

}

function calcularStats(){

if(datos.length===0)return;

let bebidasCount={};
let lecheCount={};
let jarabeCount={};

datos.forEach(d=>{

bebidasCount[d.bebida]=(bebidasCount[d.bebida]||0)+Number(d.rating);
lecheCount[d.leche]=(lecheCount[d.leche]||0)+1;
jarabeCount[d.jarabe]=(jarabeCount[d.jarabe]||0)+1;

});

function top(obj){
return Object.entries(obj).sort((a,b)=>b[1]-a[1])[0][0];
}

document.getElementById("topDrink").innerText="Bebida favorita: "+top(bebidasCount);
document.getElementById("topMilk").innerText="Leche más usada: "+top(lecheCount);
document.getElementById("topSyrup").innerText="Jarabe más usado: "+top(jarabeCount);

}

document.getElementById("buscador").addEventListener("input",function(){

let texto=this.value.toLowerCase();
let filas=document.querySelectorAll("#tabla tr");

filas.forEach((f,i)=>{
if(i===0)return;

f.style.display=f.dataset.nombre.includes(texto)?"":"none";

});

});

actualizarHistorial();
calcularStats();

</script>

</body>
</html>
