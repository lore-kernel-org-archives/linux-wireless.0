Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57116 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbYJVIJt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 04:09:49 -0400
Subject: Re: [PATCH ] mac80211: [RESEND] check return value of
	dev_alloc_skb() in ieee80211_sta_join_ibss().
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0810220058h281e2008h7bba7f756c795ae3@mail.gmail.com> (sfid-20081022_095842_068521_A11FD88D)
References: <eb3ff54b0810220058h281e2008h7bba7f756c795ae3@mail.gmail.com>
	 (sfid-20081022_095842_068521_A11FD88D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Utky3uYSdhwtjxRIoCOI"
Date: Wed, 22 Oct 2008 10:09:42 +0200
Message-Id: <1224662982.28639.34.camel@johannes.berg> (sfid-20081022_100954_202130_DF4E326E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Utky3uYSdhwtjxRIoCOI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 09:58 +0200, Rami Rosen wrote:
> This patch add a check on the return value of dev_alloc_skb() in
> ieee80211_sta_join_ibss()
> in net/mac80211/mlme.c.

This looks better, but why the line break there? :)

> The patch is to wireless-next-2.6.

That doesn't belong into the patch description. If you're planning to
send more patches, you really should work on getting them inlined into
your emails properly too.

johannes

--=-Utky3uYSdhwtjxRIoCOI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/t/DAAoJEKVg1VMiehFYV3IQAIAe8jjE5gLxB0JtYAE9K0Yf
kTXimRnWY27lu7c/oTUn2X35txHve1fYS6P2HLHvdrBx8LEPCuYDZCf+olwYEFle
tGKt2jjbmnt6kTiwpro7mCS/Ce/TjV39qQql7F1br5E5HkIlJ1Im1z4HUU/GwAcc
zTcsOHB4dkCZEI8ME6G9Qq2QJIcyRo/Y3j+jWIz4adE7Klb0RNGSYA4poq9+J8y3
/EMZ0jkZTWjp8NStt9rHr+KQFvqb6B5S5v3ESm/y/7N9oFWCXXt8EShKrUibMeGW
ZNrchtYWWEl2RrM16kyPoy2IpUVTeWAb+kZrCfYWo94RIwCFsPaL1JDlsZeR+TtF
AQnPZJeXTAx+JxPOIQhXx95jSqSeMqXkMUwJq//V3Y1639GzG8FzjPA7oqDRRWUG
Xac5xon4a8u2Sz4pT8Qn2BrWwikDsJkbaigBddcyq92u+t8/whPZK0b0vGH2dQa7
mAwc4RjRuZUtGjklpEkPDkneTz0I3XH4kDoz4x1P1ECC3s2L7f3XnrWzkd3ae5o2
UkbY1peCawYICqXspJUruT2FajAXn9kflKfuO5NXHsgvbtY4yn77zlZzGpDFAapv
QZGCyk1Gjx/m4/36GzTk8UOgcGRIZ6nd4zr6p2gkYKtsoddp9f/ETjWTZvEuzJrQ
3t7+U46TuiKe3mjBHRX0
=Ttr7
-----END PGP SIGNATURE-----

--=-Utky3uYSdhwtjxRIoCOI--

