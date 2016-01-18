Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:35716 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597AbcARQxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2016 11:53:52 -0500
Date: Mon, 18 Jan 2016 17:53:03 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"linux-arm-kernel\@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-mips\@linux-mips.org" <linux-mips@linux-mips.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	linux-wireless@vger.kernel.org
Subject: ssb: Set linux-wireless as MAINTAINERS list
Message-ID: <20160118175303.19164539@wiggum> (sfid-20160118_175414_635941_E1A521FB)
In-Reply-To: <87y4bn5m4q.fsf@kamboji.qca.qualcomm.com>
References: <8128014.DbbgBtKY3z@wuerfel>
 <8760ywd5fe.fsf@kamboji.qca.qualcomm.com>
 <4037550.DMaVTE01Aq@wuerfel>
 <87bn8l7miw.fsf@kamboji.qca.qualcomm.com>
 <CACna6ryvDFHqwJ3ExURcyFT2ZaT9fS9v36wCnJfze5BLnE88og@mail.gmail.com>
 <87y4bn5m4q.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/W9FSX.bWK4dE3/AP7ZDba/G"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/W9FSX.bWK4dE3/AP7ZDba/G
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

ssb patches go through the linux-wireless tree.
Set the list to linux-wireless, so linux-wireless patchwork can catch the p=
atches.

Signed-off-by: Michael Buesch <m@bues.ch>

---

Index: linux/MAINTAINERS
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -10036,7 +10036,7 @@ F:	drivers/net/ethernet/natsemi/sonic.*
=20
 SONICS SILICON BACKPLANE DRIVER (SSB)
 M:	Michael Buesch <m@bues.ch>
-L:	netdev@vger.kernel.org
+L:	linux-wireless@vger.kernel.org
 S:	Maintained
 F:	drivers/ssb/
 F:	include/linux/ssb/


--=20
Michael

--Sig_/W9FSX.bWK4dE3/AP7ZDba/G
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWnRhvAAoJEPUyvh2QjYsOPYMP+wVU8Zgs2cPYZAxBjr/7/ZKX
7/S5jsyNck3aQRMfwW9l2od0ZC1zwkSCRZLNzwtbWlXTdsc5ti/5xY8b1BG8AMai
jvuwrpQFJTP3pDBfITcfHy1TOCRAp9WlZYftbz5AsnweHe3c9pGZVSEi5kdRXQrt
5UlcViNaQ2Xj6mcbvSHGL78lvspgUGikjztlKq2FDfeYn++iyr71x9cSBfbNkB3v
ZKa3bFPAaNR2/0gY9xVKE6pcHBroGUB6RxuLoXXp2rCX6XpTtI6hq0ITFUcyEwuQ
MQqFqh67iB3prN6hRHX+dJl2VsuruyAZpgPCOVDysF0xThHdEZFDTlAgPmpdnju9
wRb6hKiQkjvjzYAHAxo6YepAOIXHEhaPqnPs8u2hxVCZk8mM4dOMGp5ZNdsmQi8q
F/Dd9MbYYDpgy/1y65dCPTz0KRq0UzzUdu85MSOk/SQ3ZxA5vlYs8t8IKeIM7x+A
9QDwtlcNjnqzJ8qgd/rweC/Pty8m3Tg6wzIXYeDs8lty7VygC2MZ5cggCUHMdap1
urBEE09Vz9aK8/q+SvMGis//flrjcodlhrmQPZkJ5x5I+pACf0n/t5JMrRWkw49n
EF1djRh9+YHd0KdsuYU336RgW00GV2FWUepPGeKVuQH9Z+cGKriakXeTDkpsnm+w
Nf2mv0KxPsLC53wdZlyN
=OMM2
-----END PGP SIGNATURE-----

--Sig_/W9FSX.bWK4dE3/AP7ZDba/G--
