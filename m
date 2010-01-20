Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab0ATSKO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 13:10:14 -0500
Subject: Re: [PATCH] cfg80211: export multiple MAC addresses in sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e891001201005p5207345es6eb1a4b196b22a47@mail.gmail.com>
References: <1263985353.2819.0.camel@johannes.local>
	 <43e72e891001201005p5207345es6eb1a4b196b22a47@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6/PiO8/2M/Z1Fa5EX6O/"
Date: Wed, 20 Jan 2010 19:10:10 +0100
Message-ID: <1264011010.11396.22.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6/PiO8/2M/Z1Fa5EX6O/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-20 at 10:05 -0800, Luis R. Rodriguez wrote:
> On Wed, Jan 20, 2010 at 3:02 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > If a device has multiple MAC addresses, userspace will
> > need to know about that. Similarly, if it allows the
> > MAC addresses to vary by a bitmask.
> >
> > If a driver exports multiple addresses, it is assumed
> > that it will be able to deal with that many different
> > addresses, which need not necessarily match the ones
> > programmed into the device; if a mask is set then the
> > device should deal addresses within that mask based
> > on an arbitrary "base address".
> >
> > To test it all and show how it is used, add support
> > to hwsim even though it can't actually deal with
> > addresses different from the default.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>=20
> Any reason to not export this via nl80211?

Laziness, and the fact that we only exported it in sysfs before.

> Can we say, use this on Atheros devices for storage of the bssid mask?

That was the intention of the mask, yes.

johannes

--=-6/PiO8/2M/Z1Fa5EX6O/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLV0b+AAoJEODzc/N7+Qmaa7QQAKn0vC8q8P6qkY07baANyLfR
Rs+9iaVAeri4qg/Cn/Sk6OBNVEW9aQGN7p5C/cWAeTGPwhkdJrmWkgD4cOX6U/bG
ERQ//GfMqXG+8fRE8ONZZgkdglVhhrk/0MFXudxynMuPia0xdNMKdd89MFRY2XqD
VuNSFAiDfxSbV2W0lWJd4nL1h7wZI5ji3Bl9GsqhlOoZUQU/Sgzi9YQac8nOhWtE
YoXWD6RWYz/s1bK9qO1YSnjyClceLJAui+b6qRRulh1V3I7zNTyroIafcyOql0nS
oWzOMlJUlQZWLTBSQc/omIqGKQSotxcH58NVJKyKsuWzfveuSPZivZW0ziUyTWPL
BoMlx/NbXUJSNht8S6EqohYOHiSAaZjmofb1exicniwoSCdqMACUgmGBlbYA4+Gb
7vyQcSfv0we4hbIDuPZezKjMnXNVlYPtTpLnMTBzCJ13YYXMge/gmd1CQpt8Wijc
JswWhTnfmL50aQV3hCI2pkoxfV8EkBpG54qkCTampW8M4gUger8UoT+xsgUnIWUv
MmopOfnVtgWL8I2Wr+uWMEaXXRggIB57TLkPNuaLt1NuQaJZ2dWyxtr5oV7m2eNq
j6Q4tFJ7UfLclo2igDWdVhdmCR2F0N1OgX3M5fGSyqx7kacASfDN8EAuMT78lMyP
/gcLjvd5oSx+arKOs5uM
=TJjo
-----END PGP SIGNATURE-----

--=-6/PiO8/2M/Z1Fa5EX6O/--

