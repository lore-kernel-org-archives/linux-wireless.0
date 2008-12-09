Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60522 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278AbYLIADW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 19:03:22 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: Dan E <trg_info@mailhaven.com>, linux-wireless@vger.kernel.org
In-Reply-To: <493DB351.6000103@erley.org>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/6eVLzumRw56hRHr6buP"
Date: Tue, 09 Dec 2008 01:02:40 +0100
Message-Id: <1228780960.22164.162.camel@johannes.berg> (sfid-20081209_010325_600288_EEEBCF9B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/6eVLzumRw56hRHr6buP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 18:52 -0500, pat-lkml wrote:
> Johannes Berg wrote:
> > On Mon, 2008-12-08 at 18:18 -0500, Dan E wrote:
> > There's libnl 1.2 and 2.0? That's news to me! Patches welcome. Sorry, I
> > guess it needs 1.0 or 1.1, will fix the page.
> >=20
> following is a patch that gets iw working with the development versions
> of libnl.  I keep it uptodate at: http://wireless.erley.org/
>=20
> The Makefile changes may not be the 'best' way to do it, but it works
> for me.

Thanks, I think you even sent me that once before already, but that
breaks with distro versions of libnl. I guess distros will end up
shipping 1.1 as libnl1 like debian does for a while?

Is there any particular reason you need libnl from git? You could just
check out 1.1, no?

johannes

--=-/6eVLzumRw56hRHr6buP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPbWcAAoJEKVg1VMiehFYfUcQALTXvtqFpHKIgaLf1vIoNYkH
QwYUtqaH/V0HU3ogttGSVxB4bxNCYO3c+3lK8cM8+4tWPCt1eLM0k+Ywn8laRviV
oxsw+KES+5WL8qJryvUkCGBppYOZDAtn9TQu3wP76A2eC0FDC9TdceC6Gj5lIjGp
Pl/z/oFnGSMzhetE4qRF1R1xciS3IYB/yK5Du42Wjtc2NTaySHFXDFy/KelPOr9J
axNM23Y6b96H+3lGpl2N01Mn0xGLOSVe4Sq6l7xnjXH8nHcVwBoRjqThy2vNDKFa
AlLY3i/azkDRbJKDGLmt+au0ZJQx/eJHiSoVETGVIIMdc69Uumg9vXwYI3k+Rxxy
7SYfeH2PLKT6YzC5dbLUrAzk38y3pt44qeIKfZ5hwE5rg+AF8YH8yToCLUT/XHMz
k2vKloUVBtN1Kpwg6o/zAbrLKipvejvonyE7jJavj334mZHeWnxEVMrEsMuKYfNM
NyzRa4P9G4W/3t2KxeJ5kIGds0XAtaqG8vVYzw3Mw02nRuRGkmmUdNKW83/0hsBf
qUx/Ns88Di1MN2ENzy1B+pk4AtJ9X3o2A/2HfFf0O8Vtu/ABtH+DS72komvULF/Y
0tfwskKSnLJ4VyFzcL55tx0TCZgkQMZqp7XfF4b6G2QyXyGq7v9CLkACr9zI/Y8R
ITnETlTIIePbtxL/yLNH
=2TIq
-----END PGP SIGNATURE-----

--=-/6eVLzumRw56hRHr6buP--

