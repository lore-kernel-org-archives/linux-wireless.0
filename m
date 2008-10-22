Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48209 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJVHpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 03:45:22 -0400
Subject: Re: [PATCH ] mac80211: check return value of dev_alloc_skb() in
	ieee80211_sta_join_ibss().
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0810220042y43ea248qba1064a3eedf85b1@mail.gmail.com> (sfid-20081022_094238_975856_C75CB966)
References: <eb3ff54b0810220000p71a54f53ped88651b62c6d35c@mail.gmail.com>
	 <1224660978.28639.27.camel@johannes.berg>
	 <eb3ff54b0810220042y43ea248qba1064a3eedf85b1@mail.gmail.com>
	 (sfid-20081022_094238_975856_C75CB966)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-y3xadfF61JJLkRTkoHR4"
Date: Wed, 22 Oct 2008 09:45:17 +0200
Message-Id: <1224661517.28639.29.camel@johannes.berg> (sfid-20081022_094526_576148_43F2978D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-y3xadfF61JJLkRTkoHR4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 09:42 +0200, Rami Rosen wrote:
> Hello,
>=20
> Do we want to continue as usual if dev_alloc_skb() in theis method fails?

well if anything then we shouldn't do half the stuff and then abort, so
the allocation/check should be moved to the beginning of the function...

johannes

--=-y3xadfF61JJLkRTkoHR4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/toHAAoJEKVg1VMiehFYeIoP/RsfdSbwFS5f3Tox44hM1JcN
+wgU5fAb2q32Acy+ptFwv6twkqion7CvxV9F4wbawVbuptuK1vxbjYLrdzX17ybF
m+k1G82sc85IipdWRVs9IgdLSY/35UcvIaG+OYAtZn4Gq5qdlYdy65IODukO/3OH
WdJVRDnAA9xXZTr7vqdCPmrcSCqscLoRLkPNTnWfT6oO9YupON11L2xW6K+1gyI2
9Ggl+97R94KDoFjnNB8XEHXS3RztAC0TFA3nTILHo1oRUKITOJDEsKp9uD5D7QcS
Ejadz0fAUrgB9pae0Swm/oMGB+oUQKbtDFZjdcqThCCUlk9odr9J82Obxnnti2yZ
zmBR2miNIU1jWCcir+ZrmL8kfVZGm3BFP5Chyc82cc/exIpRq8JYCc+xOIgPluih
6TNVJ4K0xyjZbkFtSZ960W38eynY2FrktQNbLtmfnTUv4Jq18w1NOxCb9OniXPNI
c5tWdAqBCtGqcKqeRVhiRgeQXCaYHZiVJLvQuwR2o1JkEaBt2IqNyDoRsAmgjGhQ
jh9TtfH6dGwbU+iimisCEcVFgyv8wYHPEWGz2j4Z+OI/H7XGQ5sw8kp4NG77NtGN
XOHwIMoEFlj6DhxLcyLr+XpkVp2hzoXLmTdL7fbH0U3cNqvsF+C9i6tPEz98i3sX
+RYUwdtipHo03t/S1vQs
=i1Qc
-----END PGP SIGNATURE-----

--=-y3xadfF61JJLkRTkoHR4--

