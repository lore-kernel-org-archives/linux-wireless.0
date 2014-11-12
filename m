Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:53255 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228AbaKLS4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 13:56:38 -0500
Message-ID: <5463AD5D.6060708@telenet.be> (sfid-20141112_195641_440553_E76588AE)
Date: Wed, 12 Nov 2014 19:56:29 +0100
From: Ruben De Smet <ruben.de.smet@telenet.be>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for someone with BCM43227 and (maybe) compilation skill
 ; )
References: <CACna6rxVjnpMgQx9+d_LbROYNnnjnuMEGo-38MPwjsPtxYdN8w@mail.gmail.com>	<CACna6rx+EkoCPQ06qDTbaDFEJ1hrn_CYSbrPmosF0ikhkqDxpA@mail.gmail.com>	<53FF21AA.5040406@telenet.be> <CACna6rwde+H8K42FgsHH=FT2tW_3o_NwVbk0ZyM_L3fVtfwAsA@mail.gmail.com>
In-Reply-To: <CACna6rwde+H8K42FgsHH=FT2tW_3o_NwVbk0ZyM_L3fVtfwAsA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="j2jJCMWXi0xrkJRd7ksArAKGrRbGk7MJt"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--j2jJCMWXi0xrkJRd7ksArAKGrRbGk7MJt
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/28/2014 02:39 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> It has appeared that BCM43227 and BCM43228 are pretty much identical
> from programming POV. You can try 3.17-rc1 (or newer) to see if it
> supports your wireless card :)

Hi!

Today Fedora 20 updated to 3.17 and so I was pretty eager to try b43
instead of wl. It didn't work like I hoped it would; networkmanager was
able to scan but not to connect with my BCM43228.
I've ordered an Intel WiFi card some days ago. So if the b43 team wants
to, I can send a developer my BCM card for free for developing, reverse
engineering and debugging purposes.

(I googled an excerpt of the dmesg error message (because it had a MAC
address in it I didn't want to give to Google), but I forgot to write
down the original message:

deauthenticating by local choice (Reason: 3=3DDEAUTH_LEAVING)

Ruben


--j2jJCMWXi0xrkJRd7ksArAKGrRbGk7MJt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUY61dAAoJEPgmWogSE9wQzKAH/R68dTmFgG3wrgC5ReFAY3I+
8SwEXaIIB4XwsyzQJs9LxlyD7YHoVLV9JvfUi0VG3QhAWvprnQQ7UATB4tIKdkFH
3iOp9DFxVoyarAWZLK1qOdRDoa7VSp6PGLbgvLbhyxfr5N16Sa2MGHaOlooVy6cK
+BoQIvTDOM9RtH8ZQ3R7HR4Y8LuQS+HoHQHEi6aPhVI0bNsJrPWQA+YCJo+Arkd6
kWEcL9glmqvasXRMdq6OGaiZTgRctRUdK6WYC2Jk+GXDvuTb8f8elNniE0ZTYcUx
mHkuY0aoyuVQm3ExH+fkqwZvR9ImbT9WPPO8Dbl9piF5HtBuho6j9y0e/ZGT1og=
=RUqY
-----END PGP SIGNATURE-----

--j2jJCMWXi0xrkJRd7ksArAKGrRbGk7MJt--
