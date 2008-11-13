Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283AbYKMT6R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 14:58:17 -0500
Subject: Re: [FYI] ar9170 driver
From: Johannes Berg <johannes@sipsolutions.net>
To: "otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1226531034.14186.39.camel@johannes.berg> (sfid-20081113_000444_962024_07ACD3CC)
References: <1226531034.14186.39.camel@johannes.berg>
	 (sfid-20081113_000444_962024_07ACD3CC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+kwS5vLcni3YZq0U4OhK"
Date: Thu, 13 Nov 2008 20:57:42 +0100
Message-Id: <1226606262.5839.37.camel@johannes.berg> (sfid-20081113_205838_337869_BDE81783)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+kwS5vLcni3YZq0U4OhK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-13 at 00:03 +0100, Johannes Berg wrote:
> This patch adds the ar9170 driver for Atheros 802.11n
> USB hardware ("otus").
>=20
> NOTES/TODO
>  * locks up RX part of the device after a while and the device
>    starts messing with the USB bus
>    (message will be "complete rx %p (0b, -75)")

seems fixed

>  * use rate hw_value instead of huge switch statement
>  * implement configure_filter

done too

> * need to implement RF, TX power calibration based on EEPROM
>    values (maybe causing the RX hangs? doubt it)
>  * already needs some code cleanups
>  * implement bss_config call
>  * implement beaconing
>  * implement hardware crypto
>  * implement AP mode
>  * implement mesh mode

will do

I got annoyed with quilt, so now you can find the driver at
http://git.sipsolutions.net/ar9170.git

johannes

--=-+kwS5vLcni3YZq0U4OhK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHIayAAoJEKVg1VMiehFYSOQQAIv17DJQbU+ivaaXF1t3y6Ez
lAUmPBt1AwuEioMHqlHKxAbEMfGKXFJe4MCdcB01LnMepiejGg9Eh0tE6+mQLwqT
G2p8tp7uy9U9gW7Zs5nffI4do41xwej0mwMhmo+f0e9H7JCGNjGxwBQs2xeQbMyW
kNdTmExKQ5+hZanKG7CQ0iRSztI8PlRJ+2v4Pe9MfzakdmWStedTOl4WeJD2bAQK
3ldrCJC7OMxXJIIbk9YueSsBc4yK7VyKuUM0xJ+vbvZWyKdmZOxdRlYE1WxqLXR5
X7mRQ9Iqwk1KtLeHNP+HXK9sTaRTa9oWq4/kRo/vnCI5ZnCa85JwSX6LwxfLeSsu
1xDGyWNk4G77zuGfsb1DODkEZocZHCyuaajmP9uofZqadRhIvX1iP1oCc/gOxHQ2
2+5wZz6SxSl1f093LWsKEGSnOzjaOT6/CPAkG9QkKzZmkc6cwQ8RodZkA4qux7q0
TdwKWdWNNW37/clK73LeaJ5E9N9CET3eGKg/srAvXuuJJOu+YfWo+xZ6tg/hD2is
STYd8Y99lvo52bYlnWJRNeEJbfQPI9s9s2JVT2LcEDw1UOnntoWggomuhV8PyzGT
/BrbzDBo/uXlNY9aPQ/JgzS0KK5W9rDLvSVxXsQ+OP6zKpjh3x2jxoyILHuvsIdx
BGpriIGyZiR3cTIibX+o
=QPKf
-----END PGP SIGNATURE-----

--=-+kwS5vLcni3YZq0U4OhK--

