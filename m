Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44315 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZEES6D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 14:58:03 -0400
Subject: Re: [PATCH] mac80211: report operating frequency rather than
 current
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Farina <sidhayn@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241549389.4969.0.camel@johannes.local>
References: <1241452330.8683.49.camel@johannes.local>
	 <49FF2AE5.6040104@gmail.com> <1241460130.8683.85.camel@johannes.local>
	 <49FF2FE8.8010004@gmail.com> <20090504181357.GA19022@tuxdriver.com>
	 <87eiv49k6o.fsf@litku.valot.fi>  <4A008649.1000007@gmail.com>
	 <1241549389.4969.0.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1qUfsAp18ynKA44ao28S"
Date: Tue, 05 May 2009 20:57:29 +0200
Message-Id: <1241549849.4969.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1qUfsAp18ynKA44ao28S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-05 at 20:49 +0200, Johannes Berg wrote:
> On Tue, 2009-05-05 at 14:32 -0400, Richard Farina wrote:
>=20
> > To be honest, I would be perfectly happy with this patch if something=20
> > like a scanning "flag" were to be show in the output if that is what is=
=20
> > happening.  I don't so much need to see the current channel (when in st=
a=20
> > mode at least) as I need to know that the card is scanning if it is not=
=20
> > currently on the channel the AP is on.  I'd be very happy to simply see=
=20
> > it say "scanning" next to the channel or some such when this occurs.
>=20
> Except that's totally not possible with wext.

Also, again, it is impossible in practise to do that for all cards since
fullmac cards might be bg scanning without telling the host.

johannes

--=-1qUfsAp18ynKA44ao28S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJKAIwXAAoJEKVg1VMiehFYXBEQAKds2EWPtvMEu7IXQEfPnKyL
FmnsCTwzZbIWx67d0HMQ+vl+I69sL3aNEIbKJf5wDSI8IKN8Uv8Yow/0IIXUsDiP
H0N10qXaCrmCkdQZiLUFMZlYMc0UDlIziQFquPVySwFQV9UmLOeUxoNEWZax0bLN
KR6aBRPmfa1KCmHumDHTcrBKP+tZn1yqLBP4aiCpg48Um4vJynbYzn8N+Fg2AelQ
9ZzOeInmMkV9lo/1wFGRpIojWo5dqQP0OVDO8qRlWm6sLWSpb33a/1WLtHEJDM3c
b3PuwINGmzIW1V4njG7gn/Gi/jjtrgzUbBlSasmLKLjyChYVFn4A+nDcxbA0x5m4
dazsLE2KhOaDxdjdFzu5ac2xdDYke0gjg32YaBcjy0QU//ep5a+OaE0Ei5kNdp15
8VuzrItdIBoUo8MnAPF7wF7SN8Xapsxd9e0z0EPTGKD3j+R3RKOXFPafUHv7ico3
MSQ8laO5r5GKTm0rp+X4gGdYUzbwqjgUBzr9i2QQ/Q2xi/+jTaQSVBsGtAWUiyVt
YDGsF0Zv9QZl4jc+zgaBMGvkLXv9angxJDXECpWOv1diMq/u7DM21T6WoXjbv+Ik
wtpPFFv6KxYszZQGaWc5/yKWmZ5wKg5urExJJ0Ptso1bNy3FbtaXvrGw3MiLQMXd
QPNP+q+/vXq3t5YgtpHa
=WCtr
-----END PGP SIGNATURE-----

--=-1qUfsAp18ynKA44ao28S--

