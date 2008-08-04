Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36140 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbYHDQVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2008 12:21:13 -0400
Subject: Re: [RFC] cfg80211: add PM hooks
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <99AFB2EC-AECE-419A-B014-8391E45DF6C4@holtmann.org>
References: <1217853236.4721.32.camel@johannes.berg>
	 <99AFB2EC-AECE-419A-B014-8391E45DF6C4@holtmann.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tsexoMf+HUG80X8Utdn1"
Date: Mon, 04 Aug 2008 18:19:25 +0200
Message-Id: <1217866765.1299.9.camel@johannes.berg> (sfid-20080804_182116_372496_CA857B9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tsexoMf+HUG80X8Utdn1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 18:15 +0200, Marcel Holtmann wrote:

> > +	.suspend =3D wiphy_suspend,
> > +	.resume =3D wiphy_resume,
> > };
>=20
> this needs to be wrapped into CONFIG_PM, because otherwise the build =20
> will fail when CONFIG_PM is not enabled.

I thought so too, but then I looked at include/linux/device.h

johannes

--=-tsexoMf+HUG80X8Utdn1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIlywJAAoJEKVg1VMiehFY5BkP/15yl3eOGD4uGQ/+PXEmvDgf
IVIykdRQpuY0ZTDq3WoWewG2lggyaphj9DJRaV8NkYMT85DGOoAvLmJslWqxznNL
qcoXGSyUJXgqfRkHNrLPVhY1B3Mh2ttodhh3FVCpyLK9wVb/OkdBy2xeDzoHbrcY
Vthmkoc5eqWK58w6301JVhKpziXjoRj08uTD0LjNt2ky5oG1GVrUKabHDHkv8yRU
TFGJFGSZBnc3Bj/YBVLaQTh3JmzBKkEB4TWq+S4tpWefNiQMywWTQDH/Wcrfd4dH
jtwqbn8hjOZKYNVEXKsRUj/PIog3gYu/Ajj/FvfwN6wam2/ZTo7P+/bSBcyvu5sP
1k2X+t59wr73mbzUm2COWnkLjLZAS58qRlg/FTwWjZJJzr49YtpFBq0pdJfwbb8h
CDaGo6OHIfoz7Z0zQNyJEAxhp3YmrPUEMAY1MJje3fkBazzp2JoLQpBQpT3pjRv/
FZuaZJVtDi66DTcmsDoirhd4g8PIDIIMlXerLo2IrOtI5cknqaqkDGGFZztkmpe2
ir5+eomKDYUYNGhFYRmxQ83uUpd2IzcDITnomeQOZLotDJLNfrbxC2BAIl89mY2N
iQZT3AFMeCHijmBBE7eUrMMEK7lTF9jVfgQTkZGunnKvITEcFGeOam+pgJa0z8tN
Wj87d30dO5oyFW1pNsKT
=f3df
-----END PGP SIGNATURE-----

--=-tsexoMf+HUG80X8Utdn1--

