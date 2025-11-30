"""
快手视频替换工具 - Android版本
直接在手机上操作文件，无需ADB
"""

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button
from kivy.uix.label import Label
from kivy.uix.scrollview import ScrollView
from kivy.uix.textinput import TextInput
from kivy.uix.popup import Popup
from kivy.uix.filechooser import FileChooserListView
from kivy.clock import Clock
from kivy.core.window import Window
import os
import shutil
from pathlib import Path
import threading
from datetime import datetime

# Android权限
try:
    from android.permissions import request_permissions, Permission
    request_permissions([
        Permission.READ_EXTERNAL_STORAGE,
        Permission.WRITE_EXTERNAL_STORAGE
    ])
except:
    pass


class VideoReplacerApp(App):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        
        # 目标路径（在Android设备上）
        self.base_path = "/storage/emulated/0/Android/data/com.smile.gifmaker/files"
        self.record_cache_dir = f"{self.base_path}/.record_cache_dir/"
        self.post_dir = f"{self.base_path}/.post/"
        self.encoding_dir = f"{self.base_path}/.encoding_output_path/"
        self.workspace_dir = f"{self.base_path}/workspace/"
        
        self.selected_video = None
        
    def build(self):
        """构建UI界面"""
        Window.clearcolor = (0.95, 0.95, 0.95, 1)
        
        # 主布局
        main_layout = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        # 标题
        title = Label(
            text='快手视频替换工具',
            size_hint=(1, 0.08),
            font_size='24sp',
            bold=True,
            color=(0.2, 0.2, 0.8, 1)
        )
        main_layout.add_widget(title)
        
        # 选择视频按钮
        self.video_label = Label(
            text='未选择视频',
            size_hint=(1, 0.06),
            color=(0.5, 0.5, 0.5, 1)
        )
        main_layout.add_widget(self.video_label)
        
        select_btn = Button(
            text='选择视频文件',
            size_hint=(1, 0.08),
            background_color=(0.3, 0.6, 1, 1)
        )
        select_btn.bind(on_press=self.select_video)
        main_layout.add_widget(select_btn)
        
        # 操作按钮区域
        btn_layout = BoxLayout(orientation='vertical', spacing=5, size_hint=(1, 0.35))
        
        self.replace_btn = Button(
            text='替换 .record_cache_dir',
            disabled=True,
            background_color=(0.2, 0.7, 0.2, 1)
        )
        self.replace_btn.bind(on_press=lambda x: self.start_replace('record'))
        btn_layout.add_widget(self.replace_btn)
        
        self.post_btn = Button(
            text='批量替换 .post 目录',
            disabled=True,
            background_color=(0.2, 0.7, 0.2, 1)
        )
        self.post_btn.bind(on_press=lambda x: self.start_replace('post'))
        btn_layout.add_widget(self.post_btn)
        
        self.encoding_btn = Button(
            text='批量替换 .encoding 目录',
            disabled=True,
            background_color=(0.2, 0.7, 0.2, 1)
        )
        self.encoding_btn.bind(on_press=lambda x: self.start_replace('encoding'))
        btn_layout.add_widget(self.encoding_btn)
        
        self.workspace_btn = Button(
            text='批量替换 workspace 目录',
            disabled=True,
            background_color=(0.2, 0.7, 0.2, 1)
        )
        self.workspace_btn.bind(on_press=lambda x: self.start_replace('workspace'))
        btn_layout.add_widget(self.workspace_btn)
        
        self.all_btn = Button(
            text='★ 一键全部替换 ★',
            disabled=True,
            background_color=(1, 0.5, 0, 1),
            bold=True
        )
        self.all_btn.bind(on_press=lambda x: self.start_replace('all'))
        btn_layout.add_widget(self.all_btn)
        
        main_layout.add_widget(btn_layout)
        
        # 日志显示区域
        log_label = Label(
            text='操作日志',
            size_hint=(1, 0.05),
            color=(0, 0, 0, 1)
        )
        main_layout.add_widget(log_label)
        
        scroll = ScrollView(size_hint=(1, 0.38))
        self.log_text = TextInput(
            text='',
            multiline=True,
            readonly=True,
            background_color=(1, 1, 1, 1),
            foreground_color=(0, 0, 0, 1)
        )
        scroll.add_widget(self.log_text)
        main_layout.add_widget(scroll)
        
        self.log_message("欢迎使用快手视频替换工具 Android版")
        self.log_message("请选择要替换的视频文件")
        
        return main_layout
    
    def select_video(self, instance):
        """选择视频文件"""
        content = BoxLayout(orientation='vertical')
        
        filechooser = FileChooserListView(
            path='/storage/emulated/0/',
            filters=['*.mp4', '*.MP4', '*.avi', '*.mov', '*.mkv']
        )
        content.add_widget(filechooser)
        
        btn_layout = BoxLayout(size_hint=(1, 0.1), spacing=10)
        
        def on_select(instance):
            if filechooser.selection:
                self.selected_video = filechooser.selection[0]
                filename = os.path.basename(self.selected_video)
                self.video_label.text = f'已选择: {filename}'
                self.video_label.color = (0, 0.7, 0, 1)
                
                # 启用所有按钮
                self.replace_btn.disabled = False
                self.post_btn.disabled = False
                self.encoding_btn.disabled = False
                self.workspace_btn.disabled = False
                self.all_btn.disabled = False
                
                self.log_message(f"已选择视频: {filename}")
                
                # 显示文件大小
                try:
                    size_mb = os.path.getsize(self.selected_video) / (1024 * 1024)
                    self.log_message(f"文件大小: {size_mb:.2f} MB")
                except:
                    pass
                
                popup.dismiss()
        
        select_btn = Button(text='确定', on_press=on_select)
        cancel_btn = Button(text='取消', on_press=lambda x: popup.dismiss())
        
        btn_layout.add_widget(select_btn)
        btn_layout.add_widget(cancel_btn)
        content.add_widget(btn_layout)
        
        popup = Popup(
            title='选择视频文件',
            content=content,
            size_hint=(0.9, 0.9)
        )
        popup.open()
    
    def log_message(self, message):
        """添加日志消息"""
        timestamp = datetime.now().strftime('%H:%M:%S')
        self.log_text.text += f"[{timestamp}] {message}\n"
        # 滚动到底部
        self.log_text.cursor = (0, len(self.log_text.text))
    
    def show_confirm(self, title, message, callback):
        """显示确认对话框"""
        content = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        msg_label = Label(text=message, size_hint=(1, 0.8))
        content.add_widget(msg_label)
        
        btn_layout = BoxLayout(size_hint=(1, 0.2), spacing=10)
        
        def on_yes(instance):
            popup.dismiss()
            callback()
        
        yes_btn = Button(text='确定', on_press=on_yes, background_color=(0, 0.8, 0, 1))
        no_btn = Button(text='取消', on_press=lambda x: popup.dismiss(), background_color=(0.8, 0, 0, 1))
        
        btn_layout.add_widget(yes_btn)
        btn_layout.add_widget(no_btn)
        content.add_widget(btn_layout)
        
        popup = Popup(
            title=title,
            content=content,
            size_hint=(0.8, 0.5)
        )
        popup.open()
    
    def show_info(self, title, message):
        """显示信息对话框"""
        content = BoxLayout(orientation='vertical', padding=10, spacing=10)
        
        msg_label = Label(text=message, size_hint=(1, 0.8))
        content.add_widget(msg_label)
        
        ok_btn = Button(
            text='确定',
            size_hint=(1, 0.2),
            on_press=lambda x: popup.dismiss()
        )
        content.add_widget(ok_btn)
        
        popup = Popup(
            title=title,
            content=content,
            size_hint=(0.8, 0.5)
        )
        popup.open()
    
    def disable_buttons(self):
        """禁用所有按钮"""
        self.replace_btn.disabled = True
        self.post_btn.disabled = True
        self.encoding_btn.disabled = True
        self.workspace_btn.disabled = True
        self.all_btn.disabled = True
    
    def enable_buttons(self):
        """启用所有按钮"""
        if self.selected_video:
            self.replace_btn.disabled = False
            self.post_btn.disabled = False
            self.encoding_btn.disabled = False
            self.workspace_btn.disabled = False
            self.all_btn.disabled = False
    
    def start_replace(self, mode):
        """开始替换操作"""
        if not self.selected_video:
            self.show_info("错误", "请先选择视频文件！")
            return
        
        messages = {
            'record': f"将替换 .record_cache_dir 目录的视频\n\n使用视频: {os.path.basename(self.selected_video)}",
            'post': f"将批量替换 .post 目录下所有子文件夹的视频\n\n使用视频: {os.path.basename(self.selected_video)}",
            'encoding': f"将批量替换 .encoding_output_path 目录下所有子文件夹的视频\n\n使用视频: {os.path.basename(self.selected_video)}",
            'workspace': f"将批量替换 workspace 目录下所有子文件夹的视频（两层）\n\n使用视频: {os.path.basename(self.selected_video)}",
            'all': f"将依次执行所有替换操作！\n\n使用视频: {os.path.basename(self.selected_video)}\n\n此过程可能需要较长时间"
        }
        
        self.show_confirm(
            "确认替换",
            messages[mode],
            lambda: self.perform_replace(mode)
        )
    
    def perform_replace(self, mode):
        """执行替换操作"""
        self.disable_buttons()
        
        def worker():
            try:
                if mode == 'record':
                    self.replace_record_cache()
                elif mode == 'post':
                    self.replace_directory(self.post_dir, ".post")
                elif mode == 'encoding':
                    self.replace_directory(self.encoding_dir, ".encoding")
                elif mode == 'workspace':
                    self.replace_workspace()
                elif mode == 'all':
                    self.replace_all()
                
                Clock.schedule_once(lambda dt: self.show_info("完成", "替换操作完成！"))
            except Exception as e:
                Clock.schedule_once(lambda dt: self.show_info("错误", f"操作失败: {str(e)}"))
            finally:
                Clock.schedule_once(lambda dt: self.enable_buttons())
        
        threading.Thread(target=worker, daemon=True).start()
    
    def replace_record_cache(self):
        """替换 record_cache_dir 目录"""
        Clock.schedule_once(lambda dt: self.log_message("=== 开始替换 .record_cache_dir 目录 ==="))
        
        if not os.path.exists(self.record_cache_dir):
            Clock.schedule_once(lambda dt: self.log_message(f"目录不存在: {self.record_cache_dir}"))
            return
        
        # 查找mp4文件
        videos = [f for f in os.listdir(self.record_cache_dir) if f.endswith('.mp4')]
        
        if not videos:
            Clock.schedule_once(lambda dt: self.log_message("未找到视频文件"))
            return
        
        target_file = os.path.join(self.record_cache_dir, videos[0])
        Clock.schedule_once(lambda dt: self.log_message(f"目标文件: {videos[0]}"))
        
        # 删除原文件
        os.remove(target_file)
        Clock.schedule_once(lambda dt: self.log_message("已删除原文件"))
        
        # 复制新视频
        shutil.copy2(self.selected_video, target_file)
        Clock.schedule_once(lambda dt: self.log_message(f"✓ 替换成功: {videos[0]}"))
    
    def replace_directory(self, base_path, dir_name):
        """替换指定目录下所有子文件夹的视频"""
        Clock.schedule_once(lambda dt: self.log_message(f"=== 开始批量替换 {dir_name} 目录 ==="))
        
        if not os.path.exists(base_path):
            Clock.schedule_once(lambda dt: self.log_message(f"目录不存在: {base_path}"))
            return
        
        # 获取所有子文件夹
        subfolders = [f for f in os.listdir(base_path) 
                     if os.path.isdir(os.path.join(base_path, f))]
        
        if not subfolders:
            Clock.schedule_once(lambda dt: self.log_message("未找到子文件夹"))
            return
        
        Clock.schedule_once(lambda dt: self.log_message(f"找到 {len(subfolders)} 个子文件夹"))
        
        # 收集所有视频文件
        videos_to_replace = []
        for folder in subfolders:
            folder_path = os.path.join(base_path, folder)
            for file in os.listdir(folder_path):
                if file.endswith(('.mp4', '.MP4', '.avi', '.mov', '.mkv')):
                    full_path = os.path.join(folder_path, file)
                    videos_to_replace.append((full_path, file))
        
        Clock.schedule_once(lambda dt: self.log_message(f"找到 {len(videos_to_replace)} 个视频文件"))
        
        # 替换所有视频
        replaced = 0
        for video_path, video_name in videos_to_replace:
            try:
                os.remove(video_path)
                shutil.copy2(self.selected_video, video_path)
                replaced += 1
                Clock.schedule_once(lambda dt, vn=video_name: self.log_message(f"✓ 替换: {vn}"))
            except Exception as e:
                Clock.schedule_once(lambda dt, vn=video_name: self.log_message(f"✗ 失败: {vn}"))
        
        Clock.schedule_once(lambda dt: self.log_message(f"完成！成功替换 {replaced} 个视频"))
    
    def replace_workspace(self):
        """替换workspace目录（两层子文件夹）"""
        Clock.schedule_once(lambda dt: self.log_message("=== 开始批量替换 workspace 目录（两层）==="))
        
        if not os.path.exists(self.workspace_dir):
            Clock.schedule_once(lambda dt: self.log_message(f"目录不存在: {self.workspace_dir}"))
            return
        
        # 获取第一层子文件夹
        first_level = [f for f in os.listdir(self.workspace_dir) 
                       if os.path.isdir(os.path.join(self.workspace_dir, f))]
        
        Clock.schedule_once(lambda dt: self.log_message(f"找到 {len(first_level)} 个第一层文件夹"))
        
        # 获取第二层子文件夹
        second_level = []
        for folder1 in first_level:
            path1 = os.path.join(self.workspace_dir, folder1)
            for folder2 in os.listdir(path1):
                path2 = os.path.join(path1, folder2)
                if os.path.isdir(path2):
                    second_level.append(path2)
        
        Clock.schedule_once(lambda dt: self.log_message(f"找到 {len(second_level)} 个第二层文件夹"))
        
        # 收集所有视频
        videos_to_replace = []
        for folder_path in second_level:
            for file in os.listdir(folder_path):
                if file.endswith(('.mp4', '.MP4', '.avi', '.mov', '.mkv')):
                    full_path = os.path.join(folder_path, file)
                    videos_to_replace.append((full_path, file))
        
        Clock.schedule_once(lambda dt: self.log_message(f"找到 {len(videos_to_replace)} 个视频文件"))
        
        # 替换所有视频
        replaced = 0
        for video_path, video_name in videos_to_replace:
            try:
                os.remove(video_path)
                shutil.copy2(self.selected_video, video_path)
                replaced += 1
                Clock.schedule_once(lambda dt, vn=video_name: self.log_message(f"✓ 替换: {vn}"))
            except Exception as e:
                Clock.schedule_once(lambda dt, vn=video_name: self.log_message(f"✗ 失败: {vn}"))
        
        Clock.schedule_once(lambda dt: self.log_message(f"完成！成功替换 {replaced} 个视频"))
    
    def replace_all(self):
        """依次执行所有替换操作"""
        Clock.schedule_once(lambda dt: self.log_message("=" * 60))
        Clock.schedule_once(lambda dt: self.log_message("开始一键全部替换！"))
        Clock.schedule_once(lambda dt: self.log_message("=" * 60))
        
        try:
            Clock.schedule_once(lambda dt: self.log_message("\n[1/4] 替换 .record_cache_dir"))
            self.replace_record_cache()
            
            Clock.schedule_once(lambda dt: self.log_message("\n[2/4] 批量替换 .post"))
            self.replace_directory(self.post_dir, ".post")
            
            Clock.schedule_once(lambda dt: self.log_message("\n[3/4] 批量替换 .encoding"))
            self.replace_directory(self.encoding_dir, ".encoding")
            
            Clock.schedule_once(lambda dt: self.log_message("\n[4/4] 批量替换 workspace"))
            self.replace_workspace()
            
            Clock.schedule_once(lambda dt: self.log_message("\n" + "=" * 60))
            Clock.schedule_once(lambda dt: self.log_message("一键全部替换完成！"))
            Clock.schedule_once(lambda dt: self.log_message("=" * 60))
        except Exception as e:
            Clock.schedule_once(lambda dt: self.log_message(f"错误: {str(e)}"))


if __name__ == '__main__':
    VideoReplacerApp().run()
