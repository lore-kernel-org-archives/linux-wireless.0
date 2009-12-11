Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60219 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbZLKNAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:00:20 -0500
Subject: Re: [RFC] mac80211: disallow bridging managed/adhoc interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Markus Baier <Markus_Baier@web.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <loom.20091211T133913-639@post.gmane.org>
References: <1258465585.3682.7.camel@johannes.local>
	 <loom.20091211T133913-639@post.gmane.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+ho1aeSDHsQunNvhEK8d"
Date: Fri, 11 Dec 2009 14:00:25 +0100
Message-ID: <1260536425.2442.199.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+ho1aeSDHsQunNvhEK8d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-11 at 12:39 +0000, Markus Baier wrote:
> Johannes Berg <johannes@...> writes:
>=20
> > To avoid such mistakes in the future, disallow adding a
> > wireless interface to a bridge.
>=20
> Hello,
> after the latest git pull my Linux AP stopt working
> because the system is not allowed to add the wlan0
> interface to a bridge.

You're mistaken. You _can_ still bridge an AP interface, it just needs
to be in AP mode. You should be using hostapd to control the bridging.

johannes

--=-+ho1aeSDHsQunNvhEK8d
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLIkJmAAoJEODzc/N7+QmalQoP/27uY9GPdF/oA0tB63Mz8U5c
LOw1AjLxTIQqugmxMQqEKJjwKO3/pTzegiUsHOzFJqHbPdRJb+YwWQsGOBuY3Ehd
yiGYWQ6x44pG9wyrEU66eirUgn70/jjk2TR2Hvf5eyuBGiGfowxM8pzduOFV9LTB
ehVTzuew8G2R9us0MPCciw+RrLi5Fw2yQZXpFE5WCdPc+b/+i/M8VBDgSBtxJIJM
+rUmOd/2B1Tlwshy8hx33tNDWIHfMxNWbuO78g9sJy/gqX9dcFZhJTRseKFUVmst
vCNVebHZk4TOTyVXoCoO8VA0C1qQfJXEISIB6B7VTz/vI88yBlMPNY5uqmfxKTsk
Fqlm/QJ02wX96RVa0CfJcLImUJzDjKNnVkRJ8pPKu59GFmS+4NtA8frfHyn7lbkt
YcLJLZkwpqKPKTDj5z3X2V7VRj6cK6P1F2m6d72SAIGm0ExaG4eX1ZrGhUUkXXH4
afMygDfNLEov8snTyo7IO0SX/XbUyuu/HxVxOLROgVG/7V0s3LipM+BKx5l/6lD1
QKtqNNBkmYLBBuXrPwArfwLtsGXfdC5TM+4sCrTGnRyzza6MVbxqdvx25urBlcc9
9+Rwv0Bkz+lTDtD8kwm51vW8WbwSWcikYI9drBP/F4ibcivWf2TcuzGwxKrLSnxe
3zw9q2ognek6jMr1VwE8
=ybnV
-----END PGP SIGNATURE-----

--=-+ho1aeSDHsQunNvhEK8d--

