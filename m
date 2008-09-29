Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59056 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYI2Kp2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 06:45:28 -0400
Subject: Re: NL80211_CMD_GET_WIPHY reply doesn't fit into nl message buffer
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Thomas Graf <tgraf@suug.ch>
In-Reply-To: <1222684501.7064.20.camel@johannes.berg> (sfid-20080929_123524_129815_BF576526)
References: <48E0A65A.2060102@gmail.com>
	 <1222682480.7064.16.camel@johannes.berg> <20080929102021.GE10429@jm.kir.nu>
	 <1222683923.7064.18.camel@johannes.berg>
	 (sfid-20080929_122532_241162_27D0B6E7)  <1222684501.7064.20.camel@johannes.berg>
	 (sfid-20080929_123524_129815_BF576526)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MyvjBcS3lq8BicZXG50A"
Date: Mon, 29 Sep 2008 12:45:24 +0200
Message-Id: <1222685124.7064.22.camel@johannes.berg> (sfid-20080929_124531_755378_0069A6D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MyvjBcS3lq8BicZXG50A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-29 at 12:35 +0200, Johannes Berg wrote:
> On Mon, 2008-09-29 at 12:25 +0200, Johannes Berg wrote:
>=20
> > I recently rewrote the handling in iw completely to make it easier to
> > follow, will post an equivalent patch for hostapd in a minute.
>=20
> How does this look?
>=20
> http://johannes.sipsolutions.net/patches/hostap/all/2008-09-29-10%3a34/00=
2-nl80211-resync.patch
>=20
> Haven't tested it yet though.

Couldn't possibly work, better version here:

http://johannes.sipsolutions.net/patches/hostap/all/2008-09-29-10%3a44/002-=
nl80211-resync.patch

johannes

--=-MyvjBcS3lq8BicZXG50A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI4LHAAAoJEKVg1VMiehFYa+0P/ihrDBnJbama7eRGbAAWkc5x
zZOigaAQKtbaVk/zPRXAsFTr0YMjoM40ibMikhGw/bZrJKFQwBEmhzMlVHaUMHwc
W4Lm5E/XBcoH9dE1UK31dB06tyT89gz9Zy9de9GuB0kAzbkPYq11eTXTIpx9L0kh
UBEy18GkOEAOcBma0wCThuumM20eVgzKZxOQz1qIZiZ9HWIgWkyYX3oz62bQlvvk
cY0ZRTrgmeTXCsOw/+hrgOfT9Qkkj+UuIpbIwqAOGwlhJMZg3XjhHRjmemZhPm29
hvAUa9x2h6w1tsLVoDVxjmN4VaeHs1SnyztIUue+bBNIxXO+D66n71DxsGQfEJ7q
jbGiZ2wQoXWaCY3hdwhNsLPYynh6TWI9XDslNETH3Z2l5L+IF3t6W4wuDWPJKw6V
OKCyi7f34fSt3vjDuigxeGJwNg2o9iLCyuwVvpP/7S0rTu12XYMcH+HNIVEBUIHg
abk45eztBXD/uEti8rSe6+VlflWDV/d92WNKXyoAcyeoLOaLt+bRmK1rfVba2mTZ
wKGfq0aaW7CDNl4RbjM/Yc4hBV1BEI9PM/UHEYSJ/fn2b8ygUycHBtAhZr9MMFMz
s6W5SOjCaauV7SZMFLzGyNXx40yOMLAIRQ2eZjwTo9W8+MRO6lyYA9+M+Z1Z4jhV
+Ktk8+q25zy3O5UBEWOO
=9oPM
-----END PGP SIGNATURE-----

--=-MyvjBcS3lq8BicZXG50A--

