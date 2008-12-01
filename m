Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYLATeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 14:34:15 -0500
Subject: Re: 11d segfault
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1228145195.31158.137.camel@violet.holtmann.net>
References: <1228129742.3478.2.camel@johannes.berg>
	 <1228145195.31158.137.camel@violet.holtmann.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1JpYfoc6yFIXUmI34lYo"
Date: Mon, 01 Dec 2008 20:34:12 +0100
Message-Id: <1228160052.10627.33.camel@johannes.berg> (sfid-20081201_203419_568438_5067AEC1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1JpYfoc6yFIXUmI34lYo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 16:26 +0100, Marcel Holtmann wrote:
> Hi Johannes,
>=20
> > Dec  1 12:07:00 johannes kernel: [  193.370168] Unable to handle kernel=
 paging request for data at address 0x00000000
> > Dec  1 12:07:00 johannes kernel: [  193.370180] Faulting instruction ad=
dress: 0xf2794560
> > Dec  1 12:07:00 johannes kernel: [  193.370194] Oops: Kernel access of =
bad area, sig: 11 [#1]
>=20
> are you running kerneloops? If not, please do so :)

Heh, I don't think you want to see all the ways I manage to crash my
machine ;)

johannes

--=-1JpYfoc6yFIXUmI34lYo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJNDwwAAoJEKVg1VMiehFY2nkQALRuQExJ/f8TRkrsIO3j5v4c
Iam+KZc2mtlXYzpt1LE3r54zOJXMl0YxDWho4lp9C52L2EEAtEkYFVU6lG6vEnnJ
slzHBXLfORKzatG6u8TQzaM7SsF8orNcYb1ytifbAIUejRM31vjOerrXmGFHhR/P
rhUSOnO9hbO4maBMGw8r1ZZPT8kZl8vGaikSx64JlMCaGjoM3fJAQTwNd9losPTU
4i8OJzd4OqXqJt3W7eUa0qImcdhYJg5YuXsJF+PQJPTU+LSi6toqd4/yNEatz4JR
kUBtGrc79Qh628txcKjjKAnG0C9awu56i2glKBBvJZfx9Ph4Xa3jco80SBAmtL2d
ovolKp4yQlr6iCQxA8qI+hrRvILC262cY33P4gE5bYORybUwIbgJtxsweuYb0Ob9
DoDxMLN6QBa+nY746sk7KSzSkhpKnw03glFIOjcf+VdzM6DsgZTW+KMlnwCHOCyt
RYOD4lzUXxnEyinn5zrebw9Oy2m7F7qQIzKDSHj5Nehg1IXLlEdwxHIxldLVwbzr
TijLZDsMs18zLkxddgtVqmqXFu+AZPKrM6rOC3lQRORTkvwriuAtqvvADSmu6mGw
IbcG7JVnFD0a1VjuR7KkEnZEdrGjTyLVJFGl2lJ/skyowqaGsAXLeQ0hK+wEOyTg
ReoqangCswX8jmce3yss
=CJxM
-----END PGP SIGNATURE-----

--=-1JpYfoc6yFIXUmI34lYo--

