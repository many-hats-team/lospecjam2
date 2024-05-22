
TAB = "\t"
NL = "\n"

def main():
    palette = [
        0xff032b,
        0x800034,
        0xffff0d,
        0xff8f00,
        0x0aff0a,
        0x007062,
        0x0dffff,
        0x3c80db,
        0x2929ff,
        0x2d006e,
        0xff08ff,
        0x6e0085,
        0x260a34,
        0x000000,
        0xffffff,
        0x7d7da3,
    ]

    vecs: list[str] = []

    for p in palette:
        r = ((p & 0xff0000) >> 16)
        g = ((p & 0x00ff00) >> 8)
        b = ((p & 0x0000ff) >> 0)
        vecs.append(f"vec3({r}.0/255.0, {g}.0/255.0, {b}.0/255.0)")

    vecs_str = f",{NL}{TAB}".join(vecs)

    print(f"""
const vec3 palette[] = {{
{TAB}{vecs_str}
}};
const int palette_size = {len(palette)};
""")

if __name__ == "__main__":
    main()
