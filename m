Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445AbXKOSZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 13:25:32 -0500
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
From: Johannes Berg <johannes@sipsolutions.net>
To: Elimar Riesebieter <riesebie@lxtec.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20071115182144.GA3199@samweis.home.lxtec.de>
References: <20071024120739.GA4897@aragorn.home.lxtec.de>
	 <20071024124109.GA9442@frodo.home.lxtec.de>
	 <20071104032006.GG9695@localdomain>
	 <20071113220235.GB9008@frodo.home.lxtec.de>
	 <1195053964.4091.20.camel@johannes.berg>
	 <20071114193340.GA14921@frodo.home.lxtec.de>
	 <1195145325.13846.70.camel@johannes.berg>
	 <20071115182144.GA3199@samweis.home.lxtec.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CNbITKW4r6O8huT+Hpxi"
Date: Thu, 15 Nov 2007 19:26:52 +0100
Message-Id: <1195151212.8147.10.camel@johannes.berg> (sfid-20071115_182537_040211_473706F5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CNbITKW4r6O8huT+Hpxi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> Nov 15 18:51:31 samweis kernel: NIP [c02b3060] rfkill_register+0x6c/0x12c
> Nov 15 18:51:31 samweis kernel: LR [c02b302c] rfkill_register+0x38/0x12c
> Nov 15 18:51:31 samweis kernel: Call Trace:
> Nov 15 18:51:31 samweis kernel: [c7517d50] [c02b302c] rfkill_register+0x3=
8/0x12c (unreliable)

That was fixed post -rc2.

johannes

--=-CNbITKW4r6O8huT+Hpxi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzyPa6Vg1VMiehFYAQIMVxAApT+YLLWFyRmbHHGK6b/fQ3SVaWmolXlO
Z6R8GsxTsfBrXAogQ39NdiWbnNyCt0bwJxPA0IBUQwN8aze45Zvt40NUOPp+6R/e
uZ/m8QpLfAZmTOjRz8+hFBCtkrB1NTJufVYP1WhKjPgYXFuF57nzuBzRetAr6io7
xxA78uM6+Pr09U+Hdeb7NKIW28C3C0D8epNeOHMWXdl4y42LCUnVK0x83w1A4Ozg
0qxhMVI5JB6DEftSLzLGluCfSuk/cDcgQBx9qLcUqtXY73c1JRdrcHCWbfJk/Tk4
DvhqVTgBKwXlZag5BveJzeBVmSwHrLlyLBjvEQ2zlF0GtkasVt0IK3rcI4+laahL
rZkSQekvPunPjFXlS6D10vh3C9JbTA6cHn0TtZNO2KPHPHS9++V3IlsGu3KaqOJo
uuwJtcorkHxCoMZjn3/q6uBTnkMvUS/JRS5Tva3ocKI6RCMV/hlDR8h3RCNDWT1L
1MiRAxFHD/+6E+eUk+BCyTJOl2IWlct+vHhfilltxhjqnoez5g42E7fOFXpI1Fsr
3mYwgn7J0AridWJVGMXn1lOKL+RizHVlouey0F7eZDvy6hliPIrUE6HPJiMyshcF
cuz72vvrk5g6SHpKNRExuC1YDLt7bxMWpTMGlUXyfrcdW0D7mwceJ6rUmGDuF8mA
/07uR5lM4AQ=
=x5kY
-----END PGP SIGNATURE-----

--=-CNbITKW4r6O8huT+Hpxi--

