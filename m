Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbYGaNFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 09:05:19 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com> (sfid-20080730_180806_410329_7AD6F121)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
	 <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com>
	 (sfid-20080730_180806_410329_7AD6F121)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-CXrjY71MUdKL+NeUhQ04"
Date: Thu, 31 Jul 2008 15:05:11 +0200
Message-Id: <1217509511.10489.140.camel@johannes.berg> (sfid-20080731_150528_968430_E3E1DF79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CXrjY71MUdKL+NeUhQ04
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-30 at 19:08 +0300, Tomas Winkler wrote:

> > Can you explain how starvation happens? In what scenarios? With or
> > without aggregation?
>=20
> for (queue =3D 0; queue < QD_NUM(hw); queue++)
>=20
> This always starts 0  prioritize dequeue the first frame. But what we
> need is RR and let HW to prioritize the transmission according AC

That's from the old code not having real MQ though, right? I'm totally
not concerned about that.

johannes

--=-CXrjY71MUdKL+NeUhQ04
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkbiDAAoJEKVg1VMiehFYrUEP/1igRprfxQXwgJMA4MtwiKpd
XVRoCpOl9sjzb9kHKkohSWh9FHuPCbHdJzySuIj6QBwT3ElLtM8zvsj0h3qHkVe/
3706RZZ4DgxCNtiCsKhVLJZBjD+eqYWfMGi/9jhnT1IjilbbBL1GFUnCQb6Rj4rd
LynBl2/JImQwrPA0IsA91WFZ6L0bwLhqxj8hBwrKUUujiviWR+KZlguUre2p6F8S
MKuJ374g/A7ybTg6LlPDE85q1rPgUxRjJiwxS2v9HlBpy1L9j5fC1kKvlHId61J6
VjBljkwvQ6mntpn8yxRHRa6yL9RaCbwqG4Lfn14IDNCgJIkwKtb7ka1Gx3YnBICB
RpqX7HVirdBV/eL4eFf9uzq49nC+rWbx8OrQLWX6FkVJHbYJo+BR0+hu3vb8u/dL
I/2DIOfbep2UR9au5QMwDy8cHTzNslookDsQSSRlLJCYdFg6HRluckt7Puq5pxgJ
5MgAAKv7h7Rd4plvXbnp5A8L1+vfnIZoW+C6M8edRgWHXE3YwavJ8lTRT2Rkb5/x
Rck2pLZfokCuCXdwvAx+WgVSXUz6Ct2oePf8+OBMNkErLqcpvbEOgdE8xY8YG/T4
8Pzp2LH9Q5omXykQiEyKMv9uTb3wRZ+5QOy+1kjRhGKzNjkIQ1SsH7Z8rQQ5xO1S
i8TxvPVLVCzXwaHGxi7P
=Ha8+
-----END PGP SIGNATURE-----

--=-CXrjY71MUdKL+NeUhQ04--

