"""RF-01: interpreta consultas en lenguaje cotidiano (PLN ligero y determinista).

Se usan reglas en lugar de un LLM para extraer el perfil: es instantáneo y
ayuda a cumplir RNF-01 (< 1.5 s). La parte "semántica" la cubren los embeddings.
"""
import re
import unicodedata

from schemas import PerfilDetectado

TIPOS_PIEL = {
    "grasa": ["grasa", "grasosa", "oleosa", "brillo", "brilla"],
    "seca": ["seca", "resequedad", "reseca", "resecas", "tirante", "deshidratada"],
    "mixta": ["mixta", "zona t"],
    "sensible": ["sensible", "irritada", "irritacion", "rojeces", "alergia"],
    "normal": ["normal"],
}

NECESIDADES = {
    "acne": ["acne", "granos", "espinillas", "barros", "imperfecciones"],
    "manchas": ["manchas", "hiperpigmentacion", "melasma"],
    "arrugas": ["arrugas", "antiedad", "anti edad", "lineas de expresion"],
    "poros": ["poros", "puntos negros"],
    "cobertura_alta": ["mucha cobertura", "cobertura alta", "cobertura total"],
    "larga_duracion": ["larga duracion", "no se corra", "waterproof", "resistente al agua"],
}

CATEGORIAS = {
    "base": ["base", "base de maquillaje", "foundation"],
    "corrector": ["corrector", "concealer"],
    "labial": ["labial", "labios", "lipstick", "gloss", "brillo labial"],
    "sombras": ["sombra", "sombras", "paleta"],
    "rubor": ["rubor", "colorete", "blush"],
    "mascara": ["mascara de pestanas", "pestanina", "rimel", "pestanas"],
    "polvo": ["polvo", "polvos compactos", "polvo compacto"],
    "skincare": ["crema", "serum", "limpiador", "hidratante", "protector solar", "skincare"],
}

MARCAS = [
    "maybelline", "loreal", "revlon", "nyx", "ruby rose", "catrice",
    "essence", "vogue", "eucerin", "cerave", "ushas", "salome",
    "dolce bella", "katire", "ame", "valmy", "mon reve",
]


def _normalizar(texto: str) -> str:
    t = unicodedata.normalize("NFD", texto.lower())
    t = "".join(c for c in t if unicodedata.category(c) != "Mn")
    return re.sub(r"\s+", " ", t).strip()


def _contiene(texto: str, palabra: str) -> bool:
    return re.search(rf"\b{re.escape(palabra)}\b", texto) is not None


def extraer_perfil(mensaje: str) -> PerfilDetectado:
    t = _normalizar(mensaje)

    tipo_piel = next(
        (tipo for tipo, claves in TIPOS_PIEL.items() if any(_contiene(t, c) for c in claves)),
        None,
    )
    necesidades = [
        n for n, claves in NECESIDADES.items() if any(_contiene(t, c) for c in claves)
    ]
    categoria = next(
        (c for c, claves in CATEGORIAS.items() if any(_contiene(t, k) for k in claves)),
        None,
    )
    marca = next((m for m in MARCAS if _contiene(t, m)), None)

    precio_max = None
    m = re.search(
        r"(?:menos de|maximo|max|hasta|no mas de|por debajo de|presupuesto de)\s*\$?\s*(\d+(?:[.,]\d+)?)",
        t,
    ) or re.search(r"\$\s*(\d+(?:[.,]\d+)?)", t)
    if m:
        precio_max = float(m.group(1).replace(",", "."))

    return PerfilDetectado(
        tipo_piel=tipo_piel,
        necesidades=necesidades,
        precio_max=precio_max,
        categoria=categoria,
        marca=marca,
    )


def texto_para_embedding(mensaje: str, perfil: PerfilDetectado) -> str:
    """Enriquece la consulta con el perfil para mejorar la búsqueda semántica."""
    extra = []
    if perfil.tipo_piel:
        extra.append(f"piel {perfil.tipo_piel}")
    extra.extend(perfil.necesidades)
    return mensaje + (". " + ", ".join(extra) if extra else "")
