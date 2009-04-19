Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761251AbZDSNmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 09:42:02 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419133544.158820@gmx.net> (sfid-20090419_153615_967882_D1A9F951)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net> (sfid-20090419_153615_967882_D1A9F951)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-WV2l9VpWVQOd1VIYA397"
Date: Sun, 19 Apr 2009 15:41:58 +0200
Message-Id: <1240148519.898.3.camel@johannes.local> (sfid-20090419_154219_699601_D441AE0E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WV2l9VpWVQOd1VIYA397
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 15:35 +0200, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > Because you don't associate with an IBSS?
>=20
> This is only a name, but the call does mostly the same. I think having
> one generic API goes more along with the UNIX philosophy, than having
> for each mode a defend API, on which almost only the names of the
> calls are deferent.

Huh? No, it does not mostly do the same. Quite not so. Managed and IBSS
modes are _really_ different. Almost the only thing they have in common
is that they use an SSID and a BSSID.

And an airy concept of "UNIX philosophy" really has nothing whatsoever
to do with it.

johannes

--=-WV2l9VpWVQOd1VIYA397
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6yokAAoJEKVg1VMiehFYYhsQAMBorDP6m51Vdh3IgKS+LWl/
V3noBh4h0Sjgf3RdQRDyJ/uUCUHmSIv/RKUgpppI6TCJYaBvEUAv8t9sDaFRLTuw
mcgjJMaRYSO5wguRiK8DjnOtqRtma/6ZEwVnQqh1Mdrs2Sipp0+5y+/pznQ86mqN
dGwMav81R2fxSnr1HEdP3U7O3/KLr53yUaxwDwLMkVkCa149p9ZeuIgxsb90p/KU
gHna/aKfEwFjmjvId6SbFBn9ylP2X7XGu/B5R/b56xgRU8htmdenwYcHIWGGAsWf
aas0EXQyumsS9dkjQvTPnzKQn5Sv4w3IfjI6TXg4vUPRhmRZgh4QpLKc5G3jaUw0
Y5v8AwSKk9SC3WGqLhonDC02ZNBrGLjLYB+wyd0WMcLhXRAtNHFPyRcWiMUi2YI8
6UeVdDUqO/OzH2gGtNWLAduTQgcR9tt7JgNiV3//fPIoC9UVZ2z41wsKVbzecG/Y
ejpZHE0qp/zeN+YbwYKnHJ44J+EsWMbikAz3pyjeHVPqSQmywp1HbQTQCAipzq35
C2OLs+1XRBauUSAB6Ga62u7o6Ea9CxT41xn7Tuqwvc+mYSvkfYScH3IzQ05dHzYx
RwpNdXkjVMjWJRD2jsWo+U9p1Qif8IxdifokLXKyKfGGug7JHRdqX6d9IDTskI/2
etXs3kIDWoI7scVENHs8
=P0Ue
-----END PGP SIGNATURE-----

--=-WV2l9VpWVQOd1VIYA397--

