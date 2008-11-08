Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58996 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYKHKfh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 05:35:37 -0500
Subject: Re: iwconfig power timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87tzaiwn3z.fsf@nokia.com> (sfid-20081108_110355_356167_0D74E561)
References: <87tzaiwn3z.fsf@nokia.com>
	 (sfid-20081108_110355_356167_0D74E561)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-D7d/MnSM5wn+FxlKwrrW"
Date: Sat, 08 Nov 2008 11:35:36 +0100
Message-Id: <1226140536.3610.2.camel@johannes.berg> (sfid-20081108_113550_596055_6823A885)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-D7d/MnSM5wn+FxlKwrrW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-08 at 12:03 +0200, Kalle Valo wrote:
> Hello,
>=20
> I'm trying to set power save timeout for mac80211 with iwconfig, but
> I'm having problems with iwconfig on Nokia N810:
>=20
> Nokia-N810-35-3:~# iwconfig wlan0 power timeout 500m
> Error for wireless request "Set Power Management" (8B2C) :
>     invalid argument "500m".
> Nokia-N810-35-3:~# iwconfig wlan0 power timeout 3
> Error for wireless request "Set Power Management" (8B2C) :
>     invalid argument "3".
> Nokia-N810-35-3:~#=20
>=20
> Looking at iwconfig sources the error means that either my syntax is
> wrong or iwconfig has a bug in the parser. I'm guessing the latter
> based on reading iwconfig(5). But before I will start investigating
> iwconfig's magic, has anyone else seen this?

Looks like mac80211 is rejecting that setting with -EINVAL, and that may
well be true.

johannes

--=-D7d/MnSM5wn+FxlKwrrW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJFWt1AAoJEKVg1VMiehFYszcQALishDuWVaV8UFZZYOa196s1
O5OB/EP8xvqTQDJ2mRMQcGLq85sZUrhqY1AE8HW20crao1ipYqwS5LV6PWJgo9/Z
odMFxX1w8Zq6it6gDxyfwurSh4NILzDht7chxP9JyJcLfC9RMuIedNP3vlbHd89E
dH+R8kXuz+97vaxVEWe+zjGf3/BdBK9KNmtb93NP/SmcmJ2VgnQ2jtuM9UbGGNhW
hAD9emKDEbMwlkVn6I0AgbADWBUyA0+GjNXhv2/Y6TbXU2yKcax6cHKMoDWQPyLF
h/iCGrZEh2BL4JhQn/YayUX/FMdliSojJcu2lgr2+ovbaY0AXSV5c5QBH0EyAn+g
9vRBWpOc7KWzXatyakQw/k646Eqn025wwHq0PinknXopUlT4zCIekuDzaRmBqh+p
2/IESW/YSbo0+xPh8LTMZdVTLB5ug0BICszlChHrQBUmcd+kQPevd9D1rScImOwY
ZkGJxaoQ/JYf/baM5Fa3clTB33O7j3AOUyCeP7C4kwf5wYwkYN16+OcweXdKfPaK
1LDLPEyipuQVQPniwd45JPb5AAFEJV/37tWxzQf2IMKyZyQ4Hy8EUtkrREa+m/Zw
RO/fB3jykIiIeAYxkgazFzPgymgQRFgziIlNw8O4D6CZFxwSmM0PODzWgm6f4Om2
VKLJsWd0dNah4soWm274
=eqrc
-----END PGP SIGNATURE-----

--=-D7d/MnSM5wn+FxlKwrrW--

