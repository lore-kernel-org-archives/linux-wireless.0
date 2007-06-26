Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47932 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbXF0Jic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2007 05:38:32 -0400
Subject: libertas warnings on ppc64
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o69xgn/Lf2t/isBycgGl"
Date: Tue, 26 Jun 2007 17:00:19 +0200
Message-Id: <1182870019.3703.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o69xgn/Lf2t/isBycgGl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

drivers/net/wireless/libertas/debugfs.c: In function
=E2=80=98libertas_getscantable=E2=80=99:
drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98%08llx=
=E2=80=99
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4 has t=
ype =E2=80=98u64=E2=80=99
drivers/net/wireless/libertas/debugfs.c:85: warning: format =E2=80=98%08llx=
=E2=80=99
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4 has t=
ype =E2=80=98u64=E2=80=99

Maybe these were addressed by the current pull request? Thought I'd let
you know in any case.

johannes

--=-o69xgn/Lf2t/isBycgGl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGgSoC/ETPhpq3jKURAr/aAJ9GABOTlCLqjP0B/JnBMftpbsb3GQCfXrdA
qGxnH0c1PHAjEWKJvU7s5Nw=
=EQzR
-----END PGP SIGNATURE-----

--=-o69xgn/Lf2t/isBycgGl--

