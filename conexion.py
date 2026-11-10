import mysql.connector
from mysql.connector import Error

def crear_conexion():
    try:
        conexion = mysql.connector.connect(
            host='localhost',
            database='uplay_db',  # O el nombre que le hayas puesto a tu BD
            user='root',          # Tu usuario de MySQL
            password='S@28061303',
            port=3306
        )
        if conexion.is_connected():
            return conexion
    except Error as e:
        print(f"Error al conectar a la base de datos: {e}")
        return None
    
    