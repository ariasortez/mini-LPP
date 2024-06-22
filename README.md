# Proyecto de Compilación y Ejecución

Este proyecto es una guía para compilar y ejecutar archivos utilizando CMake y una herramienta personalizada `lpp` junto con `EasyASM-x86`.

## Requisitos

- CMake
- make
- EasyASM-x86

## Pasos para Compilar y Ejecutar

1. **Crear el directorio de compilación**:

    ```bash
    mkdir build
    ```

2. **Ejecutar CMake desde el directorio de compilación**:

    ```bash
    cd build
    cmake ../
    ```

3. **Compilar el proyecto**:

    ```bash
    make
    ```

4. **Ejecutar el compilador personalizado**:

    ```bash
    ./lpp ../tests/filename.lpp filename.asm
    ```

5. **Ejecutar el archivo ensamblado usando EasyASM-x86**:

    ```bash
    ../EasyASM-x86 --run filename.asm
    ```

## Notas

- Reemplazar `filename` por el nombre del archivo que deseas compilar y ejecutar.
- Asegurarse de que `EasyASM-x86` esté en el directorio correcto para ser ejecutado desde el comando especificado.

