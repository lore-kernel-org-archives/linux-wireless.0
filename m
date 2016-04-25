Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56575 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174AbcDYNKY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2016 09:10:24 -0400
From: Maximilian Engelhardt <engelhardt@perisens.de>
To: seth.forshee@canonical.com
Cc: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	maxi@daemonizer.de
Subject: wireless-regdb: Update regulatory references for Germany (DE)
Date: Mon, 25 Apr 2016 15:09:48 +0200
Message-ID: <1627007.Hvd6lR1COR@perisens15> (sfid-20160425_151039_540704_97CF7095)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1816405.RaMNMoAWtq"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart1816405.RaMNMoAWtq
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

Hi,

The "Frequenznutzungsplan" is not really a good reference as it's a lis=
t
of all frequency allocations and does only list basic information about=

the allocation. This patch changes the comments to reference directly
the corresponding documents which provide all information about the
allocation.

This patch does only change comments, all entries have been left
unchanged. However the entries have been verified to match the mentione=
d
documents.

This patch is based on my last path that adds the short range devices b=
and for=20
Germany.

Thanks,
Maxi


Signed-off-by: Maximilian Engelhardt <engelhardt@perisens.de>
=2D--
 db.txt | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/db.txt b/db.txt
index 38a9340..7870dd6 100644
=2D-- a/db.txt
+++ b/db.txt
@@ -308,33 +308,41 @@ country CZ: DFS-ETSI
 =09# 60 GHz band channels 1-4, ref: Etsi En 302 567
 =09(57000 - 66000 @ 2160), (40)
=20
=2D# Data from "Frequenznutzungsplan" (as published in April 2008), downl=
oaded from
=2D# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38448/public=
ationFile/2659/Frequenznutzungsplan2008_Id17448pdf.pdf
=2D# For the 5GHz range also see
=2D# http://www.bundesnetzagentur.de/cae/servlet/contentblob/38216/public=
ationFile/6579/WLAN5GHzVfg7_2010_28042010pdf.pdf
=2D# The values have been reduced by a factor of 2 (3db) for non TPC devi=
ces
=2D# (in other words: devices with TPC can use twice the tx power of this=
 table).
=2D# Note that the docs do not require TPC for 5150--5250; the reduction =
to
=2D# 100mW thus is not strictly required -- however the conservative 100m=
W
+# Allocation for the 2.4 GHz band (Vfg 10 / 2013, Allgemeinzuteilung v=
on
+# Frequenzen f=C3=BCr die Nutzung in lokalen Netzwerken; Wireless Loca=
l Area
+# Networks (WLAN-Funkanwendungen).
+# https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete=
/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteil=
ungen/2013_10_WLAN_2,4GHz_pdf.pdf
+#
+# Allocation for the 5 GHz band (Vfg. 7 / 2010, Allgemeinzuteilung von=

+# Frequenzen in den Bereichen 5150 MHz - 5350 MHz und 5470 MHz - 5725 =
MHz f=C3=BCr
+# Funkanwendungen zur breitbandigen Daten=C3=BCbertragung, WAS/WLAN (=E2=
=80=9EWireless
+# Access Systems including Wireless Local Area Networks=E2=80=9C).
+# https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete=
/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteil=
ungen/2010_07_WLAN_5GHz_pdf.pdf
+# The values for the 5 GHz have been reduced by a factor of 2 (3db) fo=
r non TPC
+# devices (in other words: devices with TPC can use twice the tx power=
 of this
+# table). Note that the docs do not require TPC for 5150--5250; the re=
duction
+# to 100mW thus is not strictly required -- however the conservative 1=
00mW
 # limit is used here as the non-interference with radar and satellite
 # apps relies on the attenuation by the building walls only in the
 # absence of DFS; the neighbour countries have 100mW limit here as wel=
l.
+#
 # The ETSI EN 300 440-1 standard for short range devices in the 5 GHz =
band has
 # been implemented in Germany:
 # https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete=
/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteil=
ungen/2014_69_SRD_pdf.pdf
+#
+# Allocation for the 60 GHz band (Allgemeinzuteilung von Frequenzen im=

