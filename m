Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYBMMRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:17:16 -0500
Subject: Re: [PATCH] p54: use IEEE 802.11e defaults for initialization
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200802121402.06985.chunkeey@web.de>
References: <1202658578.11481.4.camel@johannes.berg>
	 <200802111952.30964.chunkeey@web.de>
	 <1202815900.8931.1.camel@johannes.berg>
	 <200802121402.06985.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D0MJiFmpoPlje75/Yj8s"
Date: Wed, 13 Feb 2008 13:11:31 +0100
Message-Id: <1202904691.8931.39.camel@johannes.berg> (sfid-20080213_121811_678779_524412F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D0MJiFmpoPlje75/Yj8s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Tue, 2008-02-12 at 14:02 +0100, Christian Lamparter wrote:
> This trival one-liner changes the QoS initialization values to match IEEE=
=20
> 802.11e defaults.
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> Which tree do you want? I made two versions.=20
> 1. ...-2.6.24.2.diff will be fine for the mainline and the everything bra=
nch.
> 2. ...-txoppatch.diff is made for "[PATCH v2] mac80211: give burst time i=
n=20
> txop rather than 0.1msec units" (with some offset?!)

I'd prefer the second version since you made it already so I don't have
to respin the other patch.

johannes

--=-D0MJiFmpoPlje75/Yj8s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7LecaVg1VMiehFYAQLMKxAAwhDrUxset5r6kaCYy5tQ5gjGOa7PCClK
WB/K7bcJkvYu0915WFE/NrF5sj7HtOGARZwe1eG/9J2W2FrZ+hg4Cl1FRSC6KSjm
UBmV0xcLU/FD+eQQkTPearFEPLnqEL1L3OQcxEvUuR7SGDqzsDjEY+ksYDn6t2Zs
W57wPBYZ1tj4OXAdj+xyKn48zi2p1FyHFGbwN0HrslV+K//jpFV5rH6ZMN/IFmzI
bzhZIsLp7xFkbuevmuJjaPn4502Nwl8PpxstD/h5EHLKj+dv+DIhAxNGJMI7iME/
To0YYGWeMLwx4eEDRaUaQv4Vad35AoXj6QVoVcldIe1rmS2NM0IaPyHfw56C6fsv
vlyqBEGxtAGqiezfIa2gZtv7YOdPsFvgA7GeH6Y16LcA3brdcLwDmInvgtj+2LOM
BhIqzl9SFzzXUZeAFkjqcqV4l/8Qil8OP0QOiEX8sKbr8Bw4iLcB2k+83ATCJIAw
672pe5JyYXj/OUyWhpDLj6YvJOno4R/54/+kNO60dPlX03iDT/5B7aGrF0eRfqAj
+KiYLSKHyb0lcUTYm8BNKU9jyQgN3jZ1xmZm8+yMFYgQdshkpib053/LnGeBf5lD
1JXEh7+s8BfOHwuX5stDbViKfvMmd+Mqv4rlYl0M0UNIpRz15aGg5t1sN0qo3CAn
ICwz2+xIXc4=
=OPhP
-----END PGP SIGNATURE-----

--=-D0MJiFmpoPlje75/Yj8s--

