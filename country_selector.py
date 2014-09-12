
from PyQt5 import QtWidgets

from ui_country_selector import Ui_CountrySelector

from countrycode import countrycode
from countries import countries

class CountrySelector(QtWidgets.QDialog):
    def __init__(self, parent=None):
        super(CountrySelector, self).__init__(parent)
        ui = Ui_CountrySelector()
        ui.setupUi(self)
        self.ui = ui

        self.codes = sorted(zip(*countries)[0])
        
        index = self.codes.index("NZ")
 
        ui.cmbCode.addItems(self.codes)
        ui.cmbCode.setCurrentIndex(index)
        
        self._on_selection(index)
        ui.cmbCode.currentIndexChanged.connect(self._on_selection)

        self.adjustSize()

    def _on_selection(self, index):
        self.ui.lblCountry.setText(countrycode(self.codes[index], origin='iso2c'))
        self.ui.lblCode3.setText(countrycode(self.codes[index], origin='iso2c', target='iso3c'))
