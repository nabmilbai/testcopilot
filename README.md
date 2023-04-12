# Mall-repo för NAB PTE

Instruktion för att skapa nytt repo

1. Skapa nytt repo på DevOps
1. Klona repot lokalt (till t.ex. VSCode)
1. Öppna mappen för det klonade repot i VSCode (inte .code-workspace-filen ännu)
1. Ladda ner senaste versionen av mall-repot via "Download as Zip" på https://dev.azure.com/nab/NAB%20Git%20Templates/_git/NAB%20PTE%20TEMPLATE
1. Kopiera filer och mappar från denna zip-mall och klistra in i din lokala repo som skapats ovan
1. Använd "Sök och ersätt i filer" (Ctrl+Shift+H) i VSCode på nedan taggar (inkl. []).

| Sök efter                 | Ersätt med                                                                            | Exempel  
| -------------             | -------------                                                                         | -----
| NAB KMILBAI Modifications                 | Namnet på appen                                                                       | NAB Kxxx Modifications
| KMILBAI - AL Training      | DevOps-projektet för denna app                                                        | Kxxx - Kundens namn
| KMILBAIMod           | Kort namn, utan mellanslag, används av permission sets. Max 14tkn!                    | KxxxMod
| 50000         | Första objekt-id som reserverats i OP                                                 | 50000
| 50100           | Sista objekt-id som reserverats i OP                                                  | 50100
| NAB              | Det prefix som reserverats (använd NAB för PTE)                                       | NAB
| 512a0171-f09d-4159-9650-d759faa67a09        | Ett nytt GUID för Test-appen                                                          | 0e0b2636-8d0f-4a70-8d47-1826074cee6b
| e0de38f7-1279-4251-8b71-6b04a04ec0d1           | Ett nytt GUID för Huvud-appen                                                         | 0c41399c-41df-4ec2-ad12-4dee06c4337c 
| [NAB_WI_ASSIGNED_TO]      | Den användare som ska få pipeline-buggar (viktigt att format är exakt enligt exempel) | Test Testsson <test.testsson@nabsolutions.se>
| [NAB_WI_TST_ASSIGNEDTO]   | Den användare som ska få pipeline-tasks  (viktigt att format är exakt enligt exempel) | Test Testsson <test.testsson@nabsolutions.se>

7. Ladda om VSCode via "Developer: Reload Window" (eller starta om VSCode). Detta för att ändringarna ovan ska läsas in.
1. Döp om .code-workspace-filen så att det motsvarar din nya app
1. Radera denna punktlistan i den här filen (README.md) i ditt nya repo
1. Öppna .code-workspace-filen i ditt nya repo
1. Skapa en .vscode\launch.json, hämta innehåll från OP för vald utvecklingsdatabas eller från container
1. Ladda ner Symbols för App
1. Gå igenom alla .al-filer och sätt unikt Id på alla objekt för App (välj automatiskt utifrån inställningarna i app.json mha av Intellisense)
1. Lös eventuella problem så att App går att kompilera
1. När ovan är gjort. COMMIT + PUSH
1. Kör vidare!


# Workspace folder för NAB KMILBAI Modifications

## NR-serie
50000 - 50100

## Objekt
Alla nya objekt samt kontroller i extension-objekt ska prefixas med NAB

