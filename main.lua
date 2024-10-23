require "import"


gversion="4.0.6"


import {
  "android.app.*",
  "android.os.*",
  "android.widget.*",
  "android.view.*",
  "android.graphics.BitmapFactory",
  "android.graphics.drawable.BitmapDrawable",
  "android.graphics.drawable.ColorDrawable",
  "android.animation.LayoutTransition",
  "android.util.TypedValue",
  "java.io.FileInputStream",

  "androidx.core.widget.NestedScrollView",
  "androidx.coordinatorlayout.widget.CoordinatorLayout",
  "androidx.viewpager.widget.ViewPager",
  "androidx.swiperefreshlayout.widget.SwipeRefreshLayout",
  "androidx.appcompat.widget.LinearLayoutCompat",
  "androidx.appcompat.widget.AppCompatImageView",
  "com.google.android.material.appbar.AppBarLayout",
  "com.google.android.material.appbar.MaterialToolbar",
  "com.google.android.material.appbar.CollapsingToolbarLayout",
  "com.google.android.material.card.MaterialCardView",
  "com.google.android.material.bottomnavigation.BottomNavigationView",
  "com.google.android.material.dialog.MaterialAlertDialogBuilder",
  --"com.google.android.material.switchmaterial.SwitchMaterial",
  "com.google.android.material.materialswitch.MaterialSwitch",--谷歌起名一直可以的。MD2主题请继续使用旧库
  "com.google.android.material.textview.MaterialTextView",
  "com.google.android.material.button.MaterialButton",
  "com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton",
  "com.google.android.material.tabs.TabLayout",
  "com.google.android.material.button.MaterialButtonToggleGroup",
  "com.google.android.material.textfield.TextInputEditText",
  "com.google.android.material.textfield.TextInputLayout",

  "androidx.recyclerview.widget.*",
  "github.daisukiKaffuChino.utils.LuaThemeUtil",
  "com.daimajia.androidanimations.library.Techniques",
  "com.daimajia.androidanimations.library.YoYo",

}

--设置主题
activity.setTheme(R.style.Theme_ReOpenLua_Material3)

--[[reOpenLua+ Open Source Project
     -----Material 3 简单示例 更新1-----
酷安@得想办法娶了智乃 2022.08.18 保留所有权利
运行必要的编辑器版本 reOpenLua+ 0.7.7及以上]]

--更新日志:适配了相关Java方法调整和部分功能重新实现

--小Tip：事实上，reOpenLua+要适配Material You也是很容易的
--但考虑到动态取色仅支持Android 12及以上，缺乏泛用性，故未作支持
import "MaidToast"
--初始化颜色
--为了使深色主题效果正常，请不要使用硬编码颜色!
local themeUtil=LuaThemeUtil(this)
MDC_R=luajava.bindClass"com.google.android.material.R"
surfaceColor=themeUtil.getColorSurface()
--更多颜色分类 请查阅Material.io官方文档
backgroundc=themeUtil.getColorBackground()
surfaceVar=themeUtil.getColorSurfaceVariant()
titleColor=themeUtil.getTitleTextColor()
primaryc=themeUtil.getColorPrimary()
primarycVar=themeUtil.getColorPrimaryVariant()

--初始化ripple
rippleRes = TypedValue()
activity.getTheme().resolveAttribute(android.R.attr.selectableItemBackground, rippleRes, true)

function getFileDrawable(file)
  fis = FileInputStream(activity.getLuaDir().."/res/"..file..".png")
  bitmap = BitmapFactory.decodeStream(fis)
  return BitmapDrawable(activity.getResources(), bitmap)
end
function 状态栏高度()
  if Build.VERSION.SDK_INT >= 19 then
    resourceId = activity.getResources().getIdentifier("status_bar_height", "dimen", "android")
    return activity.getResources().getDimensionPixelSize(resourceId)
   else
    return 0
  end
end

