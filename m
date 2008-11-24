Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYKXGQY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 01:16:24 -0500
Subject: Re: [Fwd: please don't regress ath5k.h]
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Renzmann <mrenzmann@madwifi-project.org>
Cc: Richard Farina <sidhayn@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org> (sfid-20081124_071514_224762_60872498)
References: <492A14A7.4040808@gmail.com>
	 <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org>
	 (sfid-20081124_071514_224762_60872498)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3c+sXYF9zX+2D4UIxdia"
Date: Mon, 24 Nov 2008 07:16:20 +0100
Message-Id: <1227507381.3599.55.camel@johannes.berg> (sfid-20081124_071627_637871_D7BDED77)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3c+sXYF9zX+2D4UIxdia
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-24 at 06:44 +0100, Michael Renzmann wrote:
> Hi.
>=20
> Richard Farina wrote:
> > I recently saw this additional comment added to wireless-testing.git an=
d
> > it has me a bit concerned.  I use this feature for a specific patch set
> > that I maintain and it would break it pretty bad to remove this.
>=20
> Just an idea: what prevents you to add a patch to that patchset that
> reenables the amount of code you require from the CHAN_DEBUG stuff should
> it be removed upstream?

Seconded, upstream should remove all the junk that it doesn't directly
need.

johannes

--=-3c+sXYF9zX+2D4UIxdia
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKkaxAAoJEKVg1VMiehFY6YIQAI7iX4UzQevCIkr/84dJZH+t
U9zI1QnWq9AaljGttQ/MesEKF3LXtbCwCrNo/7HbzfmvfJl6juQStiHtYj/obV5i
Q01Ps3UxQUTNiGT7PrfQrz10aj1DMsdc+59g+KZ3/lbyvg4at6s1Io/skMbCXw0f
PFZyhboacRGgaCZUZXQ6K2uRLNvZyObyQtK8NmTNo1EYnbrqkHDZz/dUB6JWlw+0
i9GXURGb3TEgL7YrguuLTVOkb8ps+Ezyv0E1f7uJEiD1RshtjJIOF3cbWvJjWpJC
ThiqlT+DpfIK/Fd5evurUUaVbV7hE+tVFd50pNxCaQ7GUt7+NrjabzuR46WC4olt
ElWRN1gsb1cp73zFWeyUDvIYM4unJwaDocdn1MKoLXjfyP7roopO33Ytl8iCaUNd
gYGFVFu7+SKKhByYKEntkdnbarRKOpB81ckJM7uuoA3gAOpZe0qb2EOvh3b1zjIg
db328jsemD5QwBiNJoYyPPAp7HAOuc9bvKAeH81kMZ+iYom37IsCfbtrLSp6Rmlr
sc2r+diLQ/BbEbIlZLKc9I7I6agRna9PlSXyjDWwutLfW84ID2Y8xZDwtb9VwzH0
eJ4t7nlwRC7MICI5cKATsq+8VSXLlPy4TmzsDAk+h3LcLurjjMH0lzAKqm2c2WFs
1J4Vb3dm1mgIDxSxgyJD
=bbM4
-----END PGP SIGNATURE-----

--=-3c+sXYF9zX+2D4UIxdia--

