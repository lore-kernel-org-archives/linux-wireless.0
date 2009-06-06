Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZFFRpb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:45:31 -0400
Subject: Re: [PATCH 0/2] ar9170-fw: Roll-your-own toolchain
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <4A2AA94E.3050700@web.de>
References: <4A2AA395.3060406@web.de>
	 <1244308808.15640.4.camel@johannes.local>  <4A2AA6BC.5040004@web.de>
	 <1244309333.17485.0.camel@johannes.local>  <4A2AA94E.3050700@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+4HPqckB0XAFDnNb/CFy"
Date: Sat, 06 Jun 2009 19:45:29 +0200
Message-Id: <1244310329.17485.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+4HPqckB0XAFDnNb/CFy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-06 at 19:37 +0200, Jan Kiszka wrote:

> > Yes. With the AP firmware, that is. I don't care about that firmware at
> > all.
>=20
> I do as it shall upgrade my soft-AP from an oldish rt2500 to this
> dwa-160 stick.

No, you don't actually need AP software for that. The STA software
supports most of AP already.

> Are you at least interested in porting the missing AP bits into the STA
> version (likely the best long-term approach anyway)? And do you have a
> rough idea which bits are missing / where to look at?

Yes, that would be the plan. No, I have no idea what's missing. There
are tools like diff though :)

johannes

--=-+4HPqckB0XAFDnNb/CFy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKqs1AAoJEODzc/N7+QmaVWkP/0lJswBKKHtd+c/g5e6jWnC7
9XaWKonJOAzrrgyRvSGkKxHHoqM8L9Mab7+yb/jknIZS9UjZtenu4BwWepVWy64M
CG2FfRlAvT6RM7vxZzrzEIJgcXrt87Aq+NIP7YTx9Kh/oFRMSivhEfbQ19nUXcDq
GXnWCB1LMeOG9ZKZxfyQ1E6reqa6XeuT5QZwtCw5up4DCyiqsGV92WmzeF6fpap5
iVr2brvpSZ9pxUzykAtjzbvjTV96efNutjiigKu797Y6GLI4dqN3oX19QHpIFisy
6/OAs3DfWY/WW+CAlSteeQzh/qN0V7PUwN2QMow7cgNuWWyc5C4WCtfGJmGKngAF
xvs7iLzWMxovoA8QhkkU+rqMicfkG7xcQjr9r9irxJjlxaeUWjfQLU9JeJZq4iXJ
MZIhzTOHlR0358tnOgAgBT2jFt5xROh3remwISFVwXp56eSpv/4R64wTrhpAJvXq
YShd4voiNyl5WA8EwG0BNhrAwOXc7HyDUWmnTADq74OpZ5qTjNDkg82LkYQc3KxO
JFINt5QwllRYFFBjQ6F/dumhdBY5IpqASU10vvxWaErr2St3cojNoAcbqgCEll8Z
DpZ4ItEWYu4A82n6iT0g3XCw95/TDuckN8gVd+dxFcviGRMmJa2xmQw8F6K6zN/U
8oAGnBrQHEH2tr5wD0H5
=g62N
-----END PGP SIGNATURE-----

--=-+4HPqckB0XAFDnNb/CFy--

