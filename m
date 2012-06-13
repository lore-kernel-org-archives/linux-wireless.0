Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45611 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab2FMNzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 09:55:11 -0400
Message-ID: <1339595707.4519.44.camel@jlt3.sipsolutions.net> (sfid-20120613_155516_276957_E6DA854E)
Subject: Re: pull-request: mac80211.git 2012-06-13
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 13 Jun 2012 15:55:07 +0200
In-Reply-To: <1339595539.4519.42.camel@jlt3.sipsolutions.net> (sfid-20120613_155224_024594_44042E09)
References: <1339595539.4519.42.camel@jlt3.sipsolutions.net>
	 (sfid-20120613_155224_024594_44042E09)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-mVrF9dKZ7oS9wnHdWeCR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mVrF9dKZ7oS9wnHdWeCR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-13 at 15:52 +0200, Johannes Berg wrote:
> John,
>=20
> Please pull my mac80211.git tree to get the recent fixes for the stack
> that are relevant for 3.5 still.
>=20
> I've included David's fix for leaving a scan request dangling if we
> abort a connection while polling it, a few kernel-doc fixes, Michal's
> fix to interface validation and two fixes from Eliad, one to avoid a
> possible deadlock and one to not call the driver unexpectedly.
>=20
> Thanks,
> johannes
>=20
> -----
>=20
> The following changes since commit 6aee4ca3d2217d3f76469e5ed576d62695f091=
2a:
>=20
>   mac80211: add back channel change flag (2012-06-08 13:47:08 -0400)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-jo=
hn
>=20
> for you to fetch changes up to 79543d8eecc0957ac6fe3ec1e2486ad31d4b67a3:
>=20
>   mac80211: stop polling in disassociation (2012-06-13 10:17:55 +0200)

...

now with signature (and yes, I've re-verified the commit ID)

johannes

--=-mVrF9dKZ7oS9wnHdWeCR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJP2Ju8AAoJEDBSmw7B7bqr4tEP/1Ij5PMglwXfkE+qjCRKJFGh
IkQVhBwGdJeObuJOFufc//CMgDfZUy64bIsCuJ1OvjdxQF11DI+BEAZUJCRd+xdx
xOj6laUKcn95YiVRV+JEvB2Aa4S+0E4WyYxjxW3C0WrNNz/VAauWklsf3Rp3EwPj
g9c9ryybJSfDRwNxgzDynzwxJdXSVYeini0IL0077N9sDMMILQUH2CWrCjtADBbc
z3SlcWpv4khX6HqQH/P8b8VTSoK/jNnRp1IBvA2XzXFkzaNQzeWCtp/yiXxxXPfs
co65E2Cx5vBz4k9hHYd9krLa82r6hRlTWTrYMnhv4CK8cF41xL+q215V5GDD07D5
+j217T3tJaxxKF5M0UrasRQF+QtiVCFHANRl1z5a0zGE1BPIlMjWNqzVdA9iX7TS
P38BzWkM7eh4gjINmBLiUFmSyH22DnECe9ail9RADH14lT6gcinXUM9j3IdXoyXz
EhnmBeYgUHbAvuydktM4QcfdwnbCNd/N6T3VfDUqXWPKp3X4fkX2tYDksOMc4Qnc
G16oppeKgp9Nv0x7Df92yPJ2HB+VlMWogHRgWSRIO8c8LQ8Q2Sia2RDZWl7FeQ85
P36l7NxPoIhte5vcso/SIG66QuI+9pwxotpVP30JofspTrTxk4AsXMOyEdxkSx9q
U4/Tge4f6EkLw+v0G3l6
=C0Qq
-----END PGP SIGNATURE-----

--=-mVrF9dKZ7oS9wnHdWeCR--

