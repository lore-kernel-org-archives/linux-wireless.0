Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49479 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYI2KfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 06:35:08 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <1222683923.7064.18.camel@johannes.berg> (sfid-20080929_122532_241162_27D0B6E7)
References: <48E0A65A.2060102@gmail.com>
	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>
	 <1222683923.7064.18.camel@johannes.berg>
	 (sfid-20080929_122532_241162_27D0B6E7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CnDGJCI1KzqJdSkhryLg"
Date: Mon, 29 Sep 2008 12:35:01 +0200
Message-Id: <1222684501.7064.20.camel@johannes.berg> (sfid-20080929_123524_129815_BF576526)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CnDGJCI1KzqJdSkhryLg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 12:25 +0200, Johannes Berg wrote:

> I recently rewrote the handling in iw completely to make it easier to
> follow, will post an equivalent patch for hostapd in a minute.

How does this look?

http://johannes.sipsolutions.net/patches/hostap/all/2008-09-29-10%3a34/002-=
nl80211-resync.patch

Haven't tested it yet though.

johannes

--=-CnDGJCI1KzqJdSkhryLg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4K9SAAoJEKVg1VMiehFYm5MQAMAzDlMHA9Yh+YQgpp3adIqQ
3UWOEgu2kCvzmTARJQsop4QKoP63TvnptTUZG8xeJevwxh4fl+6oIvcxThs8t9os
K7pMYu6HIRNdY8iQaN2DT6sRK6sw4oFiKb2Y4hnVkj4b3OQIfVaB1oBDrQlCXcfn
/cIaOsNScSIqrDnvKABF5eg1xqNvPwYgquMgvkyEA3y8333W2C5T1Y9doY9l7ukM
Vprs7rnCoYP8cM53JRMTqq9GdcsdrH2RKRzVAslPNluI3RvXf2PF29mWBbz4oxr5
dGxTGLWHdxFD+2uKdciLYtxbm9ecyRSrgFuhbaCK0F+flI49P7mukthRKGGv392s
rkMNbO73uW2h2TkOIQnS63vWH+Zyv8nyW/m4+38u3OIIok4IKeOsbGYPUNBLnFNc
g6qkoDOHMb9EWlJUHeauvOY1vw9/CgVllsndB1pphC9cWI6CPd3A8kO/3Sgx0Aon
L+h8iVhcxxnX5jOje3zytKBMwM+cl5JNg//tF0c74D221EPISUJjmQlqvuyAoHNV
PmgNyHzpOlwozlzZGLWGoAX70oO3Y+eePlBVo08enp38csW52WynXEaaTTe4VOCS
OL33RqNW13B4bMF0w41nerqbVsCiePJ3+510FxOOI7jRD7qGJL4BxzHuf6bA4ufh
Q3u7Clw3l0E3rKS4akST
=xzBj
-----END PGP SIGNATURE-----

--=-CnDGJCI1KzqJdSkhryLg--

