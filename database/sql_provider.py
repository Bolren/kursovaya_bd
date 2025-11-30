import os

class SQLProvider:
    def __init__(self, file_path):
        self.scripts = {} # инициализируем словарь
        for file in os.listdir(file_path): # цикл по всем файлам во входной директории
            _sql = open(f'{file_path}/{file}').read()
            self.scripts[file] = _sql # заносит sql запрос в словарь, где ключ это имя файла

    def get(self, file):
        _sql = self.scripts[file]
        return _sql