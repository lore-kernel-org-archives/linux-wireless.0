Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbZKZUPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 15:15:41 -0500
Subject: Re: [RFC] API for setting ACK timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: 8an@praha12.net
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200911262113.10847.8an@praha12.net>
References: <200911261826.08576.8an@praha12.net>
	 <200911262015.03106.8an@praha12.net>
	 <1259263540.24540.9.camel@johannes.local>
	 <200911262113.10847.8an@praha12.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Nv39YR5TpVOhKwOxX7hw"
Date: Thu, 26 Nov 2009 21:15:44 +0100
Message-ID: <1259266544.5428.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Nv39YR5TpVOhKwOxX7hw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-11-26 at 21:13 +0100, Luk=C3=A1=C5=A1 Turek wrote:
> On 26.11.2009 20:25 Johannes Berg wrote:
> > My standard reference was obviously crap -- let's see, 7.3.2.9 is
> > better.
> Yes, I found the table. And now I also noticed the real difference: the s=
lot=20
> time according to the standard rises in a step of three (which means ACK=20
> timeout will rise in a step of six). It's quite significant loss of=20
> precision, but it probably shouldn't make much difference in throughput.

It only affects lost packets anyway, no?

> Anyway, this solutions would be good enough for us if it was accepted. So=
 you=20
> propose to add parameter NL80211_ATTR_WIPHY_COVERAGE to nl80211 and funct=
ions=20
> set_coverage/get_coverage to cfg80211_ops?

Would that be sufficient? It'd be kinda cool if mac80211 auto-configured
itself if it picked up a beacon that had this information, etc.

johannes

--=-Nv39YR5TpVOhKwOxX7hw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDuHsAAoJEODzc/N7+QmasPMQAICZEVbtniyKmEq9wBG0MJui
ES1LCYQU/cyhxIsQahW0NnXwYfr86KrxmvNFxA0tUqLhATFrSHqmzPDDcD7N000x
QF/0+PE9Yxr+uIZScZKDKAyF7dZtjwGhRqmaXLe5eiMbhnl2eUNOOQVH0H17fDos
IHmvXEO0xZq0OZxrshu5vEjVcNAEZ0bVk+bCkTCDZib00r71hIbil6pkvMRjROzt
bqQVRZwyFtnflclMILh44h+Dq93Cy3rJv7LaiJn8X4rbN1M/sC4TKwIFNdZHaspF
UkqO+Lp/OaF5QxY81/DwMm1NShIGGrlhrRhQ6DaPzmzYc66G5M1jEKeSVimOkDah
aE81JtBxPKrWNuhGCPM8k9Lti4yKniL7sLR644mr54fh8pdUk+hfpjlqi9+gGSv1
gjZF2Gjiae119wVWDa84qKJs7fAfpmexVJTEv2eq+W5jfuy/UDO0vb6NTgqELZqu
7+7/t8Ql0rsXEiNX754sfHiHotz926zzd3v6FRvL//qmg69szKBHsbEUHDrpCDxy
Mz8+0t04u8Yb2GJUPv+f1g1vhpQe7U8hDdwOyE+4TnQd6beZYzsT8gypqPW88GJX
1Soxo2uPiXm18FmRZ6JyXxJdgLiHTHG36gFdloT9f0WinQ5WGkoy/4od24XnSprb
qxAPXivhYRS/MgDLQtwc
=eTmE
-----END PGP SIGNATURE-----

--=-Nv39YR5TpVOhKwOxX7hw--

