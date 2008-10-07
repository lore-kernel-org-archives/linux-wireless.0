Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbYJGSDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 14:03:09 -0400
Subject: Re: mac80211 and IEEE80211_CONF_SHORT_SLOT_TIME
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chr <chunkeey@web.de>, Pavel Roskin <proski@gnu.org>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <200810071957.55250.IvDoorn@gmail.com> (sfid-20081007_195801_431295_43E0A96C)
References: <1223370325.3778.69.camel@johannes.berg>
	 <200810071957.55250.IvDoorn@gmail.com>
	 (sfid-20081007_195801_431295_43E0A96C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LEG9EOuuowhAQMy2vGbE"
Date: Tue, 07 Oct 2008 20:03:07 +0200
Message-Id: <1223402587.7328.68.camel@johannes.berg> (sfid-20081007_200313_052730_E66926DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LEG9EOuuowhAQMy2vGbE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 19:57 +0200, Ivo van Doorn wrote:
> Hi,
>=20
> > I just realised that for whatever reason mac80211 isn't setting the
> > IEEE80211_CONF_SHORT_SLOT_TIME flag. I'm not sure when or why that was
> > removed, but clearly it isn't used.
> >=20
> > Can you please fix the drivers using it (b43, b43legacy, iwlwifi, p54,
> > rt2x00, rtl8180, rtl8187) to use the bss_conf's use_short_slot instead?
> > I'll fix mac80211 to set that appropriately.
>=20
> Didn't you have such a patch for rt2x00 already?

I had something a long time ago, but it never worked out right. I  still
have it in my patches dir as *-BROKEN-mac80211-bss-slot-time.patch.

> If not I'll see what I can do in a few days.

Thanks,
Johannes

--=-LEG9EOuuowhAQMy2vGbE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI66RXAAoJEKVg1VMiehFYxVwP/2xI2w1Dlb5You3UEKZaHFhT
qHqxkIOd0U5Sc0VxaPIJW9ZrDkCPP0gudS7Xvzj7u+d+yZo1os4TvYWlpfdv1nOf
4/WtsE2Zt0lhGL+LPjs5nZsrQbq76p8NI8rINKZsmmGhSa+YtOey7aNfOilLvJE3
7IstYPZxntmg3Sz846ZspINYqhx7d2DWfaZ0Uali5d0WO89khbc7PpBN6D7Ad0br
aTHuJoHBt9MByqGzWbqzCh5yGM5YF/6TzPlS9868rqmBTGv3WxM+6DUGrLxGnDDH
0g+Q95uUbxsNmnPiSlS+l1oaUmFYuRhlGhXo+xfs7a9BMDqW9Qq4mrCUqVOw4DrS
CpY4g+VyZhMNaUx8IAvuLFBrAErYAUQsbZM88pB0PxOv2V0r2U/dXsbL8rXAtjGN
XklmQc+LQqADm6zTvhQRIBC0J/eYIS+mSojhVPgL3qroPQ6FW7+PP8vzyx6uQtm1
6GzCxxEB3BcyQz0MW+uDhyEywqM4WA38TaiRWRPIbS7RZ4geI87zix3dtiPyZa7Q
MkmFmw6n/krqWhhREPY69jHSlej/gIDw3B7410rYu1wYGKw+eF1CUCC+MdVULxam
ySFBeRKhzXTKJXE+XEc9brc9wDAjxoBIS0JLgQY/ECrnJ3ydsZzFEij0HeUyXBXX
bQTxSujjf47vGLIoFchI
=so3A
-----END PGP SIGNATURE-----

--=-LEG9EOuuowhAQMy2vGbE--

