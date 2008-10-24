Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139AbYJXSgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 14:36:37 -0400
Subject: Re: [PATCH] wireless: add regulatory_struct_hint
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>, John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <43e72e890810241133s7af6958q5e889a81803555c3@mail.gmail.com> (sfid-20081024_203332_041805_B6543983)
References: <1224585110.5521.8.camel@johannes.berg>
	 <1224816184.2917.162.camel@debian.sh.intel.com>
	 <1224841176.6002.124.camel@johannes.berg> <20081024101518.GB5951@tesla>
	 <1224872780.3919.3.camel@johannes.berg>
	 <43e72e890810241133s7af6958q5e889a81803555c3@mail.gmail.com>
	 (sfid-20081024_203332_041805_B6543983)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YJEzDHCcTjdGvSASz0Vi"
Date: Fri, 24 Oct 2008 20:35:51 +0200
Message-Id: <1224873351.3919.5.camel@johannes.berg> (sfid-20081024_203640_413284_92D4305B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YJEzDHCcTjdGvSASz0Vi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 11:33 -0700, Luis R. Rodriguez wrote:
> On Fri, Oct 24, 2008 at 11:26 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Fri, 2008-10-24 at 03:15 -0700, Luis R. Rodriguez wrote:
> >
> >> >  * if a wiphy has the "hw regulatory" flag set and the
> >> >    cfg80211_regdomain is the world regdomain (whether hard-coded or
> >> >    gotten from CRDA)
> >>
> >> And if initiator =3D=3D CORE
> >
> > Makes sense, yeah.
>=20
> Now that i think about it, this would suffice for the check, no need
> to check for world reg. Thoughts?

Indeed, probably easier, CORE always only sets world.

johannes

--=-YJEzDHCcTjdGvSASz0Vi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAhWEAAoJEKVg1VMiehFYnuEP/212yfiH5JwfYDVwe3PfeqlO
gOi8u8HPWx2ZQ5lVw/KTBmMIAodCR0LcTyOsvqIYrKMQ5Ko/uHe1IJRsHFwSWqsd
KY0OuZ2pjWXq1owSMkd+3WYMvUoKdI+NMozNTmCKvi0x90HwzEprnGMb/5OMXQ99
OYf8m9Y7ooGA/WP/Sj9zhnd0h+d62D0B2z2v9VTHAY2aaCiHYAL1r9mqIT72QITA
p2TcKtFvRpFemRGIdC4Xu8+SHUS1Nm4Mn6TmZ8ZjiosC5KA/LWbBv7yKG0TXjMAd
I3cxEHCHTePQkvQqfUUDUHpENiwn3SevqWn2/hfjL9EpZuxGRWgggdFsjEBLCdr+
KewTDwHGmtLLNje1P4mhZiA19WaY3vBT4JG2D3n2Fn6yOONkHP3+oM7030E5Xgwf
9zO9PPpdZhr2eK8e4Ac0txv6TXS+9m2qPhhFCk2AH5pixrMaJJaZ9Uehy+DucrYr
e+QCgPm5Fqw+aN3CUlTz2pwwe0sS1FIhY56yFbDi1y23rgkDYZe9F5P6lKP8fm1/
kBv0GHcdo4lKAOWsCacucKh4RI+Sr9fE+dJ/Cr5synE0Qv7StkHJUOOfrF44jOjY
jKjp11YThmb0FsOCK6nUWFpRrhxn0sJWdqwFduQ+oVaLPPHGWB0iT5PM+QB8rLwc
L7TbjXgSCEspKxQ7JXC4
=PTtw
-----END PGP SIGNATURE-----

--=-YJEzDHCcTjdGvSASz0Vi--

