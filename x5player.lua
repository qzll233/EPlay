--
-- @author 寒歌
-- @description Main是应用的主模块，其中注册了应用运行中UI事件的回调、Activity生命周期的回调等
-- 你也可以在此编写启动事件代码，或控制应用运行逻辑、自定义应用UI等等。
-- @other 本模版已为你编写好基础事件，建议在阅读注释并理解相关参数意义后再进行扩展编写
--

-- ****默认导入包****
require "import"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
-- ****不需要请删除****

droid_R = luajava.bindClass "android.R"
require "import"
import "MaidToast"
import "java.util.ArrayList"
import "android.widget.LinearLayout"
import "com.x5.WebView.*"
import "com.tencent.smtt.sdk.*"

layout={
  LinearLayout;
  layout_width=-1;
  layout_height=-1;
  {
    X5WebView;
    id="web";
    layout_width=-1;
    layout_height=-1;
  };
}

activity.setTheme(R.style.Theme_ReOpenLua_Material3)
activity.setContentView(loadlayout(layout))
activity.getSupportActionBar().hide()

QbSdk.initX5Environment(activity,nil)

import "android.graphics.PixelFormat"
activity.getWindow().setFormat(PixelFormat.TRANSLUCENT);


import "android.content.pm.ActivityInfo"
--沉浸导航栏
import 'android.view.Window'
import 'android.view.WindowManager'
import 'android.view.WindowManager$LayoutParams'
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_NAVIGATION);
--------------------------
--沉浸状态栏
import 'android.view.Window'
import 'android.view.WindowManager'
import 'android.view.WindowManager$LayoutParams'
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
--------------------------

import "android.content.pm.ActivityInfo"
import "android.view.WindowManager"
activity.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
--隐藏状态栏
--------------------------
activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_HIDE_NAVIGATION)
--隐藏导航栏
if Build.VERSION.SDK_INT >= 28 then
  activity.window.attributes.layoutInDisplayCutoutMode，=1
end
import "android.webkit.WebView"
web.addJavascriptInterface({},"JsInterface")--漏洞封堵代码
gameml="/sdcard/Android/data/"..activity.getPackageName().."/games"
ml=gameml
settings = web.getSettings();
settings.setJavaScriptCanOpenWindowsAutomatically(true);
settings.setJavaScriptEnabled(true);
-- settings.setRenderPriority(RenderPriority.HIGH);
settings.setAllowContentAccess(true);
settings.setAllowFileAccess(true);
settings.setAppCacheEnabled(true);
settings.setDatabaseEnabled(true);
settings.setDatabasePath(ml);
settings.setDomStorageEnabled(true);
settings.setLoadsImagesAutomatically(true);
settings.setSupportMultipleWindows(true);
settings.setAllowFileAccessFromFileURLs(true);
settings.setAllowUniversalAccessFromFileURLs(true);
settings.setMediaPlaybackRequiresUserGesture(false);
settings.setLoadWithOverviewMode(true);
settings.setBuiltInZoomControls(true);
settings.setSaveFormData(true);
settings.setMixedContentMode(0);
settings.setJavaScriptEnabled(true);
settings.setAllowUniversalAccessFromFileURLs(true);

settings.setBuiltInZoomControls(true);
settings.setDisplayZoomControls(false);
--settings.setRenderPriority(RenderPriority.HIGH);
settings.setSupportZoom(true);
settings.setUseWideViewPort(true);
settings.setLoadWithOverviewMode(true);
--settings.setDefaultZoom(ZoomDensity.FAR);



web.setLayerType(View.LAYER_TYPE_HARDWARE,nil);
web.setNetworkAvailable(true)

activity.setRequestedOrientation(0);
cfg=ml.."/data/system/Config.tjs"
lib=ml.."/tyrano/libs.js"

function 替换文件字符串(路径,要替换的字符串,替换成的字符串)
  if 路径 then
    路径=tostring(路径)
    内容=io.open(路径):read("*a")
    io.open(路径,"w+"):write(tostring(内容:gsub(要替换的字符串,替换成的字符串))):close()
   else
    return false
  end
end

pcall(function()
替换文件字符串(cfg,[[configSave=file]],[[configSave=webstorage]])
替换文件字符串(lib,[[cache:false]],[[cache:true]])
end)




web.loadUrl('file:///'..ml.."/index.html")



function getShareData(key)
  return activity.getSharedData(key)
end

加载状态=false
web.setWebViewClient{
  onPageFinished=function(view,url)
    --网页加载完成
    tvc=getShareData("debuger")
    

    if 加载状态 then
     else
      加载状态=true
      
      if tvc then
        web.evaluateJavascript([[
(function () {
  /* 开始执行代码 */
  const script = document.createElement('script');
  script.src = 'https://cdn.jsdelivr.net/npm/vconsole@latest/dist/vconsole.min.js';
  document.head.appendChild(script);
  setTimeout(() => {
    new VConsole()
  }, 1000);
})();]],nil)
      end
    end
  end
}

function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    require("import")
    import"com.google.android.material.dialog.MaterialAlertDialogBuilder"
    local dialog=MaterialAlertDialogBuilder(activity)
    .setTitle("GamePlayer")
    local items={"旋转成竖屏","旋转成横屏","退出GamePlayer"}
    dialog.setItems(items,{
      onClick=function(dialog,i)
        --print("点击了"..items[i+dialog])
        switch(i)
         
         case 0
          activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
         case 1
          activity.setRequestedOrientation(0);
         case 2
         activity.setSharedData("exit",true)
          os.exit()
         default 提示("错误！")
        end
      end
    }).show()
    return true
  end
end


--[[
提示("启动器By：泠夜Soul")
加载网页('file://'..activity.getLuaDir().."/index.html")
]]