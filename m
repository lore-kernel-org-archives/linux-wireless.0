Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab0A3V6V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2010 16:58:21 -0500
Subject: Re: Regression in b43 with BCM4311/2
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4B64AAEB.9020806@lwfinger.net>
References: <4B64A2F2.6060608@lwfinger.net>
	 <1264887027.3546.207.camel@johannes.local>  <4B64AAEB.9020806@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xG4S9b80XZcqUnL0ihOC"
Date: Sat, 30 Jan 2010 22:58:19 +0100
Message-ID: <1264888699.3546.208.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xG4S9b80XZcqUnL0ihOC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-01-30 at 15:55 -0600, Larry Finger wrote:
> On 01/30/2010 03:30 PM, Johannes Berg wrote:

> My AP returns the following in the scan output:
>=20
> Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 18 Mb/s
>           24 Mb/s; 36 Mb/s; 54 Mb/s
> Bit Rates:6 Mb/s; 9 Mb/s; 12 Mb/s; 48 Mb/s
>=20
> I don't see any * markings.

Check with iw, instead of iwlist, I think?

> >> Is b43 missing something needed to set the basic_rates member of struc=
t
> >> ieee80211_bxx_conf to a more reasonable value when b43_op_bss_info_cha=
nged() is
> >> entered? I think it should be 0xFFF, not 0xF. I have tested with the l=
arger
> >> value and found that this change did not improve transmit rates.
> >=20
> > So you're saying it doesn't help anyway?
>=20
> Yes, it does not help. Since my previous message, I have also tested the =
short
> slot logic. Inverting the test made no difference.

Strange. can the patch be reverted as a whole and then it's ok again?

johannes

--=-xG4S9b80XZcqUnL0ihOC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLZKt3AAoJEODzc/N7+QmaqmwP/jEaoWW8GlSnvpQTX5OxITHA
qdHJiAZQ7nFyowAFVbcYP25k7gc5bHcRob+0depAb4sYUgH69Jn1rFJLrgVq6lha
e5gmQwYHTKmO9DINGB/uUYf93d6RbXmHyf2dMxsOePsD0EJmhnGvYBf8B7eCiHh1
+KdBPIAFpYz3KWaex0kJ9fo8koZ3GM/Gnw8HwjHEN1Ic51MxaVRuk4xcNeCpWBxG
quefCciMiwcQgD7pOAIXpmbiQpuBrsoz2yjyK52sRyU3vvHPAk+rAa2MhfkhW0qq
anFtPPY3kP34+JfOs41AH2wJVRaXPMwDAAZo6yerWzD6ClF7nG86n2Q1iJfEJJnb
TQmcKeFks323twTCKIUowg/7P4PVAmSjgvyHSTAaBAf6mS/y5Wa9h9BHPaqnJQw4
f1huSDus8eCdvjbvaQLGhNINTZIi7vOocQaieu1+O8h4TQeTId+8YNXlOCCP/iFH
UiPtgUqGw/ULnoGxNNjtBIn1MWR91Rt87CRp+BOnsuPJwXNSB4Ab1F0httFeuYjy
U/csBJ1YyLLuDxdB2a220A47q0ZyTKmyxhDVl8OuLniSOioZ6DEmRb4ZhL8ij5I8
VpXhxe/YACcZpBk92o2NFYBDNeiaILYffys3FZXwVOrmhJBX9o4ALkifRfzW8zO9
aHSla6qo/9zKHTou4ny8
=GI+B
-----END PGP SIGNATURE-----

--=-xG4S9b80XZcqUnL0ihOC--

