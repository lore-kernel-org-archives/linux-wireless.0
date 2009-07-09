Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37535 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbZGISPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 14:15:48 -0400
Subject: Re: nl80211 and wext interoperability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890907091053s59ed356er22c59944efec9a01@mail.gmail.com>
References: <1247139797.2144.27.camel@johannes.local>
	 <43e72e890907091053s59ed356er22c59944efec9a01@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jn7cFEQAPIwqT1azlcyw"
Date: Thu, 09 Jul 2009 20:15:42 +0200
Message-Id: <1247163342.22527.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jn7cFEQAPIwqT1azlcyw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-09 at 10:53 -0700, Luis R. Rodriguez wrote:
> On Thu, Jul 9, 2009 at 4:43 AM, Johannes Berg<johannes@sipsolutions.net> =
wrote:
> > Hi!
> >
> > With the recent work I've done in cfg80211 for nl80211 and wext, we've
> > mostly removed wext code everywhere. The only thing missing right now i=
s
> > the key support, and I think then we can declare cfg80211's wext compat
> > layer pretty much done in terms of what mac80211 had -- orinoco will
> > need the sensitivity (or AP density) thing but I'm not sure how we
> > should do that since it's a value that is hardware dependent -- we'll
> > need to have very good discovery code for the allowed values (unlike
> > wext where you can set 0..3 and don't know what that means). Anyway,
> > that wasn't the point of this email.
> >
> > Currently, if you use wpa_supplicant -Dwext and -Dnl80211 mixed,
> > -Dnl80211 gets confused because -Dwext will set a 32-byte random SSID t=
o
> > "disconnect".
>=20
> When do we disconnect like this? Upon initialization of wpa_supplicant
> -Dwext -Dnl80211 ?

When you shut down wpa_supplicant -Dwext it does that.

johannes

--=-jn7cFEQAPIwqT1azlcyw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKVjPLAAoJEODzc/N7+QmazZkQALIPXH+PZ3a/r3eoIjlQxomh
woS+wDCJ7PkyOMo80N1AWklkwECq6pWnCuLREoOPXi6V9LrgIYG2znyYtQjQp9/E
HxMhTQ5ZZyPA3FWep7GNnvn+9EsCeY6nU3DghpzciFv9Ajvcc8cmUnw97CY67K14
8fByrWu6dCySIqAYR+oZsnT4HEVCl/dmFTW+054f9ZOTrOVc2DvyCfwZlpssE7BC
O2wuewdkp0ZuC4JlhSoiyUSeYWwsJjTbb0+lBtc9KW2AGK7iqhkx3zOOd+I/2Esg
tp3VNdPxwZGI4JHz/jMqt/I8shDRqZAZDC3FousRozxsPU+3D4GTFS4drBfdnr8G
D4NJru0RtHGFdn6d5OrCdV67lMWlESE6dfUECtiF98rwpzIxEQZHj8+1xtFmrIGE
Ox7z0ByVqbn+7gyd6lRq9SHHtk4wOzFCgMK2OZLhsDF4chokv/aGGqZxByZi0u0Z
DaWjp4DbocNXqpY731iKtKS8/EgriTR6tmu8541OM/1zfqfOP5cwgBunoT+Tv0os
28QOosNNsUGp3xWW0JU+lS+P1cVRynrQsoFYxQGOyMu9KOLO32NxZdQbNInu+1o1
9D6rNGq/TmSkqY7g46Lq/WivLOxBlM3FWp5xGS2FObQop/o22IVfDWwcHNECg2yn
D7mIfwZL+M/9sPgSnHx4
=TZ5I
-----END PGP SIGNATURE-----

--=-jn7cFEQAPIwqT1azlcyw--

