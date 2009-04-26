Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbZDZJIS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 05:08:18 -0400
Subject: Re: [PATCH] ar9170usb: reset device on resume
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200904252132.09966.chunkeey@web.de>
References: <200904252132.09966.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uzxULUcp9D3WJhAPOa3k"
Date: Sun, 26 Apr 2009 11:08:14 +0200
Message-Id: <1240736894.4743.0.camel@johannes.local> (sfid-20090426_110821_496670_9447766A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uzxULUcp9D3WJhAPOa3k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-25 at 21:32 +0200, Christian Lamparter wrote:
> This patch takes care of an outstanding comment in
> "[PATCH] ar9170usb: fix hang on resume" commit message.
>=20
> >However, the device does not accept the firmware on resume.
> >and it will exit with:
> >
> >> firmware part 1 upload failed (-71).
> >> device is in a bad state. please reconnect it!
>=20
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Johannes,
>=20
> does this two-liner breathe life into the device after resume?

Yes, this helps.

Tested-by: Johannes Berg <johannes@sipsolutions.net>

johannes

--=-uzxULUcp9D3WJhAPOa3k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ9CR6AAoJEKVg1VMiehFYVeUP/3tW+orgmVAKDKcQvThqPrut
NPwcig3UTsGfTYKHxY4EwrnrfRQrd9kH9U89KPN643Ql64fAH68BJqesw2HwysQS
vvWE6rcv1lH0MCX4IGj43yLuC1qzflBjqzZaxRPToSw8LOBuZn/PX8AizieigBeg
+23sa2q68PqnVSCrcrdv4A6+U4okiGdCocSHa9vee6qb0wAzqOE/dW1JSKPn0IPG
EfW5IVKMYKaLjxTUmig8VxG0yZfkl2Ut6Q+Nlqua1vl+Ww4+P4KKIPpCue/DAgXD
eBEKQIhUNpRwooEk6CwGz7BiRHUqQ8GwUCwRL6keCXD9OenHFHOp1Rh1ECrHgg0z
p7dcdJ2e5glDaoJAH5XTbfqfIJl/2JQFgcQMuJd46ZUnq0bHcfLpU3R6Pl6pMmlx
ZVHeVBtc5L/Aydty14h8SyB3nVi4thl1/I9lLuhrzoeKFl32Y6RyQ02FfBzvF+Nz
Gy/HPdVduRj01l7ZlvGVstnjjvYzPWFgDXkcPUuYQ4u25l1VgsNpcbgswtbAMaGG
aTAkpcqWw4vaCBL0a07WiS/60FYiWyiT9tPsRh1tcQP1rS+FFMPOcGmXU4dCSwA2
4DlsZvBpZRUl5XfgTwp592hNsIRcWlO5Ax53juJGqyYykqQCDBxovuQRWiiBE8qz
1eV1RwIaaK/CK3ODMs1n
=Dybp
-----END PGP SIGNATURE-----

--=-uzxULUcp9D3WJhAPOa3k--

