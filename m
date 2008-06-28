Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.lateralplains.com ([203.208.66.137]:56519 "EHLO
	mx.lateralplains.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbYF1KYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 06:24:47 -0400
Received: from [10.0.1.13] (204.32.87.203.static.vic.chariot.net.au [203.87.32.204])
	by mx.lateralplains.com (Postfix) with ESMTP id 3B993E020E
	for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 19:53:29 +1000 (EST)
From: George Fong <george@lateralplains.com>
To: linux-wireless@vger.kernel.org
Subject: Problem making compat-wireless-2.6
Date: Sat, 28 Jun 2008 19:53:13 +1000
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1443848.DGIaC10mDH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200806281953.16371.george@lateralplains.com> (sfid-20080628_122452_479624_CDDA8643)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1443848.DGIaC10mDH
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi guys

Not sure if this is a bug but I have not been able to make the compat wirel=
ess=20
drivers.

I am running off Fedora 9 (x86_64) with kernel 2.6.25.6-55.fc9.x86_64. I am=
=20
interested in the iwl4965 driver.

Everything goes OK until we hit the compilation of part of the b43 driver.=
=20
This is what I get:

/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/r=
fkill.c:=20
In function =E2=80=98b43_rfkill_soft_toggle=E2=80=99:
/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/r=
fkill.c:91:=20
error: =E2=80=98RFKILL_STATE_UNBLOCKED=E2=80=99 undeclared (first use in th=
is function)
/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/r=
fkill.c:91:=20
error: (Each undeclared identifier is reported only once
/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/r=
fkill.c:91:=20
error: for each function it appears in.)
/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/r=
fkill.c:101:=20
error: =E2=80=98RFKILL_STATE_SOFT_BLOCKED=E2=80=99 undeclared (first use in=
 this function)
make[4]: ***=20
[/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43/=
rfkill.o]=20
Error 1
make[3]: ***=20
[/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless/b43]=
=20
Error 2
make[2]: ***=20
[/home/george/Download/compat-wireless-2008-06-28/drivers/net/wireless] Err=
or=20
2
make[1]: *** [_module_/home/george/Download/compat-wireless-2008-06-28] Err=
or=20
2
make[1]: Leaving directory `/usr/src/kernels/2.6.25.6-55.fc9.x86_64'
make: *** [modules] Error 2

It is entirely likely that I am doing something wrong but I don't know what.

Hope this is all OK to report.

Cheers
G,


=2D-=20
George Fong
Lateral Plains Pty Ltd
Tel: +61 3 53 302 880
=46ax: +61 3 53 302 881
Just remember, wherever you go .... there you are.

--nextPart1443848.DGIaC10mDH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhmCgwACgkQyT6GKA4fvlBDbACffU+0q7fdM6Mypdk2RnfaM/xL
chsAn06K/XQDxch34cj+eRTVqAuLnHtl
=p18M
-----END PGP SIGNATURE-----

--nextPart1443848.DGIaC10mDH--
