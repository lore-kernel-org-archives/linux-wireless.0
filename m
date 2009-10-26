Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40920 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZJZNb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 09:31:29 -0400
Subject: Re: "Reserved instruction in kernel code" on ath9k insertion
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4AE5A3DC.1090804@wpkg.org>
References: <4AE35A9E.8000507@wpkg.org>
	 <43e72e890910260617n6efbd260gcafbf5d1d2c84e23@mail.gmail.com>
	 <4AE5A3DC.1090804@wpkg.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mYNsPsOUe3/jSlzcBvJj"
Date: Mon, 26 Oct 2009 14:31:18 +0100
Message-ID: <1256563878.12462.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mYNsPsOUe3/jSlzcBvJj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-26 at 14:27 +0100, Tomasz Chmielewski wrote:

> >> [  165.440000]     Not tainted
> >=20
> > This says not tainted.
>=20
> (...)
>=20
> >> [  165.440000] Disabling lock debugging due to kernel taint
> >=20
> > But this says kernel taint.
>=20
> Yep, I saw this as well.
>=20
> About every oops or panic on this hardware says "Disabling lock=20
> debugging due to kernel taint", no idea why.

Umm, oopsing itself taints the kernel, so _after/during_ the oops lock
debugging _gets_ disabled.

johannes

--=-mYNsPsOUe3/jSlzcBvJj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK5aSjAAoJEODzc/N7+QmaQYgQAMV4vqOtS374DJyt0BSVanFw
j4itx79NkJDhliOVBYNNV0PK2Sj9mbRYB6UfnOfI4EjGjcoA8uKmft2VjbsKpIxG
SpkF1s7Raiadpo8Xu+sIu2mRyagr7q9qN/DMey912PYUXn+IM3OPk4IFNxu0ORtJ
yv2x8D/xkLfDnCoMJ9pFv5aXKBLdBiNyFCbTCUDBeyK4M27pC/clph70WcYozVG2
wH7PQwEs49/CuPQa0fin1jgJJo0tUl2zn7drimeRj/2Iiy2cAwueEqYs/UabF4PD
RkOTgnflB1OwPWVZPLHP3fEriPasCTu1KZ4Xza5mQ7BDbIzmUVB/Vtd0CniglrT3
pOSPIR3EXoAnCZXtFguUSZ4KNS2dHh2j5pKm69GobbjZwfjYPbiRFyp9VQMCqYjR
pP2NQ5qLTEA7yyQR+aLPGyh1inKL7K34AoYXpp6KIEHTaQyCD7GLlCJyfKmTj6JJ
e3odFhpEandJnzlAvEn9wVb+9N8KWuhCq+wBkir5seUOH/GGWJhMSRpN3777nULD
+v/EoMO9qTXnEi1M/xlA3wE4hOV/frP3aotFITPMyQymrmNfHLKPJS/glqpS6EXh
emQkDFhC+UnHTfmQdPn1MKv/BZQTy28MmzjYJ4yWHZFsG6gUA9Nw4b/ZNEohhRzh
W9a18+0qru26WpQP6MMl
=lnqW
-----END PGP SIGNATURE-----

--=-mYNsPsOUe3/jSlzcBvJj--

