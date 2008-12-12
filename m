Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbYLLW5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:57:48 -0500
Subject: Re: [RFC 0/3] cfg80211, mac80211: Introduce radiotap flags for
	finer userspace control of injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121454t7d765b27l918e2f6162bd3f08@mail.gmail.com> (sfid-20081212_235405_000913_4548C728)
References: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com>
	 <1229121467.3565.2.camel@johannes.berg>
	 <69e28c910812121440j6e010ac0j6e08cd6a53f58bcb@mail.gmail.com>
	 <1229122225.3565.16.camel@johannes.berg>
	 <69e28c910812121454t7d765b27l918e2f6162bd3f08@mail.gmail.com>
	 (sfid-20081212_235405_000913_4548C728)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kGlfdFShFt7yOiO6T3zf"
Date: Fri, 12 Dec 2008 23:57:43 +0100
Message-Id: <1229122663.3565.24.camel@johannes.berg> (sfid-20081212_235750_714225_3A78A5CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kGlfdFShFt7yOiO6T3zf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 23:54 +0100, Stefanik G=C3=A1bor wrote:

> Using an "assign seqno" flag would cause existing injectors that
> expect the kernel to do seq numbering for them to fail. This possibly
> includes hostap and penumbra.

Yeah, I know, but can hostapd/penumbra really expect getting seqnos on
other platforms? If not, then for the sake of interoperability it might
make sense to switch around and have hostapd/penumbra just set the bit.

johannes

--=-kGlfdFShFt7yOiO6T3zf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQuxjAAoJEKVg1VMiehFYSncQAJ4dQGW6+m6zANcKyM1iy6Lj
qvaR24cExSs1kpE3+0MQJp743/sG6RWwS3DKz/eq4963ZMx/DqEjjbdZZITs0Dc0
aYXyNf85jgyI3YdmedYTscrlsS+XNaFiR+E7n1LXEljd1TCDKT27DlAYpCn5vKv3
yTm6G6AZ1tlcw8opGF3nFOVqWnFXb9kbHbGgR0GE0nJZudpa3ZYEPZNDTaOJt4wQ
YCWtd7kG+AHoLLp5lxK3R28D5AgVFRgDK05KteEANw6TwRvqAoND5UxbO5mRfMbo
ojVwtNn+18QPXoqNYQyHDHIiSmLBjyl8Aspg2WyuAwNUMlIVqjunFZ1CLW0tUivz
FNdFXv5blhSq6MUdsHQ1AZukb2qLLveWIgpirPsIssnsrgORE13aBCJcfbUA98No
oYsD2dQnJ+c5vXwte1Ut0gvotUmd6ZyMnostLTcr9V+uBEcK1B68ZK7XMlRuuomj
QApNIkfLk9+h41uaGJvTE6qxg/szMkPfK7t/LgL2iASZXmGe8DH7otKCg0L4oqe/
Pf7kaVUfmUHSGV5xPMIh7K34PQFgIQUPTim9OUFaGXEqCczfJ8imsBZgTms997lA
dFoUnqkocrgzODoekrEfssQkaw2XWEg0jCGsTcco/nZ+AFY/9wdLGuPdqEiGnuRE
P8W9q7tQVYl+m8w3mkSA
=+R7v
-----END PGP SIGNATURE-----

--=-kGlfdFShFt7yOiO6T3zf--

