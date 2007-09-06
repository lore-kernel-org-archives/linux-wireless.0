Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbXIFLy5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 07:54:57 -0400
Subject: Re: [PATCH] hostapd: use nl80211 instead of prism ioctls to create  interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070906023824.GK5273@jm.kir.nu>
References: <1187987850.24933.29.camel@johannes.berg>
	 <20070906023824.GK5273@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-noNESwFe1lXcING8NBjM"
Date: Thu, 06 Sep 2007 13:54:24 +0200
Message-Id: <1189079664.28781.52.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-noNESwFe1lXcING8NBjM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-05 at 19:38 -0700, Jouni Malinen wrote:
> On Fri, Aug 24, 2007 at 10:37:30PM +0200, Johannes Berg wrote:
> > This makes hostapd use nl80211 (via libnl) to create/remove interfaces.
> > Also lays the foundation for using nl80211 in hostapd.
>=20
> Thanks, applied.

Great, thanks.

> I haven't had a chance of testing this yet, but at least I'm now back in
> state where I can build everything successfully :-).=20

Good :)

> I will be traveling
> next couple of weeks at IEEE 802.11 meetings and will be very unlikely
> to test this any time soon (especially so, taken into account where the
> meetings are this time.. getting two meetings on consecutive weeks and
> on two Hawaiian islands is quite a nice combination ;-). Consequently,
> it is probably best to just get this in now and we'll fix multi-BSS
> things later, if needed.

Alright, sounds good. I don't think this breaks anything but I don't
have a mac80211 based driver that allows multiple BSSes and I don't have
all the radius stuff set up for VLANs. That said, I tested the actual
nl80211 interface by hand and it's working fine.

johannes

--=-noNESwFe1lXcING8NBjM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG3+pw/ETPhpq3jKURAv2yAJ9Ib+z2uL+6U5gxfrdFw7xRdhr7vwCgj375
YVii0ZKsbullNvyyFlUThs4=
=IM3I
-----END PGP SIGNATURE-----

--=-noNESwFe1lXcING8NBjM--

