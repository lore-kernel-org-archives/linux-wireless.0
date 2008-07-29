Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbYG2LcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:32:21 -0400
Subject: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: tomasw <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PS7vx1HHqYxxB8/JBr/z"
Date: Tue, 29 Jul 2008 13:32:18 +0200
Message-Id: <1217331138.10489.24.camel@johannes.berg> (sfid-20080729_133224_832207_85DF1976)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PS7vx1HHqYxxB8/JBr/z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hey,

Can you tell me how aggregation works on hw? It seems to me that there's
a problem:

Say a station enables aggregation on a low-priority TID, manages to fill
the hw queue because high-prio frames are eating up all the airtime and
then disables aggregation again. Now another station enables aggregation
on a high-priority TID, and gets assigned to the same hw queue. Now
frames for that station will be stalled, no? Seems like a bug to me.

johannes

--=-PS7vx1HHqYxxB8/JBr/z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjv+/AAoJEKVg1VMiehFYltcQAJpH+c75g1bHsceDcokRw5rt
KaN2DZFG19a/sSCDS6tSCx3EmET7Kg2bfWhg9T88neC78Y+uh8IHXzrO3TwWi4pe
TazKtznbWBTyfzhjv1OAfyBoRVD3yYFMtpmdaAVSz1kBT7Okm+af0l+cQ7qHCUC4
8U3GcKp8KbwnwTJfqlyKAC5wGpUC4XpGLJgvgVvnxcXtjFcvtQSu7EgpZv2MAWev
H6xG0VpWkwe/0CIJWwPKRX+0bbg83Xn/yRK6rO7LSorW8v48ZUga4wjaAwJyW07U
TBuDz1l9TbYasDn1pXF1jfCIhoqksOPpK1y3HtQM3MpxrPXdmzAiKpP1ZegHWK2V
Wsfm4LG0ZzU43KyoXTi4dwYd9TBpgEo7kR91UBocMhvfUcJO7eyzlQgSo0y+Zzm6
u1AaOrs3UpTc7KXh0/s1H+tboifhfhhIXbfO/e/TLg8xo+dT1traN8odQ7o4Mc8M
5Hn3JpdzUvpFSZTRCTz4kQzbQrUgh89wTM/2eXF7EgSWVGy1isuUmSkMPoSiy8Gp
uNIztjMQHuRXOEIvij3ffEsPnOJtfa/td2xcoIk/Pr2tIrs5Pov5iahrgs2BBcrO
uEiv0j2LfHudOyBi95a2fidgQvDc2/OQ/PTXU/+FthF0BbYBSw4YiIR2wemYcnqM
+FyH/O9zey49jNz+qdqA
=KYKU
-----END PGP SIGNATURE-----

--=-PS7vx1HHqYxxB8/JBr/z--

