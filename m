Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758187AbYDGOgI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2008 10:36:08 -0400
Subject: Re: mac80211 hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200804071626.37799.IvDoorn@gmail.com> (sfid-20080407_152410_751293_81ABF326)
References: <200804051931.58895.IvDoorn@gmail.com>
	 <200804071610.47598.IvDoorn@gmail.com>
	 <1207577549.12481.24.camel@johannes.berg>
	 <200804071626.37799.IvDoorn@gmail.com>
	 (sfid-20080407_152410_751293_81ABF326)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X/F1HTsvhbriScXoDp0E"
Date: Mon, 07 Apr 2008 16:36:03 +0200
Message-Id: <1207578963.12481.27.camel@johannes.berg> (sfid-20080407_153611_379363_13797761)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X/F1HTsvhbriScXoDp0E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Ok, so just to summarize (so I have everything right :) )
>=20
> TX path)
> rt2x00 sets the IEEE80211_KEY_FLAG_GENERATE_IV flag
> grabs the IV/EIV from behind the ieee80211 header
> memmove ieee80211 header to remove the IV/EIV
>=20
> TX done path)
> memmove ieee80211 header to make room for IV/EIV
> reinsert IV/EIV behind ieee80211 header
> call ieee80211_tx_status() for mac80211
>=20
> RX path)
> memmove ieee80211 header to make room for IV/EIV
> insert IV/EIV behind ieee80211 header
> call ieee80211_rx() for mac80211

Yes, that looks right.

johannes

--=-X/F1HTsvhbriScXoDp0E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/oxUqVg1VMiehFYAQKfmBAAtvEbl+w5JhjvpaT5aaBOinrO39Ahx+UC
az9Ml+NPqhVsYgIQ8ISRT7p4OiKUb0y9GqHdX6K9J5R0bx97gJ/M9p+1lqNKbFWx
G1QWsek7nF6/5LabeTxd+hsRRreDLHh/PjR+TRxebYFTSVigHtDUNB/xlM7wBLZc
UrPwRKFjsfEXZAY89/2YPdNyJMYoZOU7GXjMp0KBxagCLNwUU9E9frhLX1MW5XGV
9MbXwLAuofh+k3eQtndWbMuKHc9rk3uqzh5KGBv5UDakFv2w6dbzjM/GWzbO/mit
UbxIWaYIiVrV9E9SwV8WWJ5h3EBUg6Fx3tbf6XUBjJPd5Z3CwM0H2VC9ZRVUlb89
rpNsynzvceF51p5ybH8zGnjg3XMRa7GeNS/QBSWpocNWnqN0LGeLpyeQh5pqfpy+
hy82NBUFrHGxRMi42O0ZZueKfmRxKjBKZzp44OcmlR/6qxitpghf12obqhQdL84X
vr70SnSddyD4itVUuyarQWeiwvbs2+N7cyOmav9CKDxUUWEVkf/4QeToQZ5hV9Ua
DSFLO56ULQpzN20+0ojjAvIRZ5YgBHwI5rWC/35mt6RaG/sc5QgC8s4/Hrf69BP7
h8+WHXzkdRSkQqNZS1ex373CarhWncsDZArR/f+EW9ftSCXQCKYIQlHSRBup8Re4
UogSSvqvh/g=
=uRM9
-----END PGP SIGNATURE-----

--=-X/F1HTsvhbriScXoDp0E--

