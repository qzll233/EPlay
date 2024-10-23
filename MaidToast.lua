require "import"
import "android.widget.*"
import "android.view.*"

function 提示(a)
  Toast.makeText(activity,tostring(a),Toast.LENGTH_SHORT).show()
  end