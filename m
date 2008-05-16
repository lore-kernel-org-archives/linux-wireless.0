Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYEPIU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 04:20:59 -0400
Subject: Re: Association broken with wpa_supplicant
From: Johannes Berg <johannes@sipsolutions.net>
To: ronald645@gmail.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <482D384C.30807@gmail.com> (sfid-20080516_093139_083975_56251B49)
References: <482D384C.30807@gmail.com>
	 (sfid-20080516_093139_083975_56251B49)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uEPai+SvFGwCjw2s4KDl"
Date: Fri, 16 May 2008 10:19:35 +0200
Message-Id: <1210925975.4000.6.camel@johannes.berg> (sfid-20080516_102108_984113_48D3A380)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uEPai+SvFGwCjw2s4KDl
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-05-16 at 09:31 +0200, Ronald wrote:
> I'm not using the latest wireless (2.6.25) but I also have trouble using=20
> wpa_supplicant (same error as you). After *a lot* of trying, I figured=20
> this out, to associate I do this:

> ap_scan=3D2

> ap_scan=3D1

> Trying to associate directly with only wpa_supplicant.conf won't work,=20
> *only* after I used wpa_supplicant.conf.2. Furthermore, I never made a=20
> bugreport as I thought that it would be an error in wpa_supplicant...
>=20
> I hope this helps you in any way =3D)

This is probably the same bug Michael reported already. If it hadn't
been, I most likely would have ignored your email due to lack of kernel
logs and information :)

johannes

--=-uEPai+SvFGwCjw2s4KDl
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC1DlqVg1VMiehFYAQKFRw//XToHXn9C/p0yoXNcnJpfDMCkUyqi7/Sb
Fg8GIKg+zDdouYGFwt06qXz/lk17t2HkweEtuJZjmyp0GMqFBhXTHCaKvRRdeNfB
YO0qUmdsAMGkjGfJM7PT+NQ8aM9FadJijKupPHJ3j79NXccUr20iigZszQ9hg9+x
z64ZZnl+p6CFveBoOkdLnAF7kf68ReAWGrodkXgKWogV5eHalzr9f5saqgdeh7cc
wsjzsgdjB7wQ6+MtzSL7MRtvRoCZEbeUJTYrl6NJdQR82jkswvpMIfS0AuTf9T0H
nD6I7EEtA4MYdZnQjAA4fM+qsqfHDZXhrCYoVPAupDWQiUlikn71ARG2HFWRortt
VyVMtJaPPPa1dnBZaAHiqRTpH25W48XiGJ0utMk5AqL/tY2p7hkLTGofKCpSLICU
MYNZX1Wk3YjS/r5LarGtCEj3GH9FPhdtaM31T9Q7lFbuGjTiGQ8TGCLc7v/fpH1X
nGXTioLL1YnZ+q3dAKBUbZprld9Uh19EVk+nADxtOqGyfKJn53iQeXEqABVWWi5k
mxrkYYo8L7CkU4BqEMndW7EzbzW7WghVStua6iuJIkTA6FFtiwxF38LaV6+Dd7f5
MRJJ1p+5BUVbR++aZJLdMNfIhjS4O1fpzzT5WNnazybOKYWSo55HPhxAcAAb03SY
2QrJz29o93A=
=vugM
-----END PGP SIGNATURE-----

--=-uEPai+SvFGwCjw2s4KDl--

