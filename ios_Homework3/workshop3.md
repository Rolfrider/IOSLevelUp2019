### Workshop #3

# Cover Collection App

### Opis zadania

Celem zadania jest stworzenie aplikacji **Cover Collection**. Aplikacja składa się z jednego ekranu, który cały zawiera `UICollectionView`. W Collection View znajduje się 100 elementów – kwadratowych prostych komórek. Nie korzystamy z żadnych *Supplementary View*, ani *Decoration View* (w tym zadaniu).

Zachowanie aplikacji zaprezentowane jest na załączonym [filmie](film.mov).

### Wymagania

1. Komórki Collection View są ułożone po kolei i przewijają się poziomo. Na każdej komórce widać jej indeks
2. Komórka najbardziej na środku jest podświetlona na czerwono (podświetla płynnie w miarę przewijania)
3. Komórka najbardziej na środku jest powiększona (a właściwie to wszystkie inne są pomniejszone)
4. Scrollowania nie da się zatrzymać "pomiędzy" komórkami – zawsze jest jakaś komórka która jest wyśrodkowana
5. Aplikacja obsługuje zmianę orientacji (✌️🌈) – po rotacji wciąż mamy zaznaczoną **tą samą** komórkę

### Wskazówki

- ad 1. Za każdym razem gdy używasz Collection View – krok pierwszy to **zastanów się, czy możesz do tego użyć `UICollectionViewFlowLayout`**.
- ad 2. Zastanów się jakie atrubyty musisz przekazać komórkom z layoutu.
- ad 4. Użyj do tego metody delegate `UIScrollView` (*scrollViewWillEndDragging:withVelocity:targetContentOffset:*)
- ad 5. `invalidateLayout()`, oraz trzeba policzyć nowy `contentOffset` po rotacji.
- Dziedzicząc po `UICollectionViewFlowLayout` musisz przeciążyć dwie metody: `layoutAttributesForElementsInRect` oraz `layoutAttributesForItemAtIndexPath`
- Pamiętaj, że w przypadku naszego `CoverLayout` parametry layoutu zmieniają się w każdej klatce scrollowania (metoda `shouldInvalidateLayoutForBoundsChange`).
- Dodając nowe właściwości (dziedzicząc po `UICollectionViewLayoutAttributes`) pamiętaj żeby **poprawnie** przeciążyć `copy()` oraz `isEqual`.
- Pamiętaj żeby w swojej `UICollectionViewCell` przeciążyć metodę `applyLayoutAttributes`.

### Odpowiedzi

Odpowiedź (cały, spakowany w .zip folder projektu) wyślij mailem na adres [email](mailto:ios@daftacademy.pl) do końca najbliższej soboty: **30.03.2019, 23:59**.
