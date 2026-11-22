#!/usr/bin/env python3
"""Genera un PDF por tarea (tareas/T*.md) para entregar, con el enlace al repositorio.

Uso (desde la raíz del repositorio):  python3 scripts/tareas-a-pdf.py [carpeta_salida]
Salida por defecto: entregas/pdf/. Necesita python3-markdown y Google Chrome.

- Las tareas con varias partes (p. ej. T5-*.md) se unen en un único PDF.
- Las imágenes del repositorio se incrustan; los enlaces relativos se convierten
  en enlaces a GitHub para que funcionen desde el PDF.
- Los diagramas Mermaid se dibujan con mermaid.js antes de imprimir.
"""
import glob
import html
import os
import re
import subprocess
import sys
import tempfile

import markdown

REPO = "https://github.com/mau550/ASIX-THINKLAB-INDIVIDUAL-2026"
RAMA = "main"
RAIZ = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ALUMNO = "Mauro Bas Montes · 1.º ASIX · Grupo 3 · Puesto 29"

CSS = """
@page { size: A4; margin: 16mm 14mm 18mm 14mm; }
body { font-family: 'DejaVu Sans', Arial, sans-serif; font-size: 10.5pt; color: #1f2328; line-height: 1.45; }
h1 { font-size: 19pt; border-bottom: 3px solid #0b5cad; padding-bottom: 4px; color: #0b3d75; }
h2 { font-size: 14pt; color: #0b3d75; border-bottom: 1px solid #d0d7de; padding-bottom: 2px; margin-top: 22px; }
h3 { font-size: 12pt; color: #24292f; }
table { border-collapse: collapse; width: 100%; margin: 8px 0; font-size: 9.3pt; page-break-inside: auto; }
th, td { border: 1px solid #d0d7de; padding: 4px 6px; vertical-align: top; text-align: left; }
th { background: #eef4fb; }
tr { page-break-inside: avoid; }
code { font-family: 'DejaVu Sans Mono', monospace; font-size: 8.8pt; background: #f3f5f7; padding: 0 3px; border-radius: 3px; }
pre { background: #f6f8fa; border: 1px solid #d0d7de; padding: 8px; white-space: pre-wrap; word-break: break-word; font-size: 8.5pt; }
pre code { background: none; padding: 0; }
img { max-width: 100%; max-height: 120mm; display: block; margin: 8px auto; border: 1px solid #d0d7de; page-break-inside: avoid; }
blockquote { border-left: 4px solid #0b5cad; margin: 8px 0; padding: 4px 10px; background: #f3f8fe; }
a { color: #0b5cad; text-decoration: none; }
.portada { border: 2px solid #0b5cad; border-radius: 6px; padding: 10px 14px; margin-bottom: 14px; background: #f3f8fe; font-size: 10pt; }
.portada b { color: #0b3d75; }
.parte { page-break-before: always; }
.mermaid { text-align: center; margin: 10px 0; page-break-inside: avoid; }
"""


def url_repo(ruta_rel, es_img):
    modo = "raw" if es_img else "blob"
    return f"{REPO}/{modo}/{RAMA}/{ruta_rel}"


def convertir(md_path):
    texto = open(md_path, encoding="utf-8").read()
    base = os.path.dirname(md_path)
    # Mermaid: se guarda aparte para que markdown no lo toque
    bloques = []

    def guarda(m):
        bloques.append(m.group(1))
        return f"\n\nMERMAIDBLOQUE{len(bloques) - 1}\n\n"
    texto = re.sub(r"```mermaid\n(.*?)```", guarda, texto, flags=re.S)
    cuerpo = markdown.markdown(texto, extensions=["tables", "fenced_code", "sane_lists", "md_in_html"])
    for i, b in enumerate(bloques):
        cuerpo = cuerpo.replace(f"<p>MERMAIDBLOQUE{i}</p>", f'<div class="mermaid">{html.escape(b)}</div>')

    def arregla(m):
        attr, url = m.group(1), m.group(2)
        if re.match(r"^(https?:|mailto:|#|data:)", url):
            return m.group(0)
        ruta, _, ancla = url.partition("#")
        abs_ = os.path.normpath(os.path.join(base, ruta))
        rel = os.path.relpath(abs_, RAIZ).replace(os.sep, "/")
        es_img = attr == "src"
        if es_img and os.path.isfile(abs_):
            return f'{attr}="file://{abs_}"'
        dest = url_repo(rel, es_img) + (f"#{ancla}" if ancla else "")
        return f'{attr}="{dest}"'
    cuerpo = re.sub(r'(href|src)="([^"]+)"', arregla, cuerpo)
    return cuerpo


def pdf(grupo, salida):
    partes = []
    for i, md in enumerate(grupo):
        rel = os.path.relpath(md, RAIZ).replace(os.sep, "/")
        clase = ' class="parte"' if i else ""
        partes.append(f"<section{clase}><p style='font-size:8.5pt;color:#57606a'>Documento en el repositorio: "
                      f"<a href='{url_repo(rel, False)}'>{url_repo(rel, False)}</a></p>{convertir(md)}</section>")
    titulo = re.sub(r"^#\s*", "", open(grupo[0], encoding="utf-8").readline()).strip()
    portada = (f"<div class='portada'><b>ASIX ThinkLab · Laboratorio individual</b> — {ALUMNO}<br>"
               f"<b>Repositorio con toda la documentación y las evidencias:</b> "
               f"<a href='{REPO}'>{REPO}</a><br>"
               f"Índice de evidencias: <a href='{REPO}/blob/{RAMA}/EVIDENCIAS.md'>{REPO}/blob/{RAMA}/EVIDENCIAS.md</a></div>")
    doc = (f"<!DOCTYPE html><html lang='es'><head><meta charset='utf-8'><title>{html.escape(titulo)}</title>"
           f"<style>{CSS}</style>"
           "<script src='https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js'></script></head><body>"
           f"{portada}{''.join(partes)}"
           "<script>if(window.mermaid){mermaid.initialize({startOnLoad:true,theme:'default'});}</script>"
           "</body></html>")
    with tempfile.NamedTemporaryFile("w", suffix=".html", delete=False, encoding="utf-8") as f:
        f.write(doc)
        tmp = f.name
    subprocess.run(["google-chrome", "--headless=new", "--disable-gpu", "--no-sandbox",
                    "--allow-file-access-from-files", "--virtual-time-budget=15000",
                    "--no-pdf-header-footer", f"--print-to-pdf={salida}", f"file://{tmp}"],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, timeout=180)
    os.unlink(tmp)


def main():
    destino = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(RAIZ, "entregas", "pdf"))
    os.makedirs(destino, exist_ok=True)
    grupos = {}
    for md in sorted(glob.glob(os.path.join(RAIZ, "tareas", "T*.md"))):
        t = re.match(r"(T\d+)", os.path.basename(md)).group(1)
        grupos.setdefault(t, []).append(md)
    for t, mds in sorted(grupos.items(), key=lambda x: int(x[0][1:])):
        nombre = os.path.basename(mds[0])[:-3] if len(mds) == 1 else f"{t}-completa"
        out = os.path.join(destino, f"{nombre}.pdf")
        pdf(mds, out)
        print(f"{out}  ({os.path.getsize(out) // 1024} KB, {len(mds)} documento/s)")


if __name__ == "__main__":
    main()
