Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45358 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbYK0OO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 09:14:28 -0500
Subject: Re: p54: AP mode: no data frame despite traffic indication set in
	TIM
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Steuerwald <salsasepp@googlemail.com>
Cc: Christian Lamparter <chunkeey@web.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <f76a32050811270605s606cc0acjd419987235db44f4@mail.gmail.com> (sfid-20081127_150530_186684_B4590317)
References: <200811242124.16358.chunkeey@web.de>
	 <200811262213.03751.chunkeey@web.de>
	 <f76a32050811270057r69df8f38p9cb4129bd98ce575@mail.gmail.com>
	 <200811271206.30851.chunkeey@web.de>
	 <f76a32050811270605s606cc0acjd419987235db44f4@mail.gmail.com>
	 (sfid-20081127_150530_186684_B4590317)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vDlOH5lWo9yENAOpd4Dv"
Date: Thu, 27 Nov 2008 15:13:54 +0100
Message-Id: <1227795234.3809.94.camel@johannes.berg> (sfid-20081127_151433_407136_729CF748)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vDlOH5lWo9yENAOpd4Dv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-27 at 15:05 +0100, Stefan Steuerwald wrote:
> The v3 patch (together with the other two) works flawlessly for 1.5
> hours now, under app-level traffic.
> I will remove 80211 debugging from the kernel and try again for a
> longer period, but looking good.

:)

> I'm unfamiliar with kernel dev procedure. I assume you guys are trying
> to get confirmation for that and/or submit patches?=20

I've already submitted my patch to John, I suppose Christian will submit
his and add you as Tested-by.

> If you need me for
> any of that, I'll be there anytime. Also, a hint on whether to send
> pizzas or iPods would be appreciated ;-) .
>=20
> Thank you all for this marathon of a helpdesk session!!!
>   Stefan.
>=20
> (and - ahem - I'm one of those customers coming back for more...)

heh :)

johannes

--=-vDlOH5lWo9yENAOpd4Dv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLqsdAAoJEKVg1VMiehFYKrgP/jfishYIA5MQ8GGNVhj86S7Z
Xl8f0kSQH/Uj/9/CVw7dqmrfvOBdmSuTniaP1VSA3ipR5ETvdZYLLi/13+zrSYIv
MGmJQy/vONWyXKYQaNnRAzgp2PNXSyLAU6KCqIU1Kudgg9FvrHwQrLWSQZEq58+/
TKHQ5Kq4e+nozsLAHgKnm8DyU2Vi4vuFxRBwaW2vgI3sGu+VmycxTzPXBHdjhBit
8QTwqKjpwWP5Ei+BqEVg/aQvihXMFYkHLZaR4J6kMHW9rzamZELVyyBTfMxD+Unf
1G6cf8/zQ5Ub6j1rGyntgEwAaSoj3dwo/GR3xlo4Xx4NVeCBgHpPAmNJ3T75P94W
D7ikVNVXFr3GfUZL6ZYE2CDytQuZ2cPuCTXfIHJgj4wbVlowCVfvG/MxybX5TemU
RKtnLuOKgi1B/Kc7xxCUX7qDhF6iRJQSpLSJ/01X2mqqKyEEM4p7lAjb3tvaEhha
kiX6NifsZpyc4Y1thi1iUvUsf462Ztk3DYFN9NBuPlYasQp1ZUhRolvdD6PerU9M
3NoBoXiiBen0/JzU0D4OAZCS143NWrDUuhPkx1tgrQoZmahmD7ZhDm6bGLLNN8u3
TZKNw/Ji+6BuqyKddWRhv/lIKOjRU/uGt8IN72nL4XbdkEJEYToaPvFqtYvidJ61
ycLHRC6MbDbiVl+vUrhY
=/Wp/
-----END PGP SIGNATURE-----

--=-vDlOH5lWo9yENAOpd4Dv--

