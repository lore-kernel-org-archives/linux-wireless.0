Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754579AbYKQRkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 12:40:45 -0500
Subject: Re: [PATCH ] zd1211rw: enable master mode. (wireless-testing)
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
In-Reply-To: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com> (sfid-20081117_165138_429172_482A518A)
References: <eb3ff54b0811170751p56544c8fic38d046a868f3bb8@mail.gmail.com>
	 (sfid-20081117_165138_429172_482A518A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-GbNKEt0+nJlPLi6QjXt3"
Date: Mon, 17 Nov 2008 18:40:08 +0100
Message-Id: <1226943608.3902.36.camel@johannes.berg> (sfid-20081117_184103_451298_C7984B1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GbNKEt0+nJlPLi6QjXt3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-17 at 17:51 +0200, Rami Rosen wrote:
> This patch adds initial support for master mode for zd1211rw USB
> wireless driver (via tools such as  hostapd).
> It enables basic functionality like association from a managed station
> and identifying the master mode by scanning from a station.

NAK. This device does not support multicast buffering.

johannes

--=-GbNKEt0+nJlPLi6QjXt3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIax1AAoJEKVg1VMiehFYyPAQAKDFl08O1H4phnjPvNy7djZL
NznFCK6sUh7zoOovP+rNsDeovbvH/EXN45z3UViNWbuhboK8+J3JGBRUIBKag20R
tpAhLlVB14WkFk4iC0WoTQWKJonwt0Yx7oR+X1hXUgIk2QlNV/8vFQGsIswEXskc
8uuQcb1khsqOP1s6fkYMQMpfm8Lx7UQfWDfHS5WCNSyrSWl949VtKoVMfAyJAfkf
LgVIL/qW4FNxv9e8Andd38Y88x+DbduQDXqcO42Ft3Qz1oyjMO8Ps4at0QxiEC+C
iTzxwp6QYj9mapeJAVBVts5NFltG2HAjH+bncr8nUrsHZMURxpiG0REmg98/hCv1
l1wjKNQCytGIBQ5NqR2ckAXZ76hcoYC5q/n8Jq1AiGNSoP8dehHDoksdM3eu4jdR
gMBRZ4P8a8P0HAjqCa4mTqygc/vy9VotBtDEBT/SFyUYw8mws9RKpW4kmuuCB0fC
7d18ctVyJwMAKT/giq4EPIJwkDxlniS86bk88Gx+qGwxkFZFmrVZP4Lwnjgdght1
avegFKE1NALAufPDWT3tT4YXph1N19G9D3CJIJRhyjGW579/epj5grGBSEoU9dNz
5lx3dMCO6XYbbs2Jxb57IcKqydSs24f73XgAzNGZYGmaJQBDYQBpBF7C1NnVKMWH
7FlTUuBGAv2CzA+egcCA
=0LYX
-----END PGP SIGNATURE-----

--=-GbNKEt0+nJlPLi6QjXt3--

