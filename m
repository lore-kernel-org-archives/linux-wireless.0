Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZC0Ve5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 17:34:57 -0400
Subject: Re: [RFC] rfkill/rfkill-input userspace API
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> (sfid-20090327_165815_381528_72AF136C)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br>
	 (sfid-20090327_165815_381528_72AF136C)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5tKvnt68W6oKSHYK4YZY"
Date: Fri, 27 Mar 2009 22:34:49 +0100
Message-Id: <1238189689.4452.26.camel@johannes.local> (sfid-20090327_223459_594002_44A880DB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5tKvnt68W6oKSHYK4YZY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 12:58 -0300, Henrique de Moraes Holschuh wrote:
> This patch set is being posted for comments and ideas.
>=20
> It implements a sysfs API for the rfkill core that allows userspace to
> completely implement the operations that rfkill-input is capable of.
>=20
> I am not too happy about it, I think it looks ugly.  But I had no
> better ideas.  Comments and ideas for a better one are welcome.

Can we do it after I rewrite the core to be useful wrt. hard/soft
blocks? Same comments as in my other email apply. I'm sorry to waste
your work on it, but on the other hand you clearly didn't ever care
about it enough to have posted it earlier.

> Note: unless something is done to change the way X.org deals with
> input devices, rfkill-input is _useless_ in a large number of setups
> as far as input event handling goes, because it will never get any
> events after X.org evdev grabs the input device.

Right.

johannes

--=-5tKvnt68W6oKSHYK4YZY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzUZ3AAoJEKVg1VMiehFYUn4QAIo5h2uUEVB62HNsToTkYndh
a2kgwnpwj4iMhKNMokPcWh9nEkd8HSZ7+3bEUAxXMNiEnY9B1lMws5j7voNHbSs9
zJKFuDRONN60tsYvnSeg1VBFghpPDHBC/laK7+DXMbfj7X1gTC0asbNbHoTy9zEZ
Hlq8ePIJ+HyoSjByluAY3A6lq6Hw2PeBOQ1lbM6MoZjCkN+CCah6sATEmd5EuC0D
jF0kXcTGLK1cVCJzixWi623XKEJQDAet2yFrAq9BY4rI0S/XMZdteVrXCqSiahJd
kt2NvwH3lM7RqmttNxyjNaQKfq/foXToKb/GxzYsHgHAw8MYrgS9929GzMENmzxf
BFdsIYEWR40X6BWqs/sRdwdWIp/NG9P0UNd/tmqBmWRKk+HGrWUv1lVKFuX0ynrz
jROydt+HhuSxT9czdC7otgvB59+TDokQlKFvWyRxlAL7AKQE7244jt5hMa9CxK0W
qWLR7hc7VgYlLHRPtqEgbz5uoGK63s5cNNKyoP9Aax5heVjqDG4F9v/vHgnvkqBI
9oOfL+qf4ZjwPH2SLISOen/apm4DWuzQnPP5hOGHmaKvmvP5tM0LgKmkUQjMBpCt
g8fzSDUW2aOvgDwMYTvIPPDDD5lAOtmtHZlZIM9R2oLk6O/8PISKSC570C1ZECbF
ykbfDWuAhU0JUOadEuIF
=4lxV
-----END PGP SIGNATURE-----

--=-5tKvnt68W6oKSHYK4YZY--

