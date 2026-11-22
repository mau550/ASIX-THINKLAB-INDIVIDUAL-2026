#!/usr/bin/env python3
"""Genera la galería de evidencias de cada máquina y el índice EVIDENCIAS.md.

Uso (desde la raíz del repositorio):  python3 scripts/galeria-evidencias.py

- En cada maquinas/<vm>/README.md escribe (o reescribe) la sección entre las
  marcas <!-- GALERIA:inicio --> y <!-- GALERIA:fin --> con TODAS las capturas
  incrustadas y TODAS las salidas de comandos enlazadas, en orden.
- En la raíz crea EVIDENCIAS.md con el índice de todo, por máquina.
"""
import os
import re

RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
INI, FIN = "<!-- GALERIA:inicio -->", "<!-- GALERIA:fin -->"


def leyenda(nombre):
    base = os.path.splitext(nombre)[0]
    base = re.sub(r"^[a-z0-9]+-(?=\d)", "", base)      # quita prefijo tipo srv-, mk-
    num = re.match(r"^(\d+)-?", base)
    texto = base[num.end():] if num else base
    texto = texto.replace("-", " ").strip() or base
    return (num.group(1) + ". " if num else "") + texto[:1].upper() + texto[1:]


def titulo_salida(ruta):
    with open(ruta, encoding="utf-8", errors="replace") as f:
        for linea in f:
            linea = linea.strip()
            if linea:
                return linea.lstrip("# ").strip()
    return os.path.basename(ruta)


def ficheros(carpeta, ext):
    if not os.path.isdir(carpeta):
        return []
    return sorted(f for f in os.listdir(carpeta) if f.lower().endswith(ext))


def galeria(vm_dir):
    caps = ficheros(os.path.join(vm_dir, "capturas"), (".png", ".jpg", ".gif"))
    sals = ficheros(os.path.join(vm_dir, "salidas"), (".txt", ".log", ".md"))
    if not caps and not sals:
        return None, 0, 0
    out = [INI, "", "## Galería de evidencias", "",
           "Todas las pruebas de esta máquina, en el orden en que se hicieron. "
           "Las capturas son de la propia VM; las salidas son el texto literal de "
           "los comandos ejecutados, con fecha y hora en la primera línea.", ""]
    if sals:
        out += ["### Salidas de comandos", "", "| # | Fichero | Qué demuestra |", "|---|---|---|"]
        for i, s in enumerate(sals, 1):
            t = titulo_salida(os.path.join(vm_dir, "salidas", s)).replace("|", "\\|")
            out.append(f"| {i} | [`{s}`](salidas/{s}) | {t} |")
        out.append("")
    if caps:
        out += ["### Capturas", ""]
        for c in caps:
            ley = leyenda(c)
            out += [f"<details open><summary><b>{ley}</b> · <code>{c}</code></summary>", "",
                    f"![{ley}](capturas/{c})", "", "</details>", ""]
    out.append(FIN)
    return "\n".join(out), len(caps), len(sals)


def main():
    maq = os.path.join(RAIZ, "maquinas")
    indice = ["# Índice de evidencias", "",
              "Todas las capturas y salidas de comandos del laboratorio, por máquina. "
              "Cada máquina tiene además su galería completa al final de su README.", "",
              "| Máquina | Capturas | Salidas | Galería |", "|---|---:|---:|---|"]
    detalle = []
    tc = ts = 0
    for vm in sorted(os.listdir(maq)):
        d = os.path.join(maq, vm)
        readme = os.path.join(d, "README.md")
        if not os.path.isfile(readme):
            continue
        g, nc, ns = galeria(d)
        if g is None:
            continue
        tc += nc
        ts += ns
        txt = open(readme, encoding="utf-8").read()
        if INI in txt and FIN in txt:
            txt = txt[:txt.index(INI)] + g + txt[txt.index(FIN) + len(FIN):]
        else:
            txt = txt.rstrip() + "\n\n" + g + "\n"
        open(readme, "w", encoding="utf-8").write(txt)
        indice.append(f"| [`{vm}`](maquinas/{vm}/README.md) | {nc} | {ns} | "
                      f"[ver galería](maquinas/{vm}/README.md#galería-de-evidencias) |")
        detalle += ["", f"## `{vm}`", ""]
        for s in ficheros(os.path.join(d, "salidas"), (".txt", ".log", ".md")):
            detalle.append(f"- 📄 [`{s}`](maquinas/{vm}/salidas/{s}) — "
                           f"{titulo_salida(os.path.join(d, 'salidas', s))}")
        for c in ficheros(os.path.join(d, "capturas"), (".png", ".jpg", ".gif")):
            detalle.append(f"- 🖼️ [{leyenda(c)}](maquinas/{vm}/capturas/{c})")
    indice.append(f"| **Total** | **{tc}** | **{ts}** | |")
    # Otras evidencias fuera de maquinas/
    otras = []
    for sub in ("anexos", "incidencias", "tareas", "diagramas"):
        for dp, _, fs in os.walk(os.path.join(RAIZ, sub)):
            for f in sorted(fs):
                if f.lower().endswith((".png", ".jpg", ".svg", ".txt", ".pdf")):
                    r = os.path.relpath(os.path.join(dp, f), RAIZ)
                    otras.append(f"- [`{r}`]({r})")
    if otras:
        detalle += ["", "## Otras evidencias (anexos, incidencias, tareas, diagramas)", ""] + sorted(otras)
    with open(os.path.join(RAIZ, "EVIDENCIAS.md"), "w", encoding="utf-8") as f:
        f.write("\n".join(indice + detalle) + "\n")
    print(f"capturas: {tc}  salidas: {ts}")


if __name__ == "__main__":
    main()
