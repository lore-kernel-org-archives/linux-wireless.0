Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbZERT0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 15:26:08 -0400
Subject: Re: some wireless suspend thoughts
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <87pre69qyx.fsf@litku.valot.fi>
References: <1242397016.5799.102.camel@johannes.local>
	 <87pre69qyx.fsf@litku.valot.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uQfHg6H1DXq954MG1XiA"
Date: Mon, 18 May 2009 21:26:04 +0200
Message-Id: <1242674764.29049.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uQfHg6H1DXq954MG1XiA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 22:00 +0300, Kalle Valo wrote:

> To me trying to maintain association during suspend sounds wrong. What
> do we gain from that?=20
>=20
> In my opinion it's better to disassociate during suspend and let user
> space reassociate during resume. That way no need to do any special
> hacks and functionality is the same with all APs.
>=20
> I'm sure I'm missing a lot here, but this is my first impression.

It seems it could be possible to just suspend for very little time, in
which case you might care. Also, this actually helped for the case where
we don't manage to maintain association because then we send a nullfunc
frame and get a deauth very very quickly at resume.

johannes

--=-uQfHg6H1DXq954MG1XiA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEbZHAAoJEODzc/N7+QmaFQ4P/0CSNJarrJbSZUpXvjLI0uUC
cpbpbDo7+4cmfCKQrCPENHoz+0g1TNeEi2bPirm+Xf197zY78HxMKqffE7qP0xWW
PYGG/i4Q18iHmgpyZIyBdbTvgasxajGZdfRYASOna8B6k73PfxPt23VizcxT4r5d
PV8gkrNEuSoO4K2l7AQJu1OuBwiQv5vLNP+CTg8JaVaAEEh+q76I9wedBV8W/By/
+mnoKq9fNp6ApUwI+aQxy+TjWGN+r/nt+73Hub6lI8kuyuE3WtN0uHhlFuMfnCja
pelxaGYsbm4iKUDN8K4kMS31NYeLdtyLQDi9SCF7jG2WCIbkrpn5U61A/BhqEZ8g
jUkRz+On4T0TxRTkzgiIIanyUeM4nn2H3CLJmBfU0Bk/RGfIGt3W1Y687pDzkjKC
LrS6OUPYo75/iLcKMDTQAOyaS3RVCbp+FWKZwWzyeT9PSGJitR1trJndsbonCb16
UXnxL1OFtCpJJN/u203bYt1dUEt3E6SCoQT166BTdo9rT5BIsqRnKvIktYiL1uTh
4fTsJ44Bq6iZULHpvGJlT7qUtaiBMUGe6c4FDGspsVpkfZ2N/QcBgT92hQyOD7T5
7gaR0IHqRpTUm+UR1IRlMTz2x/Yv/FpjRM1cvGEvU4RJLAmkCCnC+gf9EnecjJr3
zADD4D3WdENHaov+Enjh
=tcIr
-----END PGP SIGNATURE-----

--=-uQfHg6H1DXq954MG1XiA--

