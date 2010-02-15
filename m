Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50570 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab0BOJka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 04:40:30 -0500
Subject: Re: [RFC/RFT 0/2] userspace station-mode action frame handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100215081635.GA906@jm.kir.nu>
References: <20100117144918.773071520@sipsolutions.net>
	 <20100215081635.GA906@jm.kir.nu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-LVyc62Uk49H61oVcn5tq"
Date: Mon, 15 Feb 2010 10:40:28 +0100
Message-ID: <1266226828.7084.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LVyc62Uk49H61oVcn5tq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-15 at 10:16 +0200, Jouni Malinen wrote:
> On Sun, Jan 17, 2010 at 03:49:18PM +0100, Johannes Berg wrote:
>=20
> > These two patches now implement returning unknown
> > action frames and registering for certain action
> > frames from userspace, as well as sending as before.
>=20
> These look good (after couple of small fixes to the latter). I tested
> these by registering three different Public Action frame types
> (including vendor-specific) worked fine and I think these patches
> (with
> the fix below) should be ready to be submitted into
> wireless-testing.git
> now.
>=20
> The fixes are for 006-cfg80211-mac80211-user-action-frame.patch:
> - must check rx->sta !=3D NULL before rx_packets++ in
>   ieee80211_rx_h_action() (the earlier version would trigger kernel
>   panic on receiving Public Action frame from non-associated STA)
> - must store match_len in cfg80211_mlme_register_action()
>=20
> The updated patch with these fixes:

...

Want to just submit them then?

johannes

--=-LVyc62Uk49H61oVcn5tq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLeRaIAAoJEODzc/N7+Qma2TwP/0hD4ayIPBwAhfjKR5Dq8fIf
9DCyCPEPleNYd8B8g+LvPwW9JPYoc4RHwJMV4b4X49YZxybgwHpM8PlTt3WaBNH8
4zJXHy+Gll7vpKC6e5pa4nZ3Eny+g3VOIfm8BTlOkwnLH7OenRUqfvG8h5sqfl7j
Chjvtwa2EVC3X7UQSy7tjVMs2k9M9nIIoxLn89gRgfzAN9+umkKT3lCzH2cNuvqT
QMHs0A9GgbGy8zOsTNISdzzw95KCweAq3/pr/fSa4tFukfUqEjj2mh0vYxCUyl1z
wA638Yh4jQs9wajydWIvGMXDyzoeUHtIjYvUBmwuFny0g/4mwDS99eD7BTSDJET1
3Cjn04XKGLBwa5JaTFktP/qKf0Q1HYPjdrDuD3e6IXkIlEXOPNvC4VjnmHIjfkHx
aIq1FEtx4bi38Bf9qWTtKjrsZHMnLOgYt976kVTm2szFwLP6RNgpBShHVxrh9Fku
bsgGKFY9Je9NGtfzcoqvKwq7uhZI1IS1D85ls/UozWgH2b6sEZza6mNRkutB/sTc
kGKFlpG6jFM0ip1TPFXfq5i6dk2/7BqecC9PS+KSvr2fZK//6JHuwbkKY4vRgL6A
EvirSLhMH4wp0caSe1y59YMMsU9Umnj09YQWsXcXStRGoswEpRMxh4kH8X+2fo07
bqFy2Wf29v6i1hwaWYvr
=+bjB
-----END PGP SIGNATURE-----

--=-LVyc62Uk49H61oVcn5tq--

