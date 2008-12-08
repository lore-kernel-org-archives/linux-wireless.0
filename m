Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47325 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYLHUcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 15:32:54 -0500
Subject: Re: mac80211 user space
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: igor_trindade@yahoo.com.br, Jouni Malinen <j@w1.fi>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <445f43ac0812081225o516ad4a9ye86557b720e1b81@mail.gmail.com> (sfid-20081208_212546_395656_BCBF9145)
References: <456087.50493.qm@web59308.mail.re1.yahoo.com>
	 <1228658260.22164.41.camel@johannes.berg>
	 <445f43ac0812081017q2ac6ae1h84a86099518773cc@mail.gmail.com>
	 <1228765954.22164.117.camel@johannes.berg>
	 <445f43ac0812081225o516ad4a9ye86557b720e1b81@mail.gmail.com>
	 (sfid-20081208_212546_395656_BCBF9145)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+paLlOx76aXM3HpXtx//"
Date: Mon, 08 Dec 2008 21:32:19 +0100
Message-Id: <1228768339.22164.133.camel@johannes.berg> (sfid-20081208_213257_268157_30445240)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+paLlOx76aXM3HpXtx//
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 12:25 -0800, Javier Cardona wrote:

> > That's something we can't actually simulate since you're trying to see
> > whether they do NAV updates correctly, right?
>=20
> I was trying to simulate hidden nodes, which are unavoidable given the
> distributed nature of the mesh.
> Also trying to simulate "starvation at the edges", which varies
> greatly with the collision avoidance threshold.
> But, hey, I was just day dreaming.  Even the simpler air groups that
> you proposed would be very useful.

:)

Makes a lot of sense, and you can maybe even implement that when a
userspace program is doing the packet propagation, but for topology
testing I think we should start with the simpler groups thing. And as I
said, the userspace propagation will actually need to turn off in-kernel
propagation which fits setting airgroups to 0.

johannes

--=-+paLlOx76aXM3HpXtx//
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPYRMAAoJEKVg1VMiehFYI/UQAJF6Rf8iNBYrS3+4ckhdNaDv
L3cEk030jiYXrRgn0D9EiVGZFpMmiAXDHlyr5QZFqkub8vwO6WIGYJJuNcRWu5g3
7TLK2ToPCTmiM/DpSrNQjFLCd4Hty+hucAsusgTgMUPmvbUvHL4MX+ZxwyfmiwA1
AadmU4kBBMDI2qSJxHLlTjEMspgRrZaWWqTK6g8kSDbEe2B6tFUC2IPregyGQxat
1z6tAD7gM3K+VzyLh4THeTYGVNgeQVFMohqO76nvQQMRV1Oma7w4Rmjov/4UnvCd
xDj9dfhLIg7yTdQtxPbS8p5/cZ1BwSbmHwHOoUHUnzHMGmNYcJdj44qBPB9BYYp3
UzyVgwpp0vZelBXIFaSq1XiN6Bzs+LXTz/aBevFa2vGdcrCbdmSE3d438JXSjOIP
HttSAn+GU5t97qLOw5ZGz0enRgO4nRPYDps3nLffW3JU+yzcbdUEYE4vl8hfZSPP
ggUaiPSlifrEv90nHrRuuyvLId7IFQPCes0NfnZ8Zto2xx/lDSpmmdWgTLHeAaPk
xuG5cgOcfkjLIga3L8xrMrZpe04hsmBkqE1DvTqN3fdwZBvpyhD8Naiu/V9aO5V3
YshUbjjUVTv0yJRkMCRZimVOHDKsU5i8MDbadmxCwUaRgwaL3G0ZiKND/fupyoT2
1aoJM6hzga+gE2xsmYTr
=Nw8M
-----END PGP SIGNATURE-----

--=-+paLlOx76aXM3HpXtx//--

