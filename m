Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbYLJAR0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 19:17:26 -0500
Subject: Re: [RFC/RFT] rtl8187: Use usb anchor facilities to manage urbs
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
In-Reply-To: <493F0B11.9030503@yahoo.co.uk> (sfid-20081210_011314_137479_CE755EA0)
References: <493d9c06.XJn1gNkms3JqErgr%Larry.Finger@lwfinger.net>
	 <493DEF32.5070403@yahoo.co.uk> <493E8B27.3000404@lwfinger.net>
	 <493F0B11.9030503@yahoo.co.uk> (sfid-20081210_011314_137479_CE755EA0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NdG7CCbumZJmuYcAlC+5"
Date: Wed, 10 Dec 2008 01:16:49 +0100
Message-Id: <1228868209.1029.30.camel@johannes.berg> (sfid-20081210_011729_653981_0FBB579F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NdG7CCbumZJmuYcAlC+5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-12-10 at 00:19 +0000, Hin-Tak Leung wrote:
> Larry Finger wrote:
> > Hin-Tak Leung wrote:
> >> Just built it and using it right now.
> >=20
> > Does this patch have any effect on bugzilla entry
> > 11887(http://bugzilla.kernel.org/show_bug.cgi?id=3D11887)?
>=20
> No, still requires manually unloading. (i.e. I removed my current=20
> SUSPEND_MODULES pm defines, and it hangs on suspend). Need to look elsewh=
ere
> or fill in some suspend()/resume() routines, I guess.

The same happens for ar9170 right now, I was putting the blame on the
firmware loading but I'm not entirely sure. If you find anything here
I'd be interested, no time right now try finding the bug myself
unfortunately.

johannes

--=-NdG7CCbumZJmuYcAlC+5
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPwptAAoJEKVg1VMiehFYjO0P/03yS0d4FPHOSnfj5ZMDKxef
KTr2S61VsUeHr6Sgops7iGtqsFzn3vyxo5c7Ihtrgv1UT4WlKSnbiUwa/RPRH0ci
jZA97m36CPEzVvuk7jhbNnwtdfQ5rlI9OTTCcOoHuUTo5KVFjVqoDRKd8l48oR/S
PjTO97+1FErtovwBw7JTF3pP6Vz7JCxfcHvVGKSSMNWhZZ+5WTDCpE4QhLGvUjOA
AlZCcr/fdHgQ2e3OE0uA6c8T6QnJt210mod9kDlayDYM3w33rhysQYvKh2CWeLmX
iRzhTQ4lf7KHwz0owtzDRS27wgjOIGYZjA/sJPTppy1POCFsovMPAjgomYsAJMga
zz/oyPR88Nyt1Ht4dd9sLQuXigZ5l5lcWriyEszKIuKSoFKo0KnCT529RCCdgHLU
1yAAKFUxMkAugv+YdGmh3O9MSxjVpErc8QKAL3NAfVlgT3uMg/zrAL7FfgJps9Cr
88X5ki8jILqSuGDG7uMMb6SSXEzOqrNykYiTFDnoT23XXOVDFCplEc0/ywSPnjoX
wkzGYxCQrwZALwSLKadAZvxWlyfq7C1drl2ZrV/xzhJMbJ7VTpr0oQoNJJP7mWSg
6Hv2kMq3S16bBnJodsEm3/KHtllaEZFf2M5v76rQV5aWOrt3Hw+qQgZu/rlsTOjE
/dAIq1ejPiT/ILhAFJFa
=EzOl
-----END PGP SIGNATURE-----

--=-NdG7CCbumZJmuYcAlC+5--

