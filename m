Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbZJZQfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 12:35:10 -0400
Subject: Re: [RFC] libertas: minimal WEXT handler for MESH
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <200910261729.36583.hs4233@mail.mn-solutions.de>
References: <200910261729.36583.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FOYZeEbok1VBMK/NNOqO"
Date: Mon, 26 Oct 2009 17:35:08 +0100
Message-ID: <1256574908.12462.15.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FOYZeEbok1VBMK/NNOqO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 17:29 +0100, Holger Schurig wrote:

> For many handlers, I simply put NULL there, but I guess
> that I should do this:
>=20
> a) register mesh_dev with cfg80211 as well
> b) use the handlers from compat-wext.c instead
>=20
> Is this right?  And I guess that I connot do b) without a)
>=20
> Or is it ok to do b) without a).

No, it's not, it'll most certainly segfault.

johannes

--=-FOYZeEbok1VBMK/NNOqO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5c+4AAoJEODzc/N7+QmaTxcQAIk0erk3v3sy5Kb1EtLQSCuK
X3npxwf4Z9i93skwaZ3Bi8jB4MUFC2K8Wb49CxoGKY7YKt8J8DH4+GtlrucCH4qZ
OW9n4hFMwZL3VpRS5z0+TXQvtycZXwb4i7irWCkvczZWbXVWPKoFdUrXdH3uMqiJ
z43Rw88I7BpR6rQg7jmTDEk5NHeONoM/vxinR5lC98sGWWW58h1IGlcEYKQ0oP99
XzvXnG5NbJbZa/lDHFHXLgdbGu7ehhPZUxAtlYFccUizffqHNrdgA88XFPFiADnO
1juqaC6MdUgUryH8JAVwZ2x0fvY7aSAuuhKEQcE+HTvmCUaOznGSiXhqFeg+xUZ3
mZ9lIfPy/TxleGgyRXr7GMb3lAOL9bimqKTGlHijKdI6dnnY7RsqEqA2g0Gk3Xb1
akthKnzDjemqokkfJc2t2Jo4lxmJlpb3kBhna5X8AkhFzib5/SIf5W8vBF4iBWu+
H6jZRbZj4wwF7CN0LM0H5CpKongRlCTKDbaGOWddIWAs05r02qUmU3eALIeagO7H
CBpI+vE7j41MnyEwZLTbpLixvNcqW8jQk99o0pg34Ezj8ZGeK/i10HswF/VLyWu4
CKN4w1e1aR44sYpUTD3jayskrmv9E6deQeIMhW8Xv3CswGdlRulGbZBtc55h/5tm
v3UzjHS1TMfH+XZT5vgB
=kYXy
-----END PGP SIGNATURE-----

--=-FOYZeEbok1VBMK/NNOqO--

