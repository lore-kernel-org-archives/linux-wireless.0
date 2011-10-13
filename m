Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from H144.C72.B0.tor.eicat.ca ([72.0.72.144]:62913 "EHLO
	marcos.anarcat.ath.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab1JMB5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 21:57:08 -0400
From: Antoine =?utf-8?Q?Beaupr=C3=A9?= <anarcat@koumbit.org>
To: Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: 645055@bugs.debian.org
Subject: Re: Bug#645055: realtek 8188CE ad-hoc mode not supported
In-Reply-To: <1318461858.4024.197.camel@deadeye>
References: <20111012052940.17383.59248.reportbug@localhost> <1318424918.4024.180.camel@deadeye> <87pqi2s0cg.fsf@marcos.anarcat.ath.cx> <20111012160135.GK3366@decadent.org.uk> <1318461858.4024.197.camel@deadeye>
Date: Wed, 12 Oct 2011 21:46:07 -0400
Message-ID: <87wrc9r7ds.fsf@marcos.anarcat.ath.cx> (sfid-20111013_035723_283263_BF12F1ED)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Thu, 13 Oct 2011 00:24:12 +0100, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> I looked a little further and saw that nl80211 does support changing
> interface type (mode).  But this driver (rtl8192ce) only supports
> creating new interfaces, not changing their type.
>=20
> Should mac80211 drivers generally support changing interface type
> (change_interface operation)?

Seems to me really counter-intuitive that it didn't work. It was the
first time I ever see such a problem.

I have seen numerous drivers not support "Master" or "Monitor" mode,
because of limitations of the implementation or the hardware, but if
this is purely a API problem, it seems like a problem that should be
fixed...

Is this the right place though?

A.
=2D-=20
The idea that Bill Gates has appeared like a knight in shining armour to
lead all customers out of a mire of technological chaos neatly ignores
the fact that it was he who, by peddling second-rate technology, led
them into it in the first place. - Douglas Adams (1952-2001)

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlkLfAAoJEHkhUlJ7dZIe1NoP/3drk7HSFgzZrgqC/gxakscw
P3yJ2s1RNwPARWY4fYYoW5AkJ1S5mIAF5CXvbOyH4rlJYm35BqLT64hYnR0UST9y
TvFm7KA78493w7E3vq0lyzTnr+hGA14e85kV+ZoS+PmDrmXamIJ8ntUxAxb1MHy5
sAyInjj6/Zj7b0JrT7/5gPYL++w4/kwTrOnmmJI1Lq56rKI9cnAdtp2qplEO5Erg
MC/Dq/XnyxtB0vDJignYf0zjdlkqkl/t+QkzO/w4jspE5tNmTCDLp9Jr8wT55ATf
/7pB7p9DCtSViy8f3yNx5g+CeqVTB+DvDjfjMnAwli1d1PquGzhESi/Kx6pnzadp
XmaUpGV5YDb4OkQM3dVKg6JF9zGQrM/xm/UYwikpebn5ArjCEmne42Fm3da2jQdY
HYlrN5d3+EFKM9JpTpUyKgHTL6lGqi6Sg73E8uC+eeXxLYwBFyNil8w7tbIGF1c4
jI140lnUacB9ifpumtCPNQda1p09U08WrTXDa1mCUAl1G7puSU2pqb8ZmfRjp1Xs
hxYnEsFwhvzsQsjRdPbIcjPQA4HsWdYsjtfKCN/iGJc8mp6ajcOBZPl/0arglsy6
vnjuP1bCapzMnaZoQyrRbspzOr+V9GMNrDS8m+5/oeULHXpgVGH63nYtnZ9BmY6f
DRD7m2WP46b+TVK703a2
=ReWf
-----END PGP SIGNATURE-----
--=-=-=--
