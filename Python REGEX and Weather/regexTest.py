import unittest
from regex import RE1, RE2, RE3, RE4, RE5

class regexTest(unittest.TestCase):

    def setUp(self):
        self.re1 = RE1()
        self.re2 = RE2()
        self.re3 = RE3()
        self.re4 = RE4()
        self.re5 = RE5()

    # Test RE1.

    def test1empty(self):
        str = ''
        m = self.re1.match(str)
        self.assertFalse(m)
        s = self.re1.search(str)
        self.assertFalse(s)

    def test1ba(self):
        str = 'ba'
        m = self.re1.match(str)
        self.assertFalse(m)
        s = self.re1.search(str)
        self.assertFalse(s)

    def test1b(self):
        str = 'b'
        m = self.re1.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        s = self.re1.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)

    def test1bb(self):
        str = 'bb'
        m = self.re1.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        s = self.re1.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)

    def test1bmany(self):
        str = 'bbbbbbbbbbbbbb'
        m = self.re1.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        s = self.re1.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)

    # Test RE2.

    def test2empty(self):
        str = ''
        m = self.re2.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        s = self.re2.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)

    def test2b(self):
        str = '     '
        m = self.re2.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        s = self.re2.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)

    def test2bcmt(self):
        str = '  # a helpful comment'
        m = self.re2.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        s = self.re2.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)

    def test2cmt(self):
        str = '# a helpful comment'
        m = self.re2.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        s = self.re2.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)

    def test2notOK(self):
        str = 'x = 5 # a helpful comment'
        m = self.re2.match(str)
        self.assertFalse(m)
        s = self.re2.search(str)
        self.assertFalse(s)

    # Test RE3.

    def test3empty(self):
        str = ''
        m = self.re3.match(str)
        self.assertFalse(m)
        s = self.re3.search(str)
        self.assertFalse(s)

    def test3OK(self):
        str = '(416)967-1111'
        m = self.re3.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), '416')
        self.assertEqual(m.group(2), '967')
        self.assertEqual(m.group(3), '1111')
        s = self.re3.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), '416')
        self.assertEqual(s.group(2), '967')
        self.assertEqual(s.group(3), '1111')

    def test3OKblank(self):
        str = '(416) 967-1111'
        m = self.re3.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), '416')
        self.assertEqual(m.group(2), '967')
        self.assertEqual(m.group(3), '1111')
        s = self.re3.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), '416')
        self.assertEqual(s.group(2), '967')
        self.assertEqual(s.group(3), '1111')

    def test3OKembedded(self):
        str = 'My phone number is (416)967-1111.'
        m = self.re3.match(str)
        self.assertFalse(m)
        s = self.re3.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), '(416)967-1111')
        self.assertEqual(s.group(1), '416')
        self.assertEqual(s.group(2), '967')
        self.assertEqual(s.group(3), '1111')

    # Test RE4.

    def test4empty(self):
        str = ''
        m = self.re4.match(str)
        self.assertFalse(m)
        s = self.re4.search(str)
        self.assertFalse(s)

    def test4usg(self):
        str = 'Ulysses S. Grant'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), 'Ulysses')
        self.assertEqual(m.group(2), 'S')
        self.assertEqual(m.group(3), 'Grant')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), 'Ulysses')
        self.assertEqual(s.group(2), 'S')
        self.assertEqual(s.group(3), 'Grant')

    def test4rzm(self):
        str = 'Ronald Z. MacDonald'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), 'Ronald')
        self.assertEqual(m.group(2), 'Z')
        self.assertEqual(m.group(3), 'MacDonald')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), 'Ronald')
        self.assertEqual(s.group(2), 'Z')
        self.assertEqual(s.group(3), 'MacDonald')

    def test4sym(self):
        str = 'Scrooge Y. McDuck'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), 'Scrooge')
        self.assertEqual(m.group(2), 'Y')
        self.assertEqual(m.group(3), 'McDuck')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), 'Scrooge')
        self.assertEqual(s.group(2), 'Y')
        self.assertEqual(s.group(3), 'McDuck')

    def test4ymm(self):
        str = 'Yaris M. MackParis'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), 'Yaris M. Mack')
        self.assertEqual(m.group(1), 'Yaris')
        self.assertEqual(m.group(2), 'M')
        self.assertEqual(m.group(3), 'Mack')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), 'Yaris M. Mack')
        self.assertEqual(s.group(1), 'Yaris')
        self.assertEqual(s.group(2), 'M')
        self.assertEqual(s.group(3), 'Mack')

    def test4jam(self):
        str = 'John A. Macdonald'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), 'John')
        self.assertEqual(m.group(2), 'A')
        self.assertEqual(m.group(3), 'Macdonald')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), 'John')
        self.assertEqual(s.group(2), 'A')
        self.assertEqual(s.group(3), 'Macdonald')

    def test4embeddedrsm(self):
        str = 'My name is Robert      S.  McNamara.'
        m = self.re4.match(str)
        self.assertFalse(m)
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), 'Robert      S.  McNamara')
        self.assertEqual(s.group(1), 'Robert')
        self.assertEqual(s.group(2), 'S')
        self.assertEqual(s.group(3), 'McNamara')

    def test4hst(self):
        str = 'Harry S Truman'
        m = self.re4.match(str)
        self.assertFalse(m)
        s = self.re4.search(str)
        self.assertFalse(s)

    def test4mxb(self):
        str = 'McGeorge X. Bundy'
        m = self.re4.match(str)
        self.assertFalse(m)
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), 'George X. Bundy')
        self.assertEqual(s.group(1), 'George')
        self.assertEqual(s.group(2), 'X')
        self.assertEqual(s.group(3), 'Bundy')

    def test4slo(self):
        str = 'Sandra L. O'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), 'Sandra')
        self.assertEqual(m.group(2), 'L')
        self.assertEqual(m.group(3), 'O')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), 'Sandra')
        self.assertEqual(s.group(2), 'L')
        self.assertEqual(s.group(3), 'O')

    def test4obrian(self):
        str = 'Danny N. OhBrian'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), 'Danny')
        self.assertEqual(m.group(2), 'N')
        self.assertEqual(m.group(3), 'OhBrian')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), 'Danny')
        self.assertEqual(s.group(2), 'N')
        self.assertEqual(s.group(3), 'OhBrian')

    def test4maggie(self):
        str = 'Margaret P. SraThatcher'
        m = self.re4.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group(1), 'Margaret')
        self.assertEqual(m.group(2), 'P')
        self.assertEqual(m.group(3), 'SraThatcher')
        s = self.re4.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group(1), 'Margaret')
        self.assertEqual(s.group(2), 'P')
        self.assertEqual(s.group(3), 'SraThatcher')

    # Test RE5.

    def test5jim(self):
        str = 'Clarke	Jim	987654321	AS   HBSC 	INVIT	4	UC   	ASMAJ1688 	1.04	20061	j.n.clarke@utoronto.ca                            	CSC408H1F 	20069'
        m = self.re5.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group('family'), 'Clarke')
        self.assertEqual(m.group('given'), 'Jim')
        self.assertEqual(m.group('email'), 'j.n.clarke@utoronto.ca')
        s = self.re5.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group('family'), 'Clarke')
        self.assertEqual(s.group('given'), 'Jim')
        self.assertEqual(s.group('email'), 'j.n.clarke@utoronto.ca')

    def test5michelle(self):
        str = 'Craig	Michelle	887654321	AS   HBSCU	INVIT	4	WDW  	ASSPE1039 	2.98	20061	michelle25@yahoo.il                              	CSC454H1F 	20069'
        m = self.re5.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group('family'), 'Craig')
        self.assertEqual(m.group('given'), 'Michelle')
        self.assertEqual(m.group('email'), 'michelle25@yahoo.il')
        s = self.re5.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group('family'), 'Craig')
        self.assertEqual(s.group('given'), 'Michelle')
        self.assertEqual(s.group('email'), 'michelle25@yahoo.il')

    def test5michael(self):
        str = 'Szamosi	Michael	787654321	AS   HBSC 	INVIT	4	VIC  	ASSPE1039 	4.11	20031	learned_hand@supremes.gov                             	CSC407H1S 	20071'
        m = self.re5.match(str)
        self.assert_(m)
        self.assertEqual(m.group(0), str)
        self.assertEqual(m.group('family'), 'Szamosi')
        self.assertEqual(m.group('given'), 'Michael')
        self.assertEqual(m.group('email'), 'learned_hand@supremes.gov')
        s = self.re5.search(str)
        self.assert_(s)
        self.assertEqual(s.group(0), str)
        self.assertEqual(s.group('family'), 'Szamosi')
        self.assertEqual(s.group('given'), 'Michael')
        self.assertEqual(s.group('email'), 'learned_hand@supremes.gov')

if __name__ == '__main__':
    unittest.main()
