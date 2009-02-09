Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52359 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758237AbZBIUDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 15:03:06 -0500
Subject: Re: [PATCH] mac80211: reject extra IEs for probe resp when hw_scan
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1234209631.4175.242.camel@johannes.local> (sfid-20090209_210133_384668_7BC4C69F)
References: <1234209631.4175.242.camel@johannes.local>
	 (sfid-20090209_210133_384668_7BC4C69F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8NEWgLGtQV9CUChyJ9LR"
Date: Mon, 09 Feb 2009 21:02:34 +0100
Message-Id: <1234209754.4175.244.camel@johannes.local> (sfid-20090209_210324_781597_A0DEA8A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8NEWgLGtQV9CUChyJ9LR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-09 at 21:00 +0100, Johannes Berg wrote:
> We cannot currently hand off extra IEs to hw_scan, so reject
> configuring extra IEs for probe response frames when hw_scan
> is set.

Umm, that was screwed up, should be in probe request! Ignore this patch.

johannes

--=-8NEWgLGtQV9CUChyJ9LR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJkIvXAAoJEKVg1VMiehFYWAEP+wZ4lZ7pfVELF8fmnIDe6xX8
eFXl7hCMiTjVxUYBl4Zcw6SlAo0XPlr3Uof4ucEJHLeLOazSAx43uGFnY9yDbsKS
2yjZA8zJ/UbBpAWH9VGwpv3fNB0paU17cMHTNM2cDR1kh3+xX0+ZZZZ27GRtceW0
wvcevhIhL2fXVnzf+YnT5VEhv2g7REHHh0nJVJMVFa3QrXaFGO+EePlLpTuzBsih
CJ3zP6PAfEI5C7oDyFm/FQlMj/1IS9TPBfy9TTYXWX+fEk59lWzMdjcakjxO4Ohe
bpMIh7iRgsoY5vDcg9DyeSibaseGtkVHmhDsAZBWM+Izm67q79eeHkqlQZdKR4Bf
QF4P6TRCU2fo7BMfuP7GSSbhPk0LCuZC8FNpvHxo7sNzN36CdGmShy8GLUZ/Rjrr
qxG1U+15wD1OcxIEpS1Hf+SNaJTFgO2X2VvIXjQqAjKa/3vRVbVOw6HzWRfYlMcC
ufPGC5LsMiYEL8B3c+FChVGtL/sUjAfbgifu5whgoBdV/r98aE5hVeu8WZ2u+3Z7
xjF9kYCJWkNEnuMP99EUFe9ymk1S3y2cHzr4LN+HqR10hCXIIuAgvu4yFyKHEKeo
ioNekAG8eohzKC1hK2C6U7dyR0N5bFjL46HoXjHLsVzgfuG2xlQGJkA9G4CWMUej
ZR+SM9wlCGurdOA+HRPM
=LAkx
-----END PGP SIGNATURE-----

--=-8NEWgLGtQV9CUChyJ9LR--

