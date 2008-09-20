Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33513 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYITVLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:11:21 -0400
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for
	Motorola 7010 variant of BCM4306
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, bbullins@triad.rr.com,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <43e72e890809201405u63f57680u63ce0329c8cd31a2@mail.gmail.com> (sfid-20080920_230522_937343_EF72BDF9)
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>
	 <200809201744.55571.mb@bu3sch.de> <1221943895.3023.1.camel@johannes.berg>
	 <43e72e890809201359kb65f3d3qb618129ae6b528f4@mail.gmail.com>
	 <1221944575.3023.10.camel@johannes.berg>
	 <43e72e890809201405u63f57680u63ce0329c8cd31a2@mail.gmail.com>
	 (sfid-20080920_230522_937343_EF72BDF9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZM7ZLi2jHYq0OA+A5Erv"
Date: Sat, 20 Sep 2008 23:11:15 +0200
Message-Id: <1221945075.3023.14.camel@johannes.berg> (sfid-20080920_231123_692913_5A2021C3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZM7ZLi2jHYq0OA+A5Erv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-20 at 14:05 -0700, Luis R. Rodriguez wrote:

> >> > Does anyone actually make laptops that use these bluetooth coexisten=
ce
> >> > pins? All CSR bluetooth chips do it automatically I'm told, maybe we
> >> > should just kill them completely.
> >>
> >> Regardless of the wireless card? Or just for bcm?
> >
> > Well just for b43(legacy), but out of curiosity, does any BT chip use
> > these pins anyway? Well I guess _somebody_ has to buy BCMs BT chips,
> > but ...
>=20
> BCM BT chips? I thought you said CSR?

Well the thing is, BCM wifi chips have these IO pins that tell the BT
chip what the wifi chip is doing. But CSR chips for instance don't care,
they just check what the wifi chip is doing on the antenna. So those
don't use those IO pins.

Hence, I'm wondering if there's any use in the IO pins at all. But they
must have added them for a reason, presumably because their own BT chips
can use those inputs...

Anyway, mostly just idly wondering, since most of the time it works fine
and the EEPROM is actually done right I guess we should keep them on.

johannes

--=-ZM7ZLi2jHYq0OA+A5Erv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI1WbwAAoJEKVg1VMiehFYaogP/jUAka6Ntc+uDJURiYrydpvD
G5MGnh07Ho5pgDgfaoFJYFcbrqdNXUGAxJ+ovIC2T8Wj7c0aA+GrR1x1tvLerVmp
bDyEmiBPwrYZNOlGliw3kY1CXvGm8DXvSTyfQGtVl/K1BvSz19hw+CuJXEKUuV6l
HAotOr9/NRihuEPr5JIRrwOx85c/D2M0PsxEB9vRgRgIc3uGWzXr9pKm0STJxnKQ
F7ZW85+gYEuAhp+5yF3j9tC2KM0VkMlbRm4SgShCU7yy1hdvGR8dPaCXGmNfRZKy
8fudc8VyIRsDj32dJPHHef0DwW+G8dAe66WyIVnZGPupCg4lH80H8V3y9p9YdbKu
cqE/NIJO5elIVhqDivOcJREEHiKo9F90/xKuk2102T3XzaH8vHoxzNObWnV9Hh0A
b11BSodHxp+1PVjL2d4N0equ+ZS2r20tqiu/0HmuUMk0bPW9vAihU3IM7L88nM92
st+gZyAGmsRcsEqUTuMUBF8lpauNmS0QPv4Dpt82ghlyMoKhmOqktkeddJ30VS9L
pKjy27Z0d+rWF6DIWgdF67CW6KaICMm4/xYb5ixd6OcaoJ5tWQGJ/XEjOoY04SGu
WZtf0CsfZ8jxFFeiyF+sInVgJeZXCJQcQWcOM1s1VrDddeje++XOKK4Szx1QjY6t
SRGk2ohAZbgdWpmHol0E
=wjTS
-----END PGP SIGNATURE-----

--=-ZM7ZLi2jHYq0OA+A5Erv--

