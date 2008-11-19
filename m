Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35489 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbYKSPS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 10:18:26 -0500
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
In-Reply-To: <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com> (sfid-20081119_160901_781124_83C827A3)
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 <1226943608.3902.36.camel@johannes.berg>
	 <eb3ff54b0811190559g39c2176h86bd9fb1956d6730@mail.gmail.com>
	 <1227106146.26243.43.camel@johannes.berg>
	 <eb3ff54b0811190709q76e8b073ic71831fd38ceba18@mail.gmail.com>
	 (sfid-20081119_160901_781124_83C827A3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YQAP6T5TOQsej+jCpcik"
Date: Wed, 19 Nov 2008 16:17:49 +0100
Message-Id: <1227107869.26243.52.camel@johannes.berg> (sfid-20081119_161830_008266_51B2D56F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YQAP6T5TOQsej+jCpcik
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-19 at 17:09 +0200, Rami Rosen wrote:
> Hello,
> Thanks for your answer.
>=20
> Now, after looking at the API doc ,  It seems to me that sequence
> numbering is also missing in the zd1211rw driver.

Possible, but that's not a huge problem. Not having multicast buffering
means it won't work for powersaving clients, which is.

johannes

--=-YQAP6T5TOQsej+jCpcik
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJC4aAAoJEKVg1VMiehFYcTgP/17Z9olW4sopy3WmZ+JBM8vw
zI5R8UO+Bd+WSLbZULdhpW35QDzg4uGL5DomBajKqdTB4VV/7yua05Eks7EwEuRO
B+UrFArR7ggBmF7P0pVpV92VELCIgaK4OqvrwTEdXV0TkLYdogddhyJw+0SETgw8
7l5QDDdbVQs950Chla5KpqrtsOLsBpIiOiiGxGkOGKaaiuH59x4QJu060Z9a6zqT
Bk9WMQkAQLWmDMa1tvUS2FYeLtBXlExnFW+5GoAzdnR+2+eHCK1SHL6Nn3ev7CTO
UuBT4G2TQQCJsm6MxMzBnazrS7Uz7YWF61k3PqXunIgCenFogw3Dr+BjJ9LUsZQF
gCRLzPuY7R3cXR8JFUMV7E3RU19Z8eb2YQ9Rvl30mZSxg8/DYUy1UXbklxv2GHEt
J0O4R8oZ3gVG0Zajmf/1zpa6Emsc0WSLgPTO9+hStnB6RKRDbJmaZ87ozEvALCKn
a0tFq8llzlK+OGCBbPbUfj0r0MmjqdwfnCw5qvlEKlPb6FQp/XpvzcK2gvBFxKxy
VMUn4b2wx7cpz/vSs4Kxo0jTMMXQM/86NKyWegJ70Dgsbwx+pnRs6KREYnlH7k1E
ALYQw85t9MNjubHtB5rBoRHF76E8r3YZphKmSy08MmYzAh5Fio1T9rMcJN8huOEI
/GmlYPQxGdDF/twPD5+e
=EbZp
-----END PGP SIGNATURE-----

--=-YQAP6T5TOQsej+jCpcik--

