const elt = document.createElement("div");
document.body.appendChild(elt);

var i = 0;
var j = 0;
while (true) {
  if (i++ == 10000000) {
    j++;
    elt.innerText = "Still running ... " + (new Date());
    i = 0;
  }
}