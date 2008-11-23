Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757366AbYKWLra (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Nov 2008 06:47:30 -0500
Subject: Re: [PATCH] iwlwifi: fix build warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20081123111812.GA15611@localhost> (sfid-20081123_121840_934709_B7C73186)
References: <20081123111812.GA15611@localhost>
	 (sfid-20081123_121840_934709_B7C73186)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-reWxFV7AdFLjqMJ/Co+t"
Date: Sun, 23 Nov 2008 12:47:22 +0100
Message-Id: <1227440843.3599.44.camel@johannes.berg> (sfid-20081123_124802_044256_FE8B6BFF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-reWxFV7AdFLjqMJ/Co+t
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-23 at 19:18 +0800, Wu Fengguang wrote:
> iwl_escape_essid() is only used in debugging code for now.
> So define it only with CONFIG_IWL3945_DEBUG enabled.

that function has been removed recently from this file

johannes

--=-reWxFV7AdFLjqMJ/Co+t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJKULHAAoJEKVg1VMiehFYhsAQAKzY1w5pTeI/IjnAsLj0RHrI
2GNtEVBEd2O8PXbMrdcKaqYYFS3EngEabnn2XLUP5Qd3CrUDq5D79I/Czp+GfSwK
0F5jK8y8ex1ufYoxalLDphclorLy7QjsGMiGTFpGk6EmdaK/dRLmVXeDgLWLfSNn
SLgSZxOBYv7ohq5K1PyAdm7hBW7dw88tD5gH4ltUFmOeNTRR4ljTi8PsRJSvKU2A
EkDUiW25ZN7mXt++ixm7OB5/QPu3rKqYSQRxhv38AP/v71Jq1exPzCDJY6C8jQRu
70h1fqadUcuaJvCNKm9lP5/Kf8eWI7QseSbgnuvvX9ti1AUg9FavhClLAGoYkUSK
/TpwMRySIZGv2ewGsed4LeSHszOxWvhEGnAWHMzvjcTuiUV65br45DCaCLRSqH8M
4NVpne66FmuNptjpM5tgCbnoRY86Au51Oz9de1KoK+FhX8rAw9iceOApG6uI4VgI
JDKBuktFyPSeQ4kclKKVBGv+Vjh/dqTjcWqFrhrIL/jAkHttLFhiL++tyAHEdko3
9K/cAH1CBQUpSkv3wXVtrcd46FDoNtlsh9HbvZeUP5w+bYPFHK5MYsWIs/KrTLAV
Ho6jtBWlWTSwsTpfp+O08Ey4E/iluOYYiMeFlCNeHcSBl0mf0cosRsuhixwmxKsZ
mGHg28JQIj6zQuIz0qVV
=XIVl
-----END PGP SIGNATURE-----

--=-reWxFV7AdFLjqMJ/Co+t--

