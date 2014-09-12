'''
Created on 9/09/2014

@author: glenn
'''

import sys
#from PyQt5 import Qt # use a hiddenimport instead
from PyQt5 import QtWidgets
from country_selector import CountrySelector

def main():
    app = QtWidgets.QApplication(sys.argv)
    
    dlg = CountrySelector()
    dlg.show()
    
    app.exec_()

if __name__ == '__main__':
    main()
