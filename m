Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab0AUJOV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 04:14:21 -0500
Subject: Re: [PATCH] mac80211: Add HT IE to IBSS beacons and probe
 responses.
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: austinxxh-linux@yahoo.com, linux-wireless@vger.kernel.org
In-Reply-To: <4B578BAB.9010608@free.fr>
References: <856792.42713.qm@web55307.mail.re4.yahoo.com>
	 <4B578BAB.9010608@free.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+RUZ++z8NxIaakW4X2mf"
Date: Thu, 21 Jan 2010 10:14:17 +0100
Message-ID: <1264065257.11396.32.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+RUZ++z8NxIaakW4X2mf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-21 at 00:03 +0100, Benoit PAPILLAULT wrote:
>   =20
> Humm... same question for me. What's wrong in the patch? form? content?=20
> frame format? commit message?

Well shouldn't you only advertise HT if the user or somebody actually
asked to join an HT IBSS and you configured the right channel type?

johannes

--=-+RUZ++z8NxIaakW4X2mf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWBrlAAoJEODzc/N7+QmaT6QP/AmvFYEOMgdjIk/dP4E0Jz0x
wOF9wInI0ZGUVy6DlHNKW3FTzJU4NdWmvTHF4+rOu+YAftIljRL/+RpCI5qgMUmd
cehsEwHjGOhuP9M29vsfycs+FlDAgeMnMupKHHERT4gN9EMWiLtyVsoIhY1nprub
uYIRLvhD+aEsVp732xCwadDp3TZjiyRsx5SUXkKznGmbOSAvAdqEzfJkFAdF/QiJ
PPvXQ0N9UmFoN5+qocyoHc1LQtRyjm+fJBJQUnVbKMkHAU3pwa4Uj8QfVoqjw3Vl
XXUngZS6eNkP+zvm+x2nGJZ5inRcauTxIaXEg/hTXn9dHnpGdc9ZBKzwxCoLWHCQ
fCZqlR9TIiG1P5+DccqKkvfRua/9m8v5TI7hK+bOS6YMdGTtdhUMFuW2aOtAOCPS
0svI2bwehGEjE3qc7sUi1V+8QFVziNs8NSlcLlI6aHSXBOaJyqil3kP1Qx/U6VYV
TVonSEPi1S+o9FG+x2nggoE1rM229DRBNhG5OF4b9RsAQipc2TJWoK+/SA/vVExW
PlJVQ5/jC1VP/uRL2nARPoKaAzHhLUyLrO0GETRStI53BjysDqaaD92p1qWAwXl2
hGAi8y7agyVV5UZ7X7+kU2/2106jAYHGcIbGF0oZkUdNGgw718/KmL9BYf3UWjh3
bghHqpaxEE65w9Zp1agF
=5vh/
-----END PGP SIGNATURE-----

--=-+RUZ++z8NxIaakW4X2mf--

