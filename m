Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754771AbZCWTvS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 15:51:18 -0400
Subject: Re: [PATCH v2] mac80211: resume properly, add suspend/resume test
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20090323194313.GG3285@tuxdriver.com>
References: <1236939917.5235.7.camel@johannes.local>
	 <1236941058.5235.12.camel@johannes.local>
	 <20090320160308.GB28965@jm.kir.nu>
	 <1237622383.5100.162.camel@johannes.local>
	 <20090323194313.GG3285@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FLvPxTGGcUXM7x3XzFVf"
Date: Mon, 23 Mar 2009 20:50:53 +0100
Message-Id: <1237837853.6147.19.camel@johannes.local> (sfid-20090323_205122_191522_71A9617E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FLvPxTGGcUXM7x3XzFVf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-23 at 15:43 -0400, John W. Linville wrote:

> > Indeed, this file should depend on CONFIG_PM too I suppose, will fix
> > that. OTOH, a future patch I have will require _resume to always be
> > present, so I'm inclined to just always put the code in. I'll come up
> > with a fix in any case.
>=20
> I fixed this in wireless-testing.  Feel free to change it as you like it.

Yeah, I saw, thanks, good for now. I'll fix it with the hw-recover patch
I have.

johannes

--=-FLvPxTGGcUXM7x3XzFVf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJx+gbAAoJEKVg1VMiehFYAX8QAK+pf0fKZxujSNKSpkUjIaBk
QSkcFr5wHjSbc9I0RaAms440bc0lVRgvspixsM2YIAIg2sh5NTZsHGI9YjK0t02p
BkX8OkwMaQZaHpSRiDTq1hZ7X/kP5ovwpy281rVGgbDQfEWoz7VrMUDOvv0apGT3
OpMSGhu643Ssf5+HhvX59m2NZtzV0tgBr1+w7eiN37vjEC3FKPnKzTQBugwLNDAO
epTEpcfEL/DKZadbaiFxTEZUXdRVxfZ3XSQ91GayjJVum0oSoviYB6P/oljALUyc
IcmjaTq2TCEucjsnvnOo/J+fF/u3lAj0DQ1VxWTg1IRSjhr5iSCMQ9A6m7dowPwn
uWxaECu1CuNPzgM3FeK13f+if2M1ioBTOzyg5iKvsPEaKL/SwlsPH15aY0Dmwjxk
/xd2Iy6aX1SeTJG4X2jx40NfEsOzTT3b5wqd6IxbULHcTKtqtHXhtP3Oc9BSvTFe
B7bAPeQBKawdEltcj/Cj3ixypD7VWmq/n0ZM8Xh70JWwQg6gVy8f/eEWXI8TKORc
UhJb6JTp0/xkHxW7X0IGAhdWRwfCmN33Jm9O6K3XqXITxyv1A0gkDRSuqXfpxEvT
niBLNPgNW7IMheofzI+XiJ1F8+vnUY3EuFGtsn7m2oKsZwLSC8wdiehm264wHadV
Nuu9wraJ9gxEESIS/RLm
=wETQ
-----END PGP SIGNATURE-----

--=-FLvPxTGGcUXM7x3XzFVf--