+# Bereich 57 GHz - 66 GHz f=C3=BCr Funkanwendungen f=C3=BCr weitbandig=
e
+# Daten=C3=BCbertragungssysteme; =E2=80=9EMultiple Gigabit WAS/RLAN Sy=
stems (MGWS)=E2=80=9C).
+# https://www.bundesnetzagentur.de/SharedDocs/Downloads/DE/Sachgebiete=
/Telekommunikation/Unternehmen_Institutionen/Frequenzen/Allgemeinzuteil=
ungen/2011_08_MGWS_pdf.pdf
=20
 country DE: DFS-ETSI
=2D=09# entries 279004 and 280006
 =09(2400 - 2483.5 @ 40), (100 mW)
=2D=09# entry 303005
 =09(5150 - 5250 @ 80), (100 mW), NO-OUTDOOR, AUTO-BW
=2D=09# entries 304002 and 305002
 =09(5250 - 5350 @ 80), (100 mW), NO-OUTDOOR, DFS, AUTO-BW
=2D=09# entries 308002, 309001 and 310003
 =09(5470 - 5725 @ 160), (500 mW), DFS
 =09# short range devices (ETSI EN 300 440-1)
 =09(5725 - 5875 @ 80), (25 mW)
=2D=09# 60 GHz band channels 1-4, ref: Etsi En 302 567
+=09# 60 GHz band channels 1-4 (ETSI EN 302 567)
 =09(57000 - 66000 @ 2160), (40)
=20
 country DK: DFS-ETSI
=2D-=20
Maximilian Engelhardt
Dipl.-Ing. (Univ.)
=20
perisens GmbH
Lichtenbergstra=C3=9Fe 8
85748 Garching bei M=C3=BCnchen

tel:    +49 89 2155203-10
fax:    +49 89 2155203-19
web:    http://www.perisens.de/
_____________

perisens GmbH
Gesch=C3=A4ftsf=C3=BChrer: Dr. Florian Pfeiffer=20
Sitz und Registergericht: M=C3=BCnchen HRB 181857
USt-ID: DE-267481419

--nextPart1816405.RaMNMoAWtq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXHhcgAAoJECiijTBlkGWF1kwP/jzzcdpA2ecMsYz9WEGdaYd9
2GgAuxzBRRv1aH/5SRGwAJj5GiBBeuv0f5muWYkzQ4GxvdAghJdh6oNTuF39iEI0
K46tDI3rLEFdqdRrA/Yc6tDMRgQn04RNoQUTHrC0aYXrIg6X4T9Htc+Gm8od6dBr
FaDlZ+kzLGCQi7F5OApW85JwbMpMJU08NarabYMh+OvM3+7v+h33HbahkqMd39YE
PkfZF/9Ews9JW9DWwjAESSMZZESHVyiFJqq7/BsbspzodhIpaCgMgEZwN3z+W6jn
ne26LHRotJ+yNAgSP5tOMISqgQw1aqZdbT8uxiZs5SzmWGl7+9LSAdJw3jhFos8T
zUgYjCm8ZUG1zONAZ8btnA6kTXybVFhrDAk6BheBUYkXBEU4OfcTzqbHFcL1UI/y
vzlYeZu4tK2O3xzdc93N1fAHe3Ocg9oPqnRR4dRTouJ6h86usjC0BOO2cny6I+VJ
s0AQ4wPv+3/wCxaKaJh9QCuKbuW1gQEjEWJstt2NrAHNWjmbbVHx3PgXGibCBxkL
A0XtSUB468I6j3KC3ILM+vkvl8Oy9WZxz3RQs8HD1wSMX+Uuxdh5VEJ5Z6V/1Sg5
Jdqv7QoI88TsirB03Fbae8Hl50bfvd9VEzuE9M9xqWhq+1kCekdVWIqK5OkPq96S
14Qqkx9hxfsriSRfXQQ6
=mSPE
-----END PGP SIGNATURE-----

--nextPart1816405.RaMNMoAWtq--

