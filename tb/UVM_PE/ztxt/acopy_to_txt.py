#将父文件夹内所有文件复制为同名txt文件
import os
import shutil


def process_text_files():
    # 获取当前脚本所在目录 (E)
    target_dir = os.path.dirname(os.path.abspath(__file__))
    # 获取父目录 (A)
    parent_dir = os.path.dirname(target_dir)

    print(f"当前工作目录: {target_dir}")
    print(f"父目录: {parent_dir}")

    # 找出与E目录同级的其他文件夹
    source_dirs = []
    for dir_name in os.listdir(parent_dir):
        dir_path = os.path.join(parent_dir, dir_name)
        if os.path.isdir(dir_path) and dir_path != target_dir:
            source_dirs.append(dir_path)
            print(f"找到源目录: {dir_path}")

    # 支持的文本文件扩展名
    text_extensions = {'.sv', '.v','.c', '.f', '.svh','.txt', '.log', '.md', '.tcl'}  # 可根据需要添加

    # 遍历所有源文件夹
    for src_dir in source_dirs:
        for foldername, _, filenames in os.walk(src_dir):
            for filename in filenames:
                # 检查文件扩展名
                file_ext = os.path.splitext(filename)[1].lower()
                if file_ext not in text_extensions:
                    continue

                src_file = os.path.join(foldername, filename)
                # 生成新文件名（无原后缀）
                new_filename = os.path.splitext(filename)[0] + '.txt'
                dest_file = os.path.join(target_dir, new_filename)

                try:
                    # 复制文件内容
                    shutil.copy(src_file, dest_file)
                    print(f"已创建: {dest_file} (来自 {src_file})")

                except Exception as e:
                    print(f"处理文件失败 {src_file}: {str(e)}")


if __name__ == "__main__":
    process_text_files()