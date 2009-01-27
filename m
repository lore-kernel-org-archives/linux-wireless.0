Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51091 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZA0JPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 04:15:09 -0500
Subject: iwlwifi warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I9YZ/PEwJ/INciIrRsCu"
Date: Tue, 27 Jan 2009 10:15:05 +0100
Message-Id: <1233047705.4012.12.camel@johannes.local> (sfid-20090127_101516_218667_B5DDF1FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I9YZ/PEwJ/INciIrRsCu
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
=E2=80=98iwl3945_pci_resume=E2=80=99:
drivers/net/wireless/iwlwifi/iwl3945-base.c:6319: warning: ignoring
return value of =E2=80=98pci_enable_device=E2=80=99, declared with attribut=
e
warn_unused_result

drivers/net/wireless/iwlwifi/iwl-agn.c: In function =E2=80=98iwl_pci_resume=
=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-agn.c:4128: warning: ignoring return
value of =E2=80=98pci_enable_device=E2=80=99, declared with attribute warn_=
unused_result

drivers/net/wireless/iwlwifi/iwl-tx.c: In function =E2=80=98iwl_tx_queue_al=
loc=E2=80=99:
drivers/net/wireless/iwlwifi/iwl-tx.c:302: warning: format =E2=80=98%zd=E2=
=80=99 expects
type =E2=80=98signed size_t=E2=80=99, but argument 4 has type =E2=80=98u32=
=E2=80=99

johannes

--=-I9YZ/PEwJ/INciIrRsCu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJftCWAAoJEKVg1VMiehFYVYUP/2Egk5vpRe2c8AIhJIzqjtTp
QvO0NJpOsZlkBI/pr1hxmQDBTiz+T1PuF5yR5yzRBxdQa+MXbtMdsMCUfal4X6kK
SNWksPEfV1EGIBd+YZBz93+fMUCU8RuKbGGaednvG8hdyETK0/vUyvND1xnaRsMx
AK7kJoF1aXwfWT7qiHZ/Hgh+HQJAIfHfpgH5PApWIqIWc5mC3zGfkru1FNW5a/2q
+4V0AE6YuQIP66JvdtTen6qKVi7MCcin934ZyQ1t6/JHV3zaWbARIhotwXzDHimH
RBWQWtRB8PO3ybdBbNqm5ZZuzSekj7B6CbIZ5c2pEwG4Ir+okizGQcK56M5WW9HD
tw30of1pT4Prt0S4/wLwja1o91OagBMO/XgjM2g7JHYr8BPRI/E09kpf3FczE66f
HV+nOPV67SZeoLtediKovU9PWIryvFVT1i471xmXSd/dnCikDagZDj9UqTDzmONP
2jdzcujAr6eHZtvRMOGqBUryoZlLLyGKUII3Um9H6EeEAkUTvYRVc1RoxgBYT9t+
XifsrMW6ziTfr3x18i5Fscki3EHASpibXVdoSc9rJpWWAQv3oDEdYeWfRK0iS9Xu
W46hkh728WZcHJAPj8v2kFDRd9ThiIBHK/wX13UZIlOMhw7qmOk5hBEVa8fbc0Me
7qH2UYiWB09UVvZMoc/z
=1C6Y
-----END PGP SIGNATURE-----

--=-I9YZ/PEwJ/INciIrRsCu--

