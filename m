Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569AbYJXXLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Oct 2008 19:11:11 -0400
Subject: Re: iw: hanging when doing station or mpath dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40810241432q4d25d352g5f7f50961ecc0194@mail.gmail.com> (sfid-20081024_233240_009679_617653EC)
References: <45e8e6c40810241432q4d25d352g5f7f50961ecc0194@mail.gmail.com>
	 (sfid-20081024_233240_009679_617653EC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JXkT59dulMVGqgfg6wVw"
Date: Sat, 25 Oct 2008 01:11:03 +0200
Message-Id: <1224889863.3919.21.camel@johannes.berg> (sfid-20081025_011128_734059_E3472FB3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-JXkT59dulMVGqgfg6wVw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-24 at 14:32 -0700, Andrey Yurovsky wrote:

> ...which never returns.  This seems to be a somewhat recent regression
> but we haven't had a chance to look more closely into it so I'm
> mentioning it here in case someone has an idea of what could have gone
> wrong.  Thanks,

I _just_ fixed this a few hours ago.

johannes

--=-JXkT59dulMVGqgfg6wVw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAlYEAAoJEKVg1VMiehFYbuIQAL5kfK7Az3kLkuq6qUH9wxLf
pmk4IHfVyPpzWxH8YMRXzXvsQtLDj12Izh0zjsWqzXXOeh2QfQF4SKuGn42Ycl76
20Ww7NhqQfaFpNJmD1ieYiwkbXtfI++/lksBZ89POqsidMmZJ9CYQ/bIMITgKtwK
0HdyJDjrCpWZmgoSdZ4bt2ve8Szg0E7YaF0jCCzWG0zMEu0xN9gnJXRFz1zRWaiL
M8yofwzI/oiXGaGQ4nDAXABsbfuEzSp7GlvbwriGJSCjV5Ep+7kmY7iR4pcoEXUz
mKAVb7N2UnD6oxzbrYAWUt4CqTKPGz6DmNq0RXXTQ/5xls3Ry3kWpt9r6ynKkhmT
Wq8KiCJZ4tWmR0y/JRw+w4v7dkuvZeAitxFl0+8aqY5fKZZgPgsCi5aj8l+IU1tJ
7EU6F9Gw3Ddv09ipQq3nmygGz9AR9qBLT/7TQ4lIE03zHNBWafroMg2T+kEzD8gO
zKhKEOURH2unlE4gf0ujFqpZ91tARIIqm4p7xgkOZTCsjJ9wc3u2B9/btr7Vgh53
uth4lbSvXapCyWvjPxV+21iv8uvk/8Nde5UhpNbiJUbXIE2j13k31yxGVUsOvR0+
pkRoH1YTz7MEfoMN8ovHw45AV/MaVnIRHPW6pzR5EwvBwZIIouZtmAxLMiSDLwR8
u89rqpPmudyn0yDCCdgU
=QV0G
-----END PGP SIGNATURE-----

--=-JXkT59dulMVGqgfg6wVw--

