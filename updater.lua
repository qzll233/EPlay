require "import"
import "android.widget.*"
import "android.view.*"
import"MaidToast"


function 解压(压缩路径,解压缩路径)
  xpcall(function()
    LuaUtil.unZip(压缩路径,解压缩路径)
  end,function()
    提示("解压文件 "..压缩路径.." 失败")
  end)
end

function 压缩(原路径,压缩路径,名称)
  xpcall(function()
    LuaUtil.zip(原路径,压缩路径,名称)
  end,function()
    提示("压缩文件 "..原路径.." 至 "..压缩路径.."/"..名称.." 失败")
  end)
end

function installEPlay(filepath,filename,gameml)
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
task(解压,filepath.."/"..filename,gameml,function() 
  dialog.hide() 
  提示("更新完成！")   
  import "java.io.File"--导入File类
File(filepath.."/"..filename).delete()
  end)
end

function UpdateProgresser(status,downloaded,total)
    switch status do
     case 1
      --等待下载
      positive_bt.setText("等待中")
     case 2
      --正在下载
      percent_progress=tointeger(downloaded/total*100)
      --计算刷新进度
      positive_bt.setText(tostring(percent_progress)..'%')
     case 4
      --下载暂停
      positive_bt.setText("被暂停")
     case 8
      --下载成功
      xpcall(function()installEPlay(filepath,filename,activity.getLuaDir())end,function()
    提示("安装失败！")
  end)
dialog.hide()
        
        
      if UpdateProgressTicker then UpdateProgressTicker.stop() end
     case 16
      --下载失败
      positive_bt.setText("失败")
      if UpdateProgressTicker then UpdateProgressTicker.stop() end
    end
  end

 function DownloadEPlay(link)
    --调用下载管理器下载
    import "android.app.DownloadManager"
    import "android.content.Context"
    downloadManager=activity.getSystemService(Context.DOWNLOAD_SERVICE)
    import "android.net.Uri"
    request=DownloadManager.Request(Uri.parse(link))
    request.setDestinationInExternalPublicDir("Download",filename)
    request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)
    downloadManager.enqueue(request)
    --设置下载管理器并开始
    query=DownloadManager.Query()
    UpdateProgressTicker=Ticker()
    UpdateProgressTicker.setPeriod(500)
    UpdateProgressTicker.onTick=function()
      --计时器获取query刷新下载进度
      cursor=downloadManager.query(query)
      if not cursor.moveToFirst() then
        cursor.close()
        return
      end
      status=cursor.getInt(cursor.getColumnIndex(DownloadManager.COLUMN_STATUS));
      total=cursor.getLong(cursor.getColumnIndex(DownloadManager.COLUMN_TOTAL_SIZE_BYTES));
      downloaded=cursor.getLong(cursor.getColumnIndex(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR));
      cursor.close()
      UpdateProgresser(status,downloaded,total)
    end
    UpdateProgressTicker.start()
  end

function update()
  require"import"
  import"info"
  import"updateinfo"
  filename="EPlayUpdate.zip"
  filepath="/sdcard/Download/"
  app_version_code=(baseversion)
  --当前版本
  last_version_code=(newversion)
  --最新版本
提示("目前版本:"..last_version_code)
  --更新日志是table
  
  if last_version_code>app_version_code then
    if not activity.isFinishing() then
      --防止显示对话框时activity已被结束导致找不到activity报错
      import "com.google.android.material.dialog.MaterialAlertDialogBuilder"
      dialog=MaterialAlertDialogBuilder(activity)
      .setTitle("发现EPlay更新")
      .setMessage("点击以更新到最新版EPlay "..last_version_code)
      .setPositiveButton("更新",nil)
      .setCancelable(false)--禁用返回键
      .show()
      bm=activity.getPackageName()
      if bm=="github.daisukiKaffuChino.reopenlua"then
        dialog.setCancelable(true)
      end
      positive_bt=dialog.getButton(dialog.BUTTON_POSITIVE)
      import "android.content.res.ColorStateList"
      positive_bt.onClick=function()
        if positive_bt.getText()=='更新' then
          positive_bt.setText('处理中')
          if File("/sdcard/Download/"..filename).exists() then
            --如果已经存在文件则直接跳转到安装应用的步骤
            UpdateProgresser(8)
            else
                  DownloadEPlay(updateurl)
                end
        end
      end
    end
  else
  if last_version_code==app_version_code then
    提示("已是最新版本！")
    else
  提示("无法更新！")
  end
  end
end

  function checkupdate()
    提示("正在检查更新！")
    Http.download("https://",activity.getLuaDir().."/updateinfo.lua", function(code,body)
      if code == 200 then
        task(1000,function()
        import"updateinfo"
        update()
        end)
       else
        提示("更新出错:"..code.." "..body)
        if pcall(function() require "import" import"updateinfo" end) then
          update()
          提示("正在以本地配置启动！")
         else
          提示("配置缺失，无法正常启动！")
          task(3000,function()
            activity.finish()
          end)
        end
      end
    end)
end

local offupdate=activity.getSharedData("offupdate")
--检查更新
if offupdate then
  Toast.makeText(activity, "已跳过更新！",Toast.LENGTH_SHORT).show()
 else
  checkupdate()
end