layout={
  CoordinatorLayout,
  layout_width="fill",
  layout_height="fill",
  {
    AppBarLayout,
    TargetElevation=0,
    id="appbar",
    layout_width="fill",
    layout_height="wrap",
    {
      MaterialToolbar,
      id="toolbar",
      title="EPlay", background=ColorDrawable(surfaceVar),
      layout_width="fill",
      layout_height="60dp",

    },
  },
  {
    NestedScrollView,
    layout_width="fill",
    layout_height="fill",
    layout_behavior="@string/appbar_scrolling_view_behavior",
    fillViewport="true",
    backgroundColor=backgroundc,
    {
      LinearLayoutCompat,
      id="content",
      layout_width="fill",
      layout_height="fill",
      orientation="vertical",
      --[
      {
        ViewPager,
        id="vpg",
        --无缝迁移到新标准库，reOpenLua+已经过优化，像使用PageView一样使用ViewPager！
        --在类似使用场景中我们更推荐FragmentContainerView。不过这不在本demo演示范围内
        layout_width="fill",
        layout_height="fill",
        pages={
          "page_home",
          "page_setting",
        },
      },
    },
  },
  {
    BottomNavigationView,
    id="bottombar",
    layout_gravity="bottom",
    layout_width="fill",
    layout_height="wrap",
  },
  {
    ExtendedFloatingActionButton,
    id="fab",
    text="帮助",
    onClick="onClickFab",
    icon=getFileDrawable("outline_info_black_24dp"),
    layout_gravity="bottom|end",
    layout_marginBottom="110dp",
    layout_marginEnd="16dp",
  },

}


--设置布局
activity.setContentView(loadlayout(layout))

--隐藏自带ActionBar
activity.getSupportActionBar().hide()
--配置状态栏颜色
local window = activity.getWindow()
window.setStatusBarColor(surfaceVar)
window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
window.getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
window.setNavigationBarColor(surfaceVar)
mAppBarChildAt = appbar.getChildAt(0)
mAppBarParams =mAppBarChildAt.getLayoutParams()
mAppBarParams.setScrollFlags(0)
--设置Material底栏。谷歌将启用新的BottomAppBar,两者区别不大，故不再作展示
--得益于CoordinatorLayout的强大支持，配合layout_behavior轻松实现滚动隐藏
local bottombarBehavior=luajava.bindClass"com.google.android.material.behavior.HideBottomViewOnScrollBehavior"
bottombar.layoutParams.setBehavior(bottombarBehavior())
bottombar.setLabelVisibilityMode(0)--设置tab样式


--设置底栏项目
bottombar.menu.add(0,0,0,"主页")--参数分别对应groupid homeid order name
bottombar.menu.add(0,1,1,"设置")
--设置底栏图标
bottombar.menu.findItem(0).setIcon(getFileDrawable("round_home_black_24dp"))--这里findItem取的是home id
--bottombar.menu.findItem(1).setIcon(getFileDrawable("round_bar_chart_black_24dp"))
bottombar.menu.findItem(1).setIcon(getFileDrawable("round_settings_black_24dp"))


--MaterialToolbar比普通Toolbar更强大的地方在于，它可以脱离Activity使用
local addToolbarMenu=lambda a,b,c,name:toolbar.menu.add(a,b,c,name)
addToolbarMenu(0,0,0,"关于EPlay")
addToolbarMenu(0,1,1,"退出EPlay")
--这里展示了标准lua没有的AndroLua+专属语法lambda(匿名函数)
--可以大幅简化重复函数调用。上面的底栏也是可以用lambda添加的。

--顶栏菜单点击监听
import "androidx.appcompat.widget.Toolbar$OnMenuItemClickListener"
toolbar.setOnMenuItemClickListener(OnMenuItemClickListener{
  onMenuItemClick=function(item)
  switch item.getItemId() do
     case 0
      --Material 风格的对话框
      MaterialAlertDialogBuilder(this)
      .setTitle("关于EPlay")
      .setIcon(getFileDrawable("outline_info_black_24dp"))
      .setMessage("EPlay是简单的游戏启动器\n作者:千载琉璃")
      .setPositiveButton("TG频道",function()
        import "android.net.Uri"
        import "android.content.Intent"
        --加群
        url="https://t.me/lingyesoul233"
        activity.startActivity(Intent(Intent.ACTION_VIEW, Uri.parse(url)))

      end)
      .setNegativeButton("知道了",nil)
      .show()
     case 1
      activity.finish()
    end
  end
})

--ViewPager和BottomNavigationView联动
vpg.setOnPageChangeListener(ViewPager.OnPageChangeListener{
  onPageSelected=function(v)
    bottombar.getMenu().getItem(v).setChecked(true)
    if v~=0 then
      YoYo.with(Techniques.ZoomOut).duration(200).playOn(fab)
      task(200,function()fab.setVisibility(8)end)
     else
      fab.setVisibility(0)
      YoYo.with(Techniques.ZoomIn).duration(200).playOn(fab)
    end
end})

bottombar.setOnNavigationItemSelectedListener(BottomNavigationView.OnNavigationItemSelectedListener{
  onNavigationItemSelected = function(item)
    vpg.setCurrentItem(item.getItemId())
    return true
end})


--申请权限
function requestPermissions(permissions)
  local ActivityCompat = luajava.bindClass "androidx.core.app.ActivityCompat"
  return ActivityCompat.requestPermissions(activity, permissions, 10);
end
--申请权限的回调在这里执行
onRequestPermissionsResult=function(requestCode, permissions, grantResults)
  local PackageManager = luajava.bindClass "android.content.pm.PackageManager"
  --判断是不是自己的权限申请，这里的10就是上面requestPermissions中写的10
  if requestCode==10 then
    local count = 0
    for i=0,#permissions-1 do
      if grantResults[i] == PackageManager.PERMISSION_GRANTED then
        --print(permissions[i].."权限通过")
        count = count + 1
       else
        --print(permissions[i].."权限拒绝")
      end
    end
    --print("申请了"..#permissions.."个权限，通过了"..count.."个权限")
  end
end
--示例
--要申请的权限列表，请写成常量以免自己写错
--所有的权限常量定义在Manifest的内部类permission里，写法如下

function checkPermission(permission)
  return 0==activity.checkSelfPermission(permission)
end
--单纯检查一下有没有指定权限



--[[初始化TabLayout(弃用)
local tabTable={"Pie Chart","Bar Chart"}
for i=1, #tabTable do
  mtab.addTab(mtab.newTab().setText(tabTable[i]))
end
cvpg.setOnPageChangeListener(ViewPager.OnPageChangeListener{
  onPageSelected=function(v)
    mtab.getTabAt(v).select()
end})

mtab.addOnTabSelectedListener(TabLayout.OnTabSelectedListener{
  onTabSelected = function(tab)
    cvpg.setCurrentItem(tab.getPosition())
end})]]

--MD3 Demo 1.1
--一行解决控件联动。使用LuaPagerAdapter新增的构造方法，支持在布局表中设置标题!
--mtab.setupWithViewPager(cvpg)

--悬浮按钮点击事件
function onClickFab()
  MaterialAlertDialogBuilder(this)
  .setTitle("EPlay For "..appname)
  .setIcon(getFileDrawable("outline_info_black_24dp"))
  .setMessage("游戏目录:"..gameml.."\n安装样例:"..gameml.."/index.html\n你可以自行安装游戏，使用自带安装方式可能会卡Bug！\n首次使用先点击安装游戏！")
  .setPositiveButton("确定",nil).show()
end

--初始化饼图，仅供展示_(:зゝ∠)_
--项目地址https://github.com/PhilJay/MPAndroidChart
--[[mChart.setUsePercentValues(true)
mChart.getDescription().setEnabled(false)
mChart.setDrawEntryLabels(true)
mChart.setExtraOffsets(5, 10, 5, 5)
mChart.setDragDecelerationFrictionCoef(0.95)
mChart.setDrawHoleEnabled(true)
mChart.setHoleColor(backgroundc)
mChart.setTransparentCircleColor(backgroundc)
mChart.setTransparentCircleAlpha(110)
mChart.setDrawCenterText(true)
mChart.setRotationAngle(0)
mChart.setRotationEnabled(true)
mChart.setHighlightPerTapEnabled(true)

local entries={}
table.insert(entries,PieEntry(0.5, "item1"))
table.insert(entries,PieEntry(0.2, "item2"))
table.insert(entries,PieEntry(0.3, "item3"))
local set = PieDataSet(entries, "往生堂帮钟离垫付的账单")
--这里设置颜色实际上偷懒了，实际开发中不要这么用
set.setColors({MDC_R.color.m3_ref_palette_primary60, MDC_R.color.m3_ref_palette_primary70, MDC_R.color.m3_ref_palette_primary80}, this)
mChart.setData(PieData(set))]]

--尝试增大TextInputLayout圆角，虽然不增大也挺好看的
local function dp2px(dpValue)
  local scale = activity.getResources().getDisplayMetrics().scaledDensity
  return dpValue * scale + 0.5
end
local corii={dp2px(24),dp2px(24),dp2px(24),dp2px(24)}
--[[t1.setBoxCornerRadii(table.unpack(corii))
t2.setBoxCornerRadii(table.unpack(corii))]]

local night=activity.getSharedData("night")

if night==nil then
  activity.setSharedData("night",false)
  night=activity.getSharedData("night")
end

daynight.setChecked(night)

daynight.setOnCheckedChangeListener{
  onCheckedChanged=function(g,c)
    if c==true then
      activity.setSharedData("night",true)
      activity.switchDayNight()
      daynight.setChecked(true)
     else
      activity.setSharedData("night",false)
      activity.switchDayNight()
      daynight.setChecked(false)
    end
  end
}

local Webet=activity.getSharedData("WebSet")

if Webet==nil then
  activity.setSharedData("WebSet",false)
  Webet=activity.getSharedData("WebSet")
end

WebSet.setChecked(Webet)

WebSet.setOnCheckedChangeListener{
  onCheckedChanged=function(g,c)
    if c==true then
      activity.setSharedData("WebSet",true)

     else
      activity.setSharedData("WebSet",false)

    end
  end
}

local Loadet=activity.getSharedData("LoadSet")

if Loadet==nil then
  activity.setSharedData("LoadSet",false)
  Loadet=activity.getSharedData("LoadSet")
end

LoadSet.setChecked(Loadet)
exit=activity.getSharedData("exit")
if exit then
  activity.setSharedData("exit",false)
 else
  if Loadet then
    local Webet=activity.getSharedData("WebSet")
    if Webet then
      activity.newActivity("x5player")
     else
      activity.newActivity("player")
    end
  end
end
LoadSet.setOnCheckedChangeListener{
  onCheckedChanged=function(g,c)
    if c==true then
      activity.setSharedData("LoadSet",true)

     else
      activity.setSharedData("LoadSet",false)
    end
  end
}

local debuge=activity.getSharedData("debuger")

if debuge==nil then
  activity.setSharedData("debuger",false)
  debuge=activity.getSharedData("debuger")
end

debuger.setChecked(debuge)

debuger.setOnCheckedChangeListener{
  onCheckedChanged=function(g,c)
    if c==true then
      activity.setSharedData("debuger",true)

     else
      activity.setSharedData("debuger",false)

    end
  end
}

local offupdat=activity.getSharedData("offupdate")

if offupdat==nil then
  activity.setSharedData("offupdate",false)
  offupdat=activity.getSharedData("offupdate")
end

offupdate.setChecked(offupdat)

offupdate.setOnCheckedChangeListener{
  onCheckedChanged=function(g,c)
    if c==true then
      activity.setSharedData("offupdate",true)

     else
      activity.setSharedData("offupdate",false)

    end
  end
}

import "init"
import "java.io.File"--导入File类

gameid.setText(appname.." Ver"..appver)



free = activity.getSharedData("free")
if free then
 else
  require("import")
  import"com.google.android.material.dialog.MaterialAlertDialogBuilder"
  function setShareData(key,value)
    activity.setSharedData(key,value)
  end

  local dialog=MaterialAlertDialogBuilder(activity)
  .setTitle("提示")
  .setMessage("EPlay For "..appname.."！\n本软件完全免费，如果你是通过收费渠道获得，请立即退款举报，转载本软件需要注明原作者以及来源！")
  .setPositiveButton("确定",{
    onClick=function()
      activity.setSharedData("free",true)
    end
  }).show()

end


sycs = activity.getSharedData("sycs")





gameml="/sdcard/Android/data/"..activity.getPackageName().."/games"
import "init"
import "java.io.File"--导入File类
gstatus="状态:未检测到游戏文件"
if File(gameml.."/index.html").exists() then
  gstatus="状态:检测到游戏文件"
end
gameid.setText(appname.." "..gversion.."\n"..gstatus)
task(200,function()
  sycs = activity.getSharedData("sycs")
  if sycs ==5 then
   else
   import "android.net.Uri"
import "android.provider.Settings"
import "android.content.Intent"
intent=Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION);
intent.setData(Uri.parse("package:"..activity.getPackageName()));
activity.startActivity(intent);
    require("import")
    import"com.google.android.material.dialog.MaterialAlertDialogBuilder"
    function setShareData(key,value)
      activity.setSharedData(key,value)
    end

    local dialog=MaterialAlertDialogBuilder(activity)
    .setTitle("EPlay")
    .setMessage("EPlay For "..appname.."！\n游戏目录:"..gameml.."\n首次使用先点击安装游戏！\nPS:游戏文件较大时推荐手动安装！")
    .setPositiveButton("确定",{
      onClick=function()
        activity.setSharedData("sycs",5)
      end
    }).show()

  end
end)
function unzipgame(gameml)
  zip=activity.getLuaDir().."/game"
  os.execute("mv "..zip.." "..gameml)
  os.remove(zip)
end

function installgame(gameml)
InputLayout={
  LinearLayout;
  orientation="vertical";--重力属性
  Focusable=true,--可聚焦
  FocusableInTouchMode=true,--可聚焦在触摸模式下，可变色
  {MaterialTextView,
    id="name",
    text="正在安装",
    layout_gravity='center';
    textSize="22sp",
  },
  {
    FrameLayout,
    layout_height="fill",
    layout_width="fill",
    {
      ProgressBar,
      visibility=0,
      layout_gravity='center';
      id="progressBar",
    },
  },
}
require("import")
import"com.google.android.material.dialog.MaterialAlertDialogBuilder"
local dialog=MaterialAlertDialogBuilder(activity)
.setView(loadlayout(InputLayout))--设置布局
.setCancelable(false)
.show()
task(unzipgame,gameml,function()
  dialog.hide()
  提示("安装完成！")
  local dialog=MaterialAlertDialogBuilder(activity)
  .setTitle("提示")
  .setMessage("EPlay目前只能导出不含游戏的启动器APK（与当前APK只有没有游戏包的区别）后手动安装\n可以减少内存占用，但会导致软件将无法在清除数据后直接重装游戏\n导出的APK位于/sdcard/Download/launcher.apk\n由于一些原因，EPlay的应用安装不可用")
  .setPositiveButton("导出APK",
  function()
    os.execute("mv "..activity.getLuaDir().."/launcher.apk /sdcard/Download/launcher.apk")
    end)
    .setNegativeButton("取消安装",nil)
    .show()
  end)
end

btn1.onClick=function()
  if File(gameml.."/index.html").exists() then

    local Webet=activity.getSharedData("WebSet")
    if Webet then
      activity.newActivity("x5player")
     else
      activity.newActivity("player")
    end
   else
    提示("未发现游戏文件！")
  end
end

btn2.onClick=function()
  if File(gameml.."/index.html").exists() then
    MaterialAlertDialogBuilder(this)
    .setTitle("提示")
    .setIcon(getFileDrawable("outline_info_black_24dp"))
    .setMessage("检测到游戏已安装，请不要重复安装！")
    .setPositiveButton("我知道啦",nil)
    .show()
   else
        installgame(gameml)
  end
end
if File(gameml.."/index.html").exists() then
   else
   提示("请点击安装游戏")
  end