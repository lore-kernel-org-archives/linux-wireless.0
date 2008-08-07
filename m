Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYHGOZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 10:25:45 -0400
Subject: Re: [RFC] mac80211/cfg80211: Add BSS configuration options for AP
	mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080807134043.GA5138@jm.kir.nu>
References: <20080807134043.GA5138@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WsDKxmObMOPb98t2XMTL"
Date: Thu, 07 Aug 2008 16:25:10 +0200
Message-Id: <1218119110.23048.185.camel@johannes.berg> (sfid-20080807_162548_736967_59DB3D04)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WsDKxmObMOPb98t2XMTL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	NL80211_ATTR_BSS_CTS_PROT,
> +	NL80211_ATTR_BSS_SHORT_PREAMBLE,
> +	NL80211_ATTR_BSS_SHORT_SLOT_TIME,

Oh another idea I just had, I suspect we should use these to indicate
support for the features too, on the wiphy info query result or
something. Only tangentially related to this patch though.

johannes

--=-WsDKxmObMOPb98t2XMTL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImwXDAAoJEKVg1VMiehFYiz4QAKD4m9/rNG9cJhr2xq/hr1Me
wZIFvjHQngfvKP9Xxc9/mXbCav8oyK5ev6Ia5Z4scvbFphRyeQXuntA2lumzleZx
vKHGPS7DhjxUOmsKQKM8pcjwtkRksk+S5JBEN2muIfx1UpgQOaLtYaUbQgNFfERx
C6C5oim9UnRYp6Z/NHEJPlbUc2jKf5uaiIzLp+yRkbZfWf9htdvgB1YzwSXo2veQ
GIN+U1fV9/Nb8T3VyipW0q4KBcgOLD/BnSgfCyDcZVRN2oCB649cWlbp41j54VUp
0iiCa2YXuzklfI/BoxhmvfL2DaCaD9RocnXPrXxeOteMI09N0gSmSjhVkSmkCX9u
ljOGpLwh9mwh2zrfTICw3iZYdl8C5We7NdNgkJwb9HQU0Idw732pU4N+Wx5xvOxN
lJvDEfJGQNDgFFnotuEYDgwFaI53uvZ8sq3P3WCsxfZic2o21yR0+5qzOm3X4WRO
+R1OBOI9E42gWEKuuj0FKo5ZGu8GJDPSzz2atxZcexr/zOAWBJ+EZKKZAsIT9FDr
dh92rlzyHJ0tz5nmGYvB32GDPs+4CBpiVO0qw2CBP/FTG1fqw5130g+/LiXXuwm5
jVGduxvqlBZ2flFRKsjwSU6UvEXkCJO9bU/t8KTTNqpAzT6hYe3sWKo42k+FlZZO
nOUsm3JYJQQ1AQWV6r7D
=ViyX
-----END PGP SIGNATURE-----

--=-WsDKxmObMOPb98t2XMTL--

