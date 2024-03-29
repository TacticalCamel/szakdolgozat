﻿# Nyelv specifikációk

## 1 Program fejléc
Egy program fejléce három alapvető részből épül fel. A modul szegmens, az import szegmens, és a paraméter szegmens. Ezek az átláthatóság érdekében csak az előbb felsorolt sorrendben követhetik egymást.

### 1.1 Modul szegmens
```
module <mudulnév>
```

### 1.2 Import szegmens
Nulla vagy több `import` utasításból álló programrészlet, melyek célja jelezni az értelmezőnek, hogy az adott modulból használunk kódot. Rendelkezésre áll automatikus importálás használata is, amivel az értelmező minden elérhető modulban keresi a szükséges típusokat és függvényeket, és importálja azt, amely szükséges is. Ez természetesen időigényesebb, illetve egyes nevek ütközéséhez vezethet. Annak ellenére, hogy felesleges, az automatikus importálás nem zárja ki több import utasítás használatát.
```
import <modulnév>
import auto
```

### 1.3 Paraméter szegmens
A programnak lehetnek be- és kimeneti paraméterei. A megfelelő kulcsszó után egy függvény fejlécéhez hasonlóan, `,`-vel elválasztva lehet felsorolni egy vagy több paraméter típusát és azonosítóját. A be- és kimenő paraméterek sorrendje felcserélhető, külön-külön elhagyhatóak, illetve paraméterek felsorolása helyett a `null` kifejezéssel expliciten jelezhető a paraméterek hiánya.

### 1.3.1 Bemeneti paraméterek
Az `in` paraméterek a program bemeneti értékei. Ha a program indulásakor egy bemeneti paraméter nem kap értéket, vagy a kapott érték nem megfelelő típusú, a változó `null` lesz.
```
in <típus> <változónév>, <típus> <változónév>, ...
in null
```

### 1.3.2 Kimeneti paraméterek
Az `out` paraméterek visszatérési értékei. Minden kimeneti paraméter kezdetben `null`, és a program futása során kaphatnak újabb értéket.
```
out <típus> <változónév>, <típus> <változónév>, ...
out null
```

## 2 Program test
Itt helyezkedik el a programkód, ami futtatásra kerül. Ez tetszőlegesen sok utasításból, illetve függvény- és típusdefinícióból állhat.

### 2.1 Függvénydefiníció

### 2.2 Típusdefiníció

### 2.3 Utasítás


## Változók
Minden típus ősosztálya (közvetlenül vagy közvetetten) az `object`. Minden típus referenciatípus, azaz paraméterben való átadáskor, vagy függvényből való visszatéréskor egy változóról nem készül másolat. Ennek köszönhetően minden változó értéke lehet `null` is.
Egy változó létrehozásakor kötelező azt egy típussal ellátni, értéket adni viszont opcionális, melynek hiányában `null` lesz a kezdőérték.
```
<típus> <név>;
<típus> <név> = <érték>;
```
A változókra azonosítókkal tudunk hivatkozni. Ezek számokat (0-9), kis- és nagybetűket (a-z és A-Z) és alsóvonásokat (_) tartalmazhatnak azzal a kitétellel, hogy az első karakter nem lehet szám. Például a `_name` és a `_0` azonosítók helyesek, viszont a `2name` nem. Egy változó hatásköre az a blokk, amiben létre lett hozva.

## Típusok

#### Előjeles egész számok
Nevük az "i" (mint "integer") prefix, amit a bitek száma követ. Létezik 8, 16, 32, és 64 bites változat, melyek rendre az `i8`, `i16`, `i32` és `i64`.
```
i32 x = -1;
i64 y = 2;
```
#### Előjeltelen egész számok
Nevük az "u" (mint "unsigned") prefix, amit a bitek száma követ. Létezik 8, 16, 32, és 64 bites változat, melyek rendre az `u8`, `u16`, `u32` és `u64`.
```
u32 x = 1;
u64 y = 2;
```
#### Lebegőpontos számok
Nevük az "f" (mint "float") prefix, amit a bitek száma követ. Létezik 16, 32, és 64 bites változat, melyek rendre az `f16`, `f32` és `f64`.
```
f32 x = 0.1234;
f64 y = 3.1415927;
```
#### Boolean
A `bool` névre hallgató osztály, ami csak a `true` (igaz), vagy a `false` (hamis) értéket veheti fel.
```
bool x = true;
bool y = 3 > 4;
```
#### Karakterek
A `char` osztály egyetlen unicode kódolású karaktert képvisel, amely 16 biten helyezkedik el.
```
char a = 'a';
char b = '\n';
char c = '\u0020'
```

### Szöveg
A `string` osztály egy 0 vagy több karakter sorozatából álló szöveget képvisel.
```
string a = "";
string b = "text";
string c = "multiple\nlines\n";

string d = f"string b: {b}";
string e = v"also
multiple
lines";
```
