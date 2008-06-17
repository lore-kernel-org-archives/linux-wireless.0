Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196AbYFQScq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 14:32:46 -0400
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <200806172027.50312.mb@bu3sch.de>
References: <20080617154008.883383150@localhost>
	 <200806171952.53183.mb@bu3sch.de> <20080617182322.GF4974@jm.kir.nu>
	 <200806172027.50312.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xZKp+13fgpyUF6pmO9C4"
Date: Tue, 17 Jun 2008 20:31:47 +0200
Message-Id: <1213727507.3803.108.camel@johannes.berg> (sfid-20080617_203249_468493_C2BD4479)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xZKp+13fgpyUF6pmO9C4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-06-17 at 20:27 +0200, Michael Buesch wrote:
> On Tuesday 17 June 2008 20:23:22 Jouni Malinen wrote:
> > On Tue, Jun 17, 2008 at 07:52:52PM +0200, Michael Buesch wrote:
> >=20
> > > Well, as long as the checksum will fail in that case we're OK for b43=
,
> > > as the driver will notify the need for software crypto for those pack=
ets.
> >=20
> > Yes, MIC won't match (or well, in theory it could, but in practice..)
> > and if the original frame is available after failed hw-decryption
> > attempt, this is indeed all that's needed here. Some hardware designs
> > are not able to deliver the unmodified frame due to the way AES hwaccel
> > is implemented in them and that gets bit tricky to handle in software
> > for IEEE 802.11w.
>=20
> Yeah I see. Probably need to disable HW crypto for them.
> (If firmware modification to pass MGMT frames untouched is impossible)

Broadcom's firmware already passes MGMT frames through untouched (unless
they are auth frames and those aren't protected in 802.11w I think.)

johannes

--=-xZKp+13fgpyUF6pmO9C4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWAMPAAoJEKVg1VMiehFYCMwP/AsomqFgW46ZvUeX8Tc8jlRE
6endqu32v4k53GT0naiFdZe7u5FIw6KAb3q0MGMDBa6t3GgznSm82rLpiaKvSmJJ
K9fcu0BKgkZBJ9kVHZL5JNzFD+OPOuaZzJOm43gk98pahJZdmxNK0/YgA4fN1s7o
EakFt366MmpAloOvRpBE25IC7/s93BBBHtrJQD0jPMg6RiaNMHxvrdgnv2xd9BbX
o4Rnl1qpuSlXmrQ8WsgBds52h1RnARg1/cegpXfWm+J5fII5Us1angMphwNcxnc9
mDlppMY8ZTXmxO00qH+RAJjbx59UBjAIOjNZHOc7x8wrJekWF+ZZYC734HVWLLz7
jyHIyifPfiG5nNypE9iRtlhiPEBgTPl5wZcaEIRcvs26w3dE4l6EMLaDhDfJsQ23
eCFoolyZf0REQ6tgYASmRGFz+TbzY2broPGNQXtOhv3rnKcyOAGbxhrSAtU11XF7
DeXIDoRy7ZK7/EeMISAECDSVVQnzeOi/bar+t0BfURFHL8Xkcc7QD2G+EsnwxOC0
s+Rb9dfwIH5QNSHK8mL25rSet0qTUiEZpzqUfjzFLWcWixL5axumDL2lWq7TA7XL
D1z2rIFY8m/Yhw41gPXTp6xQWuaeTI34etzuzjcJE8/bF60b/ZJF+sLoGBDBb7ha
zQbEh/BPsWw/k3+y8bIr
=BfET
-----END PGP SIGNATURE-----

--=-xZKp+13fgpyUF6pmO9C4--

