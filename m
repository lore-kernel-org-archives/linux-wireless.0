Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbYDUJOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 05:14:08 -0400
Subject: Re: [RFC: 2.6 patch] remove ieee80211_tx_frame()
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <20080421084828.GO26897@cs181133002.pp.htv.fi> (sfid-20080421_094925_772393_0D4181DC)
References: <20080421084828.GO26897@cs181133002.pp.htv.fi>
	 (sfid-20080421_094925_772393_0D4181DC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SB0J3C6qGEfTEidWBl87"
Date: Mon, 21 Apr 2008 11:13:23 +0200
Message-Id: <1208769203.26186.56.camel@johannes.berg> (sfid-20080421_101413_925637_D4B49281)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SB0J3C6qGEfTEidWBl87
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-04-21 at 11:48 +0300, Adrian Bunk wrote:
> After the softmac removal ieee80211_tx_frame() was no longer used.
>=20
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Hmm. It wasn't added as part of softmac so must have been around longer,
not sure. James?

johannes

--=-SB0J3C6qGEfTEidWBl87
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAxasqVg1VMiehFYAQI2KRAAsuiaiZ+O0vvGTdEblXOXHTz9a8otZVCc
B94whys+PabfnU44NJVMCJALsly0aC+euo+a3N+ZgvJ9lUu3kvaZCLo4wopBGfoP
J1pxV2KJmvBf8VIJlSUKmLV6nvLNxi72zyNPhOTiGlLn5ddrG6iZNwif+5BXVhzY
kjg9jJApX1Fk6n9jEXNEfdr0Olc1SzbYD1pnIXdyXDmu2fF45dV6n4y/X96NYbmB
6AnbsBAy79IU9BtuLi3sNTuEFPEa0M78PPakijWrEQoEJFleTs6WJj0fywzJpuX2
36viH2JpztPqRRy40PjwH88aUY3X/uH+aNKBjmQ1Bo9Te4Fw8RlUZGJWM8VuRNW6
2n+DJmAON0kUudtgadN5WU17MYAo/ZmWKAfm6B8CdLYa2bFWwwRNVuOVs/z/maTx
21JGrMERP4Pw3gzmPC11btoh81aJgfZEQ8MxK1fZtU77pOiXzs2a26gq98YKlKRK
2+ty3vLh/E1lqayVRWi5FLUaXQZ3S/KvHb3pOI3e8rHWH0WsPBxlR3hPUKs0DQFy
8ADBeSWhVzVKGKGSa2sGu/z6VbejTOvwI1+ZKOC9oMG6D1Lxhqx1GsbRRr8531WX
TAEhY3sGojhfBzMWbYSdsRu2Oulkr1A1wuYpKepb7XWjz1Zh9DqLODVgbQKBkJ2R
+JcjigWO/44=
=/ToS
-----END PGP SIGNATURE-----

--=-SB0J3C6qGEfTEidWBl87--

