Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbYIIK1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 06:27:18 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1220955934.31304.133.camel@johannes.berg> (sfid-20080909_122544_763886_3E25910C)
References: <1220883730.31304.60.camel@johannes.berg>
	 <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
	 <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com>
	 <1220954146.31304.127.camel@johannes.berg>
	 <1ba2fa240809090321w4d2f3780g32e9507fac45f95e@mail.gmail.com>
	 (sfid-20080909_122153_370566_DF11DC5F)  <1220955934.31304.133.camel@johannes.berg>
	 (sfid-20080909_122544_763886_3E25910C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3PE9O87hyIqlRJpoy3rQ"
Date: Tue, 09 Sep 2008 12:27:12 +0200
Message-Id: <1220956032.31304.135.camel@johannes.berg> (sfid-20080909_122721_028526_ABAE2B7F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3PE9O87hyIqlRJpoy3rQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 12:25 +0200, Johannes Berg wrote:
> On Tue, 2008-09-09 at 13:21 +0300, Tomas Winkler wrote:
>=20
> > > Right. And if mac80211 is the AP, then I don't see how the STA can st=
art
> > > aggregation since I couldn't find where the relevant action frames ar=
e
> > > handled. But you said it's not part of the code now, so I couldn't fi=
nd
> > > it anyway.
> >=20
> > That's probably the current situation.
>=20
> So back to square one, where should it be handled? Does it really make
> sense to let hostapd have influence over the decision, or should we just
> move the code that we have a bit and handle it in the kernel? After all,
> we do have all the code necessary to handle it, but it's currently
> restricted to STA mode, and I don't see a fundamental reason for that.

In fact, what if we're in STA mode with userspace MLME? Do we want to
handle all that in userspace then? This doesn't seem sensible to me.

johannes

--=-3PE9O87hyIqlRJpoy3rQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxk98AAoJEKVg1VMiehFYT40P/29UEDWlHTxq1WGo/nlxVIUS
6DZnAUQrdF4PQvwf9eyqp13WkRhemFkauanA9KGetMWDgNm5yWVQmpAdW/EV2MAQ
8LaJhU9NZ2sN+C/TWoe7wIVUB/Q/nOf66mbpDuMvVnEgp/c+4pZK+l2v+Y6Q3i/f
iwgrkA+kpb6EhdW8FIVpZZZz7VWG3ZTE64c5iOuxJIHVw+sgLXWPm+wX3tPfh5RX
kj3IUMeqC5U46ZbgxIZuI37h09LcVNzz3nWDELu2Ougv7eAw91EMo0N1Y0c2nWX8
4fUTFwMLQFsii5jyoqnBby+tK+hkJhQUdZzz7baWgKLXTced4BV1ehHcL67noSyL
vpNdaXuabpoV4xUnuP7DUmA3yALGcLHD2HKiYgc7Pbk7Qu3tr03v5XMvFwEQK9mG
eRnyvuVvYcDSrAOEOMFzuY9FTiPYNaKCifF7WJPYYsx+VuViLy3lGFwj/6QZYa4T
GrWHwm7rFOKAfFQt9N7c5eRQnCWyyKLMxaa420S2m0gH3WaChJusEPbcahjxlLZ+
9ZrCr/6Jgluf+uVZ5+9hPNtc0016WKse3nQv4hhUIc6RaRarq1Hf23P1AcRGyODT
NvdPSYR/AEiXvha6cum3Q3d9bDh9feTXjni6+xuQrxFe6Ey+UAyEnm27K2mdhHM4
/4Ad4CKiCY4n04jsDPex
=fbh6
-----END PGP SIGNATURE-----

--=-3PE9O87hyIqlRJpoy3rQ--

