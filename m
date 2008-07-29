Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbYG2M21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:28:27 -0400
Subject: Re: oops in cfg80211 doing mesh mpath dump
From: Johannes Berg <johannes@sipsolutions.net>
To: sbrown@cortland.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <488F0C13.6050803@cortland.com> (sfid-20080729_142722_191284_7E917B5F)
References: <488EF6E0.7050209@cortland.com>
	 (sfid-20080729_125437_639538_96B3F8BB) <1217329761.10489.15.camel@johannes.berg>
	 <488F0C13.6050803@cortland.com> (sfid-20080729_142722_191284_7E917B5F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I8vdTwYKG3V2EV2eOoV2"
Date: Tue, 29 Jul 2008 14:28:24 +0200
Message-Id: <1217334504.10489.44.camel@johannes.berg> (sfid-20080729_142830_143666_06B98767)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I8vdTwYKG3V2EV2eOoV2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 08:24 -0400, Steve Brown wrote:
> Johannes Berg wrote:
> > On Tue, 2008-07-29 at 06:54 -0400, Steve Brown wrote:
> >  =20
> >> I added line numbers to the recursion path. If more are needed, let me=
 know.
> >>    =20
> >
> > Thanks, I have a fix already somewhere
> >
> > johannes
> >  =20
> Your patch set "[PATCH 0/3] mac80211 fixes" did the trick.

Thanks, good to know. That was the patch I was thinking about, I just
couldn't find it again on the list and decided to just send it out
again.

johannes

--=-I8vdTwYKG3V2EV2eOoV2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjwzlAAoJEKVg1VMiehFYj/QP/0nKxwdm5uHvdy3mVNC7sD9j
0YVZdnRZT4frWHYao/MVDFnLmoA5CcqL8wkokHrt2F3OcepqOgBhxM/lgnX+sWTV
3fmZpnNsMuFwmPI8hTAe82oIajABNNr3rq2Uf2etg/XvhVnz////tBGYuGQgBU4L
lKl9yM63so27lXyVlMzryOn03Y27Op1EQXwRV3TLqDavulldqGehPLGMh3w6ycaa
2IRPy3DzZn3tJLNbkbeAgR+Ke4BYOuWKyUrp+iHfbzGMZCdXTZJODjAhCwS5UqKS
WBNojnXIHXffR+Cnz7E4sdkj7Z1OD3egFIYphjkcS7rCBhcpbIaegsgLdOWjGEtk
XHsYs5QbmvUhP3p/+mfI4RwFDxp2HgkWQNZJYbXtklQBz4MjwaC/dukgSuYpNVsJ
7rTM2QLxo1eNkcVq0RZLU2XmmZoE5eXs/ao2jPTXTSSHn+Zb8VojVGSS0/ak9bg4
ehRXvnKb9yJN5wTaAyVvXipSg+5Bk4t152PlnLSrU7NRpbffaClQ5Q53t6uAaZrV
t503uMGiubcdkM9m9f5eolTKLp5GD3L7StIzRgbNR1a9OQfuge6DVHH4FV/E/PRm
vzak8lHApGao/7/lc9SqnP1PFNb5LySHbQf4lHGqXdaafKQG3B1AS6qcqleQHRaL
Clz8H40IHCaRf7NQ5zTf
=hl7Y
-----END PGP SIGNATURE-----

--=-I8vdTwYKG3V2EV2eOoV2--

