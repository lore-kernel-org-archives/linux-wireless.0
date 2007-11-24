Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33744 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXKXVNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 16:13:37 -0500
Subject: Re: wireless vs. alignment requirements
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: dsd@gentoo.org, davem@davemloft.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071124141319.GA27819@gondor.apana.org.au>
References: <E1IvoID-0006aR-00@gondolin.me.apana.org.au>
	 <1195893216.4149.186.camel@johannes.berg>
	 <20071124133200.GA27531@gondor.apana.org.au>
	 <1195912176.4149.194.camel@johannes.berg>
	 <20071124141319.GA27819@gondor.apana.org.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q4B7dJ9BlOd9NBz6pqyr"
Date: Sat, 24 Nov 2007 22:13:19 +0100
Message-Id: <1195938799.4149.197.camel@johannes.berg> (sfid-20071124_211346_455375_86C4AE7E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q4B7dJ9BlOd9NBz6pqyr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> OK.  Let me clarify this a bit more.  We require at least one
> of the following rules to be met:
>=20
> * the IPv4/IPv6 header is aligned by 8 bytes on reception;
> * or the platform provides unaligned exception handlers.
>=20
> So if your platform violates both rules then it won't work with
> the IP stack, simple as that.  Fortunately I don't think such a
> platform exists currently on Linux.

Ok, thanks for the clarification.

Eight bytes really sucks for wireless, many things are multiples of four
and QoS vs. non-QoS frames have a multiple of four and common hardware
only adds two padding bytes to get it aligned on four bytes so there's
no easy way to get hardware to align it properly. Hmm.

johannes

--=-q4B7dJ9BlOd9NBz6pqyr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0iT7aVg1VMiehFYAQL+Hg//XJQMQl9RlxBzXj2N7u8dg7Ito9gPHyPQ
uQvZonyhu4Cm/mEwJD6us7JaiqDl0njH8xjaE4d7j3aHL/Nn4h5WICdUkD9PiLm4
/9IrtA6H+y1V0SCZ2RksifzCBA68crXdFp9sE+CNYxOPNOXQOg1TIFqILhiLqeZY
k/RYKy4iKKXCB2FQaOFX7KLpn2suRfShFDE1LbaORQ10ravS3VwKh8dSFfBZkbA+
hUbhuoTPaM4RUkb0aJNvJJhi9paLHdMjeZ1bNIRnFIOEat9CxZ/cDAWj1/uL1sgb
BNd0Tubu0Pm0uHQhGBEz6sdBOYocXx76TzXw8ZmC8l80yX/Xqnrd6+x2wmyR6rWv
QEHCUWqq4v+zJgbBLMhgmc6ghPSLkUWf8W/ARLTyGTWG0RaPji2q7cGte7pBndT+
iD4jWM4Udc0CPaqBwsZjHao3cc5DVHP++WkZ/yICMpgAYfZIIswWLhbbSbVQWZRt
BPSrBhmQq1wSacEJaw7Yy6x3jdxBfMjGlXTTuF/xZihkuZQ9SJ7tciL37e6ow16+
0qJO7HCgtY8a0gJ7GMxQZDoguBf7HYJuIsY1NmocQbImjGFGdAur6VWEyIUd0MVH
r5AlZMjk40Hmd5Cfk2fLO+9hLPqE28nS7keClhB2BUXu2iHOzm3jD7niSEEbMxZf
ZkP17w7DMJI=
=+nL9
-----END PGP SIGNATURE-----

--=-q4B7dJ9BlOd9NBz6pqyr--

