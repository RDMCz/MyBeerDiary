# Můj pivní deníček

## Changelog

### verze 0.2.2 (WIP)

* Po odškrtunutí odhadu ABV na základě EPM je pole pro ABV vyčištěno; vyplnit novou hodnotu je asi přívětivější než upravovat tu odhadnutou
* Obrazovka _Statistika události_: Přidána konverze celkového objemu vypitého piva na půllitry
* Obrazovka _Celková statistika_:
  * Přidána sekce top pivovarů
  * Přidána informace o průměrné ceně placeného piva, do které se nepočítají piva zdarma

### verze 0.2.1 (28.09.2026 20:55)

* Pole pro odhad procent alkoholu ze stupňovistosti je nyní ve výchozím stavu zaškrtnuté
* Opravy:
  * Dlouhé názvy pivovaru a popisy piva jsou nyní zkráceny nebo zalomeny na nový řádek, a nepřetečou tak mimo obrazovku
  * _Celková statistika_: Celkový objem v litrech je zaokrouhlen

### verze 0.2.0 (21.09.2026 22:50)

* Přidána možnost zálohy databáze do souboru a obnovení zálohy ze souboru, např. na novém zařízení
* Našeptávač názvu pivovaru nyní nabízí kromě předpřipravených jmen i ta jména, která byla do databáze přidána uživatelem
* Obrazovka _Statistika události_:
  * Karta s průměrným pivem nyní neobsahuje název pivovaru a popis piva, protože se jednalo o statistiku, která nedávala příliš velký smysl
  * Jedná-li se o probíhající událost, pak je nyní zobrazena také informace o aktuálním promile
  * Graf: snížena maximální úroveň přiblížení a mírně zvýšena citlivost pro zobrazení tooltipu

### verze 0.1.0 (14.09.2026 19:43)

* První vydání

## Sestavení

Příkazem `flutter build apk`

Výstup se nachází v `MyBeerDiary\build\app\outputs\flutter-apk`
