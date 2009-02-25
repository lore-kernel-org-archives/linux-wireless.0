Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbZBYBs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 20:48:29 -0500
Subject: Re: [PATCH] cfg80211: unregister ml groups on failure
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1235524450-22624-1-git-send-email-lrodriguez@atheros.com>
References: <1235524450-22624-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pEhexXGXFtM4fwwhthUs"
Date: Tue, 24 Feb 2009 17:44:42 -0800
Message-Id: <1235526282.28635.0.camel@johannes.local> (sfid-20090225_024832_410467_E93CC6D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pEhexXGXFtM4fwwhthUs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-02-24 at 17:14 -0800, Luis R. Rodriguez wrote:
> We were not doing so before.

and we don't need to, they get removed with the family automatically.

johannes

--=-pEhexXGXFtM4fwwhthUs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJpKKIAAoJEKVg1VMiehFYAqEQALICRohEKZIBOSRZHgFCQ2Ka
lOzGfi1ZAXQ/W4gTrko9Yve6X7atKsm+FCXfjLRKQm6RewnMkSPCiuByrYqDFr20
yPrSwA6c6EIyelnvyV6njZ4G7MnUBMgzM3o0/X22waXRnmYqoKbpUdGoP/rt248A
vVQzJgy36lja/HoRcqFTnCFN49x9q38L57cDa97n7bFRReRMPZ1SEjjVKwMGEWDP
YnaZ7ceWT23FCwOxw3hpjxPGeRQBYa6gfHWmrJqqZxZcWYqEn+5o6b78qXOV69ak
J3IHZdTP/03ZiiFZ1gepc+Sx1mhETMF9J7P9Ucd8UcrO2cRmtg5No2uuf3l9D3wR
OJIdN9zXYYLSEIVs+cBWeBUCGnA1jD0FkieawVBGretZ5lIan/dnELy+ZnW06b0m
VE7IePQ7zX7Ppq00w9GnrckOYGn0Lek29h7y57Z7SaFXj41NcL+TO1AQXS6+5B4D
irU0xId0fws47jGSjE9JG1iOTStWBcstGetmUq8y9b8W61JQdLPCl7wHP2cj4ERm
DmhJ/PNG9sqfrR26nLryUYUfR7SrKnz4QFlU/gfJxeuEBfCAd0Br9MzO9BXIsu+0
u3VN2JgxSuJt5u1OxoUDAyxI5LGs0JIk2RfB5xht79uVApkAkt8EVoxCY873IB07
7zpH/nkMWqhCMtp/j/4q
=vQKd
-----END PGP SIGNATURE-----

--=-pEhexXGXFtM4fwwhthUs--

