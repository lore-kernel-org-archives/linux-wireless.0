Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56399 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757078AbYJJNy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 09:54:27 -0400
Subject: Re: ath9k rate control API abuse
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1223629834.3930.67.camel@johannes.berg> (sfid-20081010_111517_036937_322F0165)
References: <1223629834.3930.67.camel@johannes.berg>
	 (sfid-20081010_111517_036937_322F0165)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-W38k9MQUiKUaHUdAT9vd"
Date: Fri, 10 Oct 2008 15:54:25 +0200
Message-Id: <1223646865.3748.8.camel@johannes.berg> (sfid-20081010_155431_014406_153A7161)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-W38k9MQUiKUaHUdAT9vd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 11:10 +0200, Johannes Berg wrote:
> Hi,
>=20
> I decided to review ath9k as well wrt. the RC algorithm (Intel stuff
> coming later). It doesn't exactly have the same deficiencies as the
> Intel drivers, but it's still very very very fragile.
>=20
> For example, you can make it crash with a double-free like this:
>=20
> # iwconfig wlan0 frag 300

As a band-aid, you can provide the set_frag_threshold function and have
it do nothing.

johannes

--=-W38k9MQUiKUaHUdAT9vd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI716NAAoJEKVg1VMiehFYTUEP/j6/z/e6R0KYXC0+KB6Vpr18
lhZuhQkbOgo69SYTyu+qosxubas/gOayV8sgBg6BDAEwlD2SNfYtZK+xa4w/orhe
F1UyD929hA4osr/wjV60witzF58Znr1EnGbEL8Mae78+GmIgR+fDc36uayEfluZe
oWT3whVaGsIDB8cpn2Pd4S/T/syqHFEqNrcrjAFcRHHBH/qoWRC+oTruLd9us7Vo
f0HpQtgBwsEvkY8YVLtsCI3Of6xkkzugFCvP9FdnInNVhqu1pgxC/62bNxq0zxPb
wqdkAsWUIfRqT/0SLO6L0S+vqoBe6GyWA1VeX+E/veqA1jxYxrGV8c1gR6RQ60Lo
JUNaeKzPfTZERvlhTgHPdaL+x418mm3GLwK+pQ2lT/1VbszH8Dh0vwsBURuEqNve
y+7/x9MM2kyclwgnAVjJ6D8rXJvfO2ugbK9mousTJoNL6Gws0WKbox6Sd4my0Uod
CewdyazqmE6iHVfTELaw5nsGpvlIK9t1qvnhbtCrkcgn0WFycBSeaVoBoKJNEBpR
9Dlsh1ZbsAr0xlaEqNEb8lcmvLRPvb1oNkYuyrpIShCOI8El2pa4z8fQorHZ/fOx
tazHJjzEU1PmFb3hsP7FE3sXBCHJ7PTA6RPoxp1QUkvzoo4XtEekYimmUUn2lGCj
6bgU67A470x9kEKjvSAt
=kt1d
-----END PGP SIGNATURE-----

--=-W38k9MQUiKUaHUdAT9vd--

