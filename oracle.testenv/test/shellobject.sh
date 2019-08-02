source ./shellclass.sh
# -------------------------------------------------------------------
# Example code
# -------------------------------------------------------------------
 
# class definition
class Storpel
  func Storpel
  func setName
  func setQuality
  func print
  var name
  var quality
 
# class implementation

Storpel::Storpel() {
setName "$1"
setQuality "$2"
if [ -z "$name" ]; then setName "Generic"; fi
if [ -z "$quality" ]; then setQuality "Normal"; fi
}
 
Storpel::setName() { name="$1"; }
Storpel::setQuality() { quality="$1"; }
Storpel::print() { echo "$name ($quality)"; }
 
# usage
new Storpel one "Storpilator 1000" Medium
new Storpel two
new Storpel three
 
two.setName "Storpilator 2000"
two.setQuality "Strong"
 
one.print
two.print
three.print
 
echo ""
 
echo "one: $one ($(typeof $one))"
echo "two: $two ($(typeof $two))"
echo "three: $three ($(typeof $two))"