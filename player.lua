
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
import "android.webkit.WebView"
import "android.webkit.WebSettings$ZoomDensity"
import "android.webkit.WebSettings$RenderPriority"


layout={
  LinearLayout;
  layout_width=-1;
  layout_height=-1;
  {
    WebView;
    id="web";
    layout_width=-1;
    layout_height=-1;
  };
}



activity.setTheme(R.style.Theme_ReOpenLua_Material3)
activity.setContentView(loadlayout(layout))
activity.getSupportActionBar().hide()


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
  activity.window.attributes.layoutInDisplayCutoutMode=1
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
settings.setAllowUniversalAccessFromFileURLs(true);

settings.setBuiltInZoomControls(true);
settings.setDisplayZoomControls(false);
settings.setRenderPriority(RenderPriority.HIGH);
settings.setSupportZoom(true);
settings.setUseWideViewPort(true);
settings.setLoadWithOverviewMode(true);
settings.setDefaultZoom(ZoomDensity.FAR);

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
import "android.webkit.WebViewClient"
web.setWebViewClient(luajava.override(WebViewClient,{
  
  onPageFinished=function(_,view,url)
    --页面加载结束事件
    --网页加载完成
    --web.evaluateJavascript(tpjs,nil)
    tvc=getShareData("debuger") 
web.evaluateJavascript([[/* 版权警告
 * Copyright 2010, Google Inc.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are
 * met:
 *
 *     * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above
 * copyright notice, this list of conditions and the following disclaimer
 * in the documentation and/or other materials provided with the
 * distribution.
 *     * Neither the name of Google Inc. nor the names of its
 * contributors may be used to endorse or promote products derived from
 * this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


/**
 * @fileoverview This file contains functions every webgl program will need
 * a version of one way or another.
 * 这个文件包含每个webgl程序都需要某种版本的功能。
 *
 * Instead of setting up a context manually it is recommended to
 * use. This will check for success or failure. On failure it
 * will attempt to present an approriate message to the user.
 * 建议手动使用，而不是手动设置上下文。这将检验成败。在失败时，它将尝试向用户呈现一个适当的消息。
 *
 *       gl = WebGLUtils.setupWebGL(canvas);
 *
 * For animated WebGL apps use of setTimeout or setInterval are
 * discouraged. It is recommended you structure your rendering
 * loop like this.
 * 对于WebGL动画应用程序使用setTimeout或者setInterval不是一种很好的选择。我们推荐你使用下面这种方式。
 *
 *       function render() {
 *         window.requestAnimFrame(render, canvas);
 *
 *         // do rendering
 *         ...
 *       }
 *       render();
 *
 * This will call your rendering function up to the refresh rate
 * of your display but will stop rendering if your app is not
 * visible.
 * 这样会在你的应用程序显示的时候进行渲染，如果隐藏掉将停止渲染。
 */

WebGLUtils = function() {

/**
 * Creates the HTLM for a failure message  创建一个显示错误信息的dom
 * @param {string} canvasContainerId id of container of the canvas.
 *        一段需要显示的错误信息
 * @return {string} The html 返回一段html代码.
 */
var makeFailHTML = function(msg) {
  return '' +
    '<table style="background-color: #8CE; width: 100%; height: 100%;"><tr>' +
    '<td align="center">' +
    '<div style="display: table-cell; vertical-align: middle;">' +
    '<div style="">' + msg + '</div>' +
    '</div>' +
    '</td></tr></table>';
};

/**
 * Mesasge for getting a webgl browser 获取支持WebGL浏览器的一段字符串
 * @type {string}
 */
var GET_A_WEBGL_BROWSER = '' +
  '这个页面需要支持WebGL的浏览器。<br/>' +
  '<a href="http://get.webgl.org">点击这里升级你的浏览器。</a>';

/**
 * Mesasge for need better hardware  需要升级系统硬件的信息
 * @type {string}
 */
var OTHER_PROBLEM = '' +
  "看来你的电脑不能支持WebGL。<br/>" +
  '<a href="http://get.webgl.org/troubleshooting/">点击这里获取更多信息。</a>';

/**
 * Creates a webgl context. If creation fails it will
 * change the contents of the container of the <canvas>
 * tag to an error message with the correct links for WebGL.
 * 创建WebGL上下文。如果创建失败，它将<canvas>标签的容器的内容更改为带有WebGL链接的错误消息。
 * @param {Element} canvas. The canvas element to create a
 *     context from 创建WebGL上下文的canvas dom对象.
 * @param {WebGLContextCreationAttirbutes} opt_attribs Any
 *     creation attributes you want to pass in.
 * @return {WebGLRenderingContext} The created context.
 */
var setupWebGL = function(canvas, opt_attribs) {
  function showLink(str) {
    var container = canvas.parentNode;
    if (container) {
      container.innerHTML = makeFailHTML(str);
    }
  };

  //如果当前的设备不支持webgl，将获取到canvas父元素，并在里面填充错误信息
  if (!window.WebGLRenderingContext) {
    showLink(GET_A_WEBGL_BROWSER);
    return null;
  }

  //如果浏览器支持将调用创建webgl上下文的事件的函数 create3DContext，不支持将显示浏览器不支持的错误信息
  var context = create3DContext(canvas, opt_attribs);
  if (!context) {
    showLink(OTHER_PROBLEM);
  }
  return context;
};

/**
 * Creates a webgl context 创建webgl上下文的方法.
 * @param {!Canvas} canvas The canvas tag to get context
 *     from. If one is not passed in one will be created.
 * @return {!WebGLContext} The created context.
 */
var create3DContext = function(canvas, opt_attribs) {
  var names = ["webgl", "experimental-webgl", "webkit-3d", "moz-webgl"];
  var context = null;
  for (var ii = 0; ii < names.length; ++ii) {
    try {
      context = canvas.getContext(names[ii], opt_attribs);
    } catch(e) {}
    if (context) {
      break;
    }
  }
  return context;
};

return {
  create3DContext: create3DContext,
  setupWebGL: setupWebGL
};
}();

/**
 * Provides requestAnimationFrame in a cross browser way 对requestAnimationFrame方法进行兼容处理.
 */
window.requestAnimFrame = (function() {
  return window.requestAnimationFrame ||
         window.webkitRequestAnimationFrame ||
         window.mozRequestAnimationFrame ||
         window.oRequestAnimationFrame ||
         window.msRequestAnimationFrame ||
         function(/* function FrameRequestCallback */ callback, /* DOMElement Element */ element) {
           window.setTimeout(callback, 1000/60);
         };
})();



]],nil)
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
}))


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
