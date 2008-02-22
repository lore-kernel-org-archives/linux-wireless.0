Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41039 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbYBVQaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:30:25 -0500
Subject: Re: [PATCH 11/13 v2] o11s: support for on-demand Hybrid Wireless
	Mesh Protocol
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be77ee.02098c0a.5eba.ffff81ef@mx.google.com> (sfid-20080222_072128_730595_F951750B)
References: <47be77ee.02098c0a.5eba.ffff81ef@mx.google.com>
	 (sfid-20080222_072128_730595_F951750B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-grJ3XA2px20QSQ4tVHs/"
Date: Fri, 22 Feb 2008 17:30:19 +0100
Message-Id: <1203697819.7082.75.camel@johannes.berg> (sfid-20080222_163028_634677_CC225461)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-grJ3XA2px20QSQ4tVHs/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +static u32 airtime_link_metric_get(struct ieee80211_local *local,
> +				   struct sta_info *sta)
> +{
> +	struct ieee80211_supported_band *sband;
> +	/* This should be adjusted for each device */
> +	int device_constant =3D 1 << ARITH_SHIFT;
> +	int test_frame_len =3D TEST_FRAME_LEN << ARITH_SHIFT;
> +	int s_unit =3D 1 << ARITH_SHIFT;

For each device as in the peer or in the hardware we run on? Would this
need a new entry in struct ieee80211_hw?

johannes

--=-grJ3XA2px20QSQ4tVHs/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR774mqVg1VMiehFYAQLi5Q//aSRo+xjI+gI0BtUhfeZbeDuWf7CljLCN
rPwzbhY/6SK2k7ZHWoSY8cY/6Gr0Z6GBYfgal4QeuZYrpJ8yuBATyvoFKkisXDdu
ZFNmk9GpiOoDo1cgXsFTcSCd9fb/D77cgKc/G9BaH9t03EbbRUM1RPZbkyvwtOCI
hYjTRoTWBFBWDYF0EsS+CdKTKw1geqRFCBjA/aiyVRMefpx2sM620GZ7yb5F2pMy
0ev2Kis/oU3G2ZuP1YE8tkNx+ZEtiHsDgLk3SZuwlMrMmNJDEYpnMoWEJLR1n9CZ
EamAtf5EfRkBLV4XObBZ5GbjcKomNevLU6fZzXI2IMJBb4XGJKGkqdoaPEOshnkG
oc5jwCuvESyOcmA3CpkpIAOo8len7KBQY9uTAVHcXwIKbH4Y2tJfGXvDIPzd1cGR
unEpc9tllsnVEI/u9+uXtJv9s4uG8Lw5TfepTz6wdBsipl+kE/twhOD3cdvafK7w
tn8fEKYmA6QOaHlI9U+aEv76w+1hnS+abcWJf3Qwg1CF+61o3aVPBH2yqbDpodaO
jM7pYgD4KK7hoygBNPTCCYYwzSsvd3bB8+PL4035OxxbsC8fxIU/29AoVnsQtzkE
Ehx+T4B4GsQfQzDONti3zJ/yw3z4P07pkZEqmXpJlExHoaeChuOqrqCRqdEr1Exd
sIWUdFKrgng=
=fZn3
-----END PGP SIGNATURE-----

--=-grJ3XA2px20QSQ4tVHs/--

