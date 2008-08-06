Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964893AbYHFPnG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 11:43:06 -0400
Subject: Re: [PATCH] rt2x00: Add module parameter to disable HW crypto
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200808061806.40006.IvDoorn@gmail.com> (sfid-20080806_174135_651759_33254611)
References: <200808061727.32096.IvDoorn@gmail.com>
	 <1218036145.23048.8.camel@johannes.berg>
	 <200808061806.40006.IvDoorn@gmail.com>
	 (sfid-20080806_174135_651759_33254611)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WISzxfxCEn8Jl4uq4Sco"
Date: Wed, 06 Aug 2008 17:42:29 +0200
Message-Id: <1218037349.23048.14.camel@johannes.berg> (sfid-20080806_174317_342063_52BFA43F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WISzxfxCEn8Jl4uq4Sco
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-08-06 at 18:06 +0200, Ivo van Doorn wrote:
> On Wednesday 06 August 2008, Johannes Berg wrote:
> > On Wed, 2008-08-06 at 17:27 +0200, Ivo van Doorn wrote:
> > > Add a module parameter to rt61 and rt73 to disable
> > > HW crypto. The option should only be checked when
> > > determining if the SUPPORT_HW_CRYPTO flag should
> > > be set or not.
> >=20
> > I wonder if instead mac80211 should have an option for this. It'd be
> > trivial to simply not tell the hardware about the keys.
>=20
> Then it probably needs to be a per physical interface configuration optio=
n,
> which can only be toggled when the interface is down. Because I don't thi=
nk
> you want the option to be global for all available physical interfaces.

Why not? It's mostly a debug option anyway. We can hide it away in
debugfs per phy, but I wouldn't really care if it was global since the
driver isn't supposed to be broken :)

johannes

--=-WISzxfxCEn8Jl4uq4Sco
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImcZhAAoJEKVg1VMiehFYrVwQAIl/VF4Hm3YiPh7pksA/a+xJ
XU29k4/EwNY57z1wCw6h8GtfqWYTLKPTNZA0qis99v/xOWRX2274kNpIyH7Ggrg7
P/XJuS6OK9D/yUSW63QP1jJrsKRM1JZJ4LDtg5/j5ABpwwxLw5fDwoocFvDjLpMy
JEv75+kMwfvzCMJ00Lvjk5vsTDHPmcJ+Q6NZRqU2dTHcMkI3DXM6qceCzmVUb7GB
SNfX81FrNExzUFmMTnQFLNhw44IDCJC7GVNmp0SWbWpCdsVd9Ajb4G/UbomZ2e30
QhwsSfz8/C1VUywd7v1Gf5hCPsV76EawCM9DcXROyqvTPvIroYMCz3GLUy4KvCP2
Qa/Beqhmwh7lF8uxQrg9rWnlQ62Q7MAFmNzSybAZ1Q2qgSWVhViJVp3RbOcC1GuD
DDl5ec7XVXqW0MlS2ozaoYrynwvjw2bz7GP9/irc1QDUF7iRwM6UrD/joL5cKIut
VTgG/hsXOuxe9c30EV6mL/pwAhX8xDFTXlzolHFm2hvBPILDyiqqF9U3Z68aHIcf
qoCxl8YXOz73XwWEiB4tNEItOP+9ZMtOlhS3LqOz1h4Lcyr0mGNvZFbUswbmfHQn
nLYxkiIcJaeUsJTlyp1qsuhRVcWJb4Spog0n5oMsSg58cHOLdM2LqZOFCsQRJlYF
ThMg2bWtkZw0UT0Keh+x
=Pf8M
-----END PGP SIGNATURE-----

--=-WISzxfxCEn8Jl4uq4Sco--

