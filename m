Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50239 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbZENJJU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 05:09:20 -0400
Subject: Re: [RFT v9] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Easwar Krishnan <Easwar.Krishnan@atheros.com>,
	Nataraj Sadasivam <Nataraj.Sadasivam@atheros.com>,
	Kathir Ganapthy <Kathir.Ganapthy@atheros.com>,
	Ponmudi Ramachandran <Ponmudi.Ramachandran@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
In-Reply-To: <9b2b86520905140202y539f8b93m9669e2c8c7ffbdcd@mail.gmail.com>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	 <43e72e890905131445s5583481bgb556a925247368db@mail.gmail.com>
	 <9b2b86520905140202y539f8b93m9669e2c8c7ffbdcd@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-wvcn4yVmlixac1jNtvTJ"
Date: Thu, 14 May 2009 11:08:48 +0200
Message-Id: <1242292128.10076.38.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wvcn4yVmlixac1jNtvTJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 10:02 +0100, Alan Jenkins wrote:

> > I think my new 4 patches should address this and it'd be great to hear
> > your tests as you can reproduce easily. We are able to see something
> > like this but only after 3 hours of testing. Since it seems you might
> > be able to reproduce quickly it would help.
>=20
> Glad to be of service :-).
>=20
> I applied your four patches on top of my current tree
> (wireless-testing+rfkill rewrite), and it fixed the OOPS.
>=20
> As a sanity check, I tried un-applying patch 4/4 (cfg80211: fix race
> between core hint and driver's custom apply), since that looked like
> the fix I was interested in.  Un-applying this fix caused the OOPS to
> reappear.

Very good, thank you! That means I don't have to fix anything in
rfkill :)

johannes

--=-wvcn4yVmlixac1jNtvTJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKC9+bAAoJEODzc/N7+QmahHoP/3fkd0Oykx5Lb8vLNNceHD9C
YVVRvftT5sGjIUd4x7AQkW9TmleEzsT4pKJd5amLOIFc2fzSvEDI/1LtHoJNbVxv
97GMgDzSd/wHOIwpe3QctPfCvXBu159dDpN/VuLBacVKyjKW4h3Vm0IeeUUmb7/l
4HX2hH4EokHnCfe9/kg7sCMUfYazI7ZWkbiOzf5iGcBAIP/nirQJMWZEWfluPtSB
QLLbT7HR6xIWYfsz27B2DYs1B3PdBsJmICy7bsmxEplIUL7KzwEgNCfMJ9JHJlfi
BumZ4Pi6N0O0O/DNOkms2QwLE+Tsdbz/B+0Ih54oiYlCG+h18F4cnrDl8MGudrE0
H3aaynH8TyXUs01YsVw9KJKofSWK0E/y3FAiSQSKj38NOZWhIbeRyY8fmZzAZFVR
natM2zhvK5a3piAfDJJ6uVUzi5Yt5sg8sb0p+9uJw3t8BjBZ4S6dzAiE+4Yqiw66
IAc6jOfKpYiaLhISFTyGh6ybQPZfuizr3107WDRxnPLBmm/MZ/Ov5cV4cV5PGP8q
tuU58u9epgu5UY6EicUEixDyXe2bc8lrQY8Z5/Punk/XOd7sSWTolxMQRAjR5unk
qHiarDhZHpxDGdLjkaCw3cyCX744k+DRri/at1QKrn9NyDKYe3T8dkRXGGTUIIWO
ETzkiTSvPhDuBT3jarkN
=m6/x
-----END PGP SIGNATURE-----

--=-wvcn4yVmlixac1jNtvTJ--

