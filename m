Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYBYKHO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 05:07:14 -0500
Subject: Re: ADM8211
From: Johannes Berg <johannes@sipsolutions.net>
To: ptb@inv.it.uc3m.es
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net
In-Reply-To: <200802242157.m1OLvS429023@inv.it.uc3m.es> (sfid-20080224_220312_353058_4025F8DA)
References: <200802242157.m1OLvS429023@inv.it.uc3m.es>
	 (sfid-20080224_220312_353058_4025F8DA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dNtaKYczR3pm6UWTJg+w"
Date: Mon, 25 Feb 2008 11:07:07 +0100
Message-Id: <1203934027.13162.60.camel@johannes.berg> (sfid-20080225_100720_012562_43D37C6F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dNtaKYczR3pm6UWTJg+w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-02-24 at 22:57 +0100, Peter T. Breuer wrote:
> What's support like for the old broadcom pci ADM8211 card these days?

It's supposed to work, but clearly I broke it ;)

>   [590632.640345] 0000:00:0b.0 (adm8211): Channel range: 1 - 13
>   [590632.640463] 0000:00:0b.0 (adm8211): RFtype=3D1 BBPtype=3D1 Specific=
 BBP=3D0 Transceiver=3D0
>   [590632.640535] WARNING: at /usr/local/src/compat-wireless-2.6/net/wire=
less/core.c:267 wiphy_register()

Looks like I broke the registration code.

Taking a look...

johannes

--=-dNtaKYczR3pm6UWTJg+w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR8KTSqVg1VMiehFYAQKm/A//aYpfNPdWKhh4KnwsxFnfYCdfcLZC8gtL
94M3u3KxF8aQyzVuJoQ3Gjayc3Ok7CuvYx4jRZizClPzAEGp5gcYi1331HTy3jFm
pBW8xKMO+ox30JxCiGKdolq1XN3LquV5x+Tp/ZAqOWkXE6Hs0VmC5EG6atMQYWzW
SJ4UNjOEvjsmUtCo+Eblp5RbtOcqNwwmuc1PDQllDvLBM+PWc7Al219RqoYHq73A
7INiHQi3x026I/FgxL2JGVEpCV1NGt2zEyJaVutvkB9xYWcpksllrdeEyhFcc6au
wNumD7Q30jw60qXDarb4PlP1VCn6p+iH93dT6qkW7UZA4mMTgrqeIAPFEdHNZBnL
DPzmjjrvb/kXPiRPfbuWck4i/38dfI+iv/xszvxc+JSykOMak1HDeKVooI3X/012
tqLIYlWbHxhjKrtihsP5jsYtihw7NeZM71R0fO6tHDtaH+Ml6AhDM3OA7XCcSGs6
FTmkYmBohsxly8eGUgE8mLuAaBYklDdNgFgYIFxjUME/SzOLrmj/I1TflTjG//tJ
rRiNyLqwf6tDWyQF56sxV7z1OztB5OqnZpG0ZnNuPO1nTavIlknh7it3Xc2v7dxJ
W7I6s4+neiENEazRtHeDAlJeM5U6XtTl1o6zTaPaNqS9asP/ImNrPGGfS0TmZUA7
nn/4dSgbV1Y=
=sfjQ
-----END PGP SIGNATURE-----

--=-dNtaKYczR3pm6UWTJg+w--

