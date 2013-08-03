// Script by Drew Noakes
// http://drewnoakes.com
// 14 Dec 2006 - Initial release
// 08 Jun 2010 - Added support for password textboxes
// 16 Nov 2012 - Added support for text areas and reduced global values

var HintClass = "hintTextbox";
var HintActiveClass = "hintTextboxActive";

// define a custom method on the string class to trim leading and training spaces
String.prototype.trim = function() { return this.replace(/^\s+|\s+$/g, ''); };

function initHintTextboxes() {
  var inputs = document.getElementsByTagName('input');
  inputs = inputs.concat(document.getElementsByTagName('textarea'));
  
  for (i=0; i<inputs.length; i++) {
    var input = inputs[i];
    if (input.type!="text" && input.type!="password")
      continue;
      
    if (input.className.indexOf(HintClass)!=-1) {
      input.hintText = input.value;
      input.className = HintClass;
      input.onfocus = onHintTextboxFocus;
      input.onblur = onHintTextboxBlur;
    }
  }
}

function onHintTextboxFocus() {
  var input = this;
  if (input.value.trim()===input.hintText) {
    input.value = "";
    input.className = HintActiveClass;
  }
}

function onHintTextboxBlur() {
  var input = this;
  if (input.value.trim().length==0) {
    input.value = input.hintText;
    input.className = HintClass;
  }
}

window.onload = initHintTextboxes;
