Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:34456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYAHRO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 12:14:29 -0500
Subject: Re: Warning emited by 2.6.24-rc6-git5
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, chris2553@googlemail.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240801080744u5a076202n91f11b0de87384f8@mail.gmail.com> (sfid-20080108_154444_241831_C6355BE0)
References: <200712290942.37396.chris2553@googlemail.com>
	 <200712291614.55732.IvDoorn@gmail.com>
	 <1199261473.4172.58.camel@johannes.berg>
	 <200801022012.52287.IvDoorn@gmail.com>
	 <1ba2fa240801080744u5a076202n91f11b0de87384f8@mail.gmail.com>
	 (sfid-20080108_154444_241831_C6355BE0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mdOooBOUVBR0C5cbsLsW"
Date: Tue, 08 Jan 2008 18:09:27 +0100
Message-Id: <1199812167.6762.1.camel@johannes.berg> (sfid-20080108_171433_924622_7CA175B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mdOooBOUVBR0C5cbsLsW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I didn't test the copy solution yet but in 11n rates I see as a show
> stopper. All 11n packets are QoS packets.

Really, go fix your firmware.

> I haven't encounter a problems in net stack yet so I think this
> solution is a bit drastic.

You're not running on arm or sparc I guess. But the fact that pretty
much *nobody* was aware of this problem until now tells me that I did
the right thing and this solution is not "a bit drastic" *at all*.

johannes

--=-mdOooBOUVBR0C5cbsLsW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4OuRqVg1VMiehFYAQJSVRAAiEBrr1Xw7DLuL5u/KOFnWcIIhJU1ftm3
CQ9I4PAnZjMyhD8Hk2pj03VTy9t2C28KFyAiwqqXkb9IRwE78+rpB8keJRr57IWk
C3DrUybp1cdc3A3QXH/vXgii6L0NKl7L5cH8xAtm4seft/RBAo/kYNDfE4VxSxsT
ZYE4Wo1wnpRsLWKHYcvzLWbXgBK0lCHW5q7Djp/vXrB5uMqnywa2sQ55iLQALv+P
U4IL8WFgDNf2YYX6UZhASaJ7uIFe/NRk5XFPd5YfWHYxP8Mp/932dNIqo4tw6dRH
qZZ+6VODbM7PPrqz7Pe66G6zdMm6Biuz6VEbfYXHwKw2c8EErlVEziu1Z/rx7gjk
G1nTkGWQO4YJJiNgt0XTUHGO9m64n5RPKrddAFGwT2y64JeLWf/Diq3nfSHno5xC
B3R5b7RY1gOVq1Ptfb1IKZm8nsaf6dZW4CrxVxZmMeh8ojw+KqqnlhQoa+pmBHrX
vIkAgYhbnJYvNMbi/u90gbf9Ywv/j8+zpRNc8Qaxws+JCHC4KsSglUFcUG8Fn8Fa
EXpXApzTJcw/I63a4WGqYpt/ul0tL8VEFensFgeIBhBKVQ2dDMjGoETs61lxCmra
ojs5fnenXyhzH20ph6azWXvz6LCOB/0QQDZpz1obRCwseK8Q5MYR4bhI0GxrQw9Q
lO3lJG2s28w=
=QCZ0
-----END PGP SIGNATURE-----

--=-mdOooBOUVBR0C5cbsLsW--

