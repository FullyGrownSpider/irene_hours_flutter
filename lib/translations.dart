Map<Words, String> language = {};

void dutch(){
  language[Words.companies] = 'Bedrijven';
  language[Words.actions] = 'De actie';
  language[Words.dayExport] = 'Export alles';
  language[Words.companyExport] = 'Export bedrijf voor dagen';
  language[Words.afterwards] = 'Achteraf toevoegen';
  language[Words.editDay] = 'Achteraf dag editen';
  language[Words.defaultHTML] = 'HTML default export';
  language[Words.exportLocation] = 'Export folder kiezen';
  language[Words.askPath] = 'Path van folder invullen';
  language[Words.actionInput] = 'Voer soort actie in';
  language[Words.companyInput] = 'Voer bedrijf naam in';

  language[Words.start] = 'Start Timer';
  language[Words.stop] = 'Stop Timer';

  language[Words.startTime] = 'Van';
  language[Words.stopTime] = 'Tot';

  language[Words.submit] = 'Voeg toe';
  language[Words.ok] = 'Klaar';
  language[Words.cancel] = 'Cancel';
  language[Words.day] = 'Dag ⇨ ';

  language[Words.dayPickStart] = 'Export start';
  language[Words.dayPickEnd] = 'Export einde';

  language[Words.problem] = 'Probleem';
  language[Words.forgotSelect] = 'Je bent vergeten om een bedrijf of actie te kiezien.';

  language[Words.inputText] = 'Vul nieuwe text in';

  language[Words.selectedDay] = 'Geselecteerde dag';
  language[Words.save] = 'Sla op';

  language[Words.noPath] = 'Geen locatie om het file naar te exporteren';
  language[Words.noData] = 'Geen data om te exporteren';

  language[Words.tableTop] = """
<tr>
<td>Bedrijf</td>
<td>Soort activiteit</td>
<td>Start tijd</td>
<td>Eind tijd</td>
<td>Totale Tijd</td>
</tr>
""";
}

void english(){
  language[Words.companies] = 'Companies';
  language[Words.actions] = 'Action';
  language[Words.dayExport] = 'Export all';
  language[Words.companyExport] = 'Export company for days';
  language[Words.afterwards] = 'Add afterwards';
  language[Words.editDay] = 'Edit day afterwards';
  language[Words.defaultHTML] = 'HTML default export';
  language[Words.exportLocation] = 'Choose export folder';
  language[Words.askPath] = 'Fill in path';
  language[Words.actionInput] = 'Input action name';
  language[Words.companyInput] = 'Input company name';

  language[Words.start] = 'Start Timer';
  language[Words.stop] = 'Stop Timer';

  language[Words.startTime] = 'From';
  language[Words.stopTime] = 'To';

  language[Words.submit] = 'Add';
  language[Words.ok] = 'Done';
  language[Words.cancel] = 'Cancel';
  language[Words.day] = 'Day ⇨ ';

  language[Words.dayPickStart] = 'Export start';
  language[Words.dayPickEnd] = 'Export end';

  language[Words.problem] = 'Problem';
  language[Words.forgotSelect] = 'You forgot to choose a company or action.';

  language[Words.inputText] = 'Input new text';

  language[Words.selectedDay] = 'Selected day';
  language[Words.save] = 'Commit';

  language[Words.noPath] = 'No storage path found';
  language[Words.noData] = 'No data to export';

  language[Words.tableTop] = """
<tr>
<td>Company</td>
<td>Activity</td>
<td>Start Time</td>
<td>Ending Time</td>
<td>Total Time</td>
</tr>
""";
}

void pickLang(String lang){
  if (lang == 'en'){
    english();
  } else if (lang == 'nl'){
    dutch();
  }
}

Map<String, String> languageMap(){
  return {'🇬🇧 English-UK': 'en', '🇳🇱 Nederlands': 'nl'};
}

enum Words { noData, noPath, save, selectedDay, inputText, forgotSelect, problem, dayPickEnd,dayPickStart, day, cancel, ok, submit, stopTime, startTime, stop, start, actionInput, companyInput, askPath, exportLocation, defaultHTML, editDay, afterwards, companyExport, dayExport, actions, companies, tableTop}