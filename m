Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755763AbZE0G2L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 02:28:11 -0400
Subject: Re: [PATCH v11] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Will Keaney <keaneyw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090527025516.GC22235@khazad-dum.debian.net>
References: <1242942720.4212.19.camel@johannes.local>
	 <1243068246.4606.45.camel@johannes.local> <4A1BDE51.7020009@gmail.com>
	 <20090526131533.GA3932@tuxdriver.com>
	 <20090527025516.GC22235@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oal3xNPYt8EQuE8jTqWv"
Date: Wed, 27 May 2009 08:28:02 +0200
Message-Id: <1243405682.26933.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oal3xNPYt8EQuE8jTqWv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-26 at 23:55 -0300, Henrique de Moraes Holschuh wrote:

> As long as the missing userspace control functionality (the lack of which=
 is
> a _serious_ regression for platform drivers) is added before 2.6.31 ships=
, I
> have no complains.
>=20
> Userspace must be able to change the (soft) state using sysfs.  This is
> not an optional part of rfkill :-)

I'm sorry, but you're wrong. Before I removed it, almost all drivers
disabled that functionality. We do want to add it back, but certainly
not with the mostly braindead interface it used to have.

johannes

--=-oal3xNPYt8EQuE8jTqWv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKHN1vAAoJEODzc/N7+QmaeCkP/iEZsRJrxMZMl0+R4xBEfosO
u1oFETnXsPmor6Bjm+fR9la0fTbGHq+GE4mFfOexRG3Hdy1jsWbFGDaw/zKxlNXh
fq6OppTER9ZSXmzBVGNbOkdeNfReCrM3el+LH++PYvx0Lp3VNT9jZRyBCsdpuHSg
qgj4LoHkMEPYJ5cYVtPKIylJEGDn24gU0KCKrS2bBWBkwWI0t77h8Olz1eCseZ8Q
6AgruPBnibr+Nm/7CdbtBw8Y/fgDVwLF8Yn8dKbIeKtaE5rtSkZGDEjFOJz0MMaq
i/C3Ztdx8hMuykAlvahyrcqv06sSLfCBc1jrrmT+ziJxtvDi9sqqcoHK23CGRMqV
bCVoWgAqx0K/OXKSZPH8dPmrCiqvzN6H+nq+BkhIBwrsSzMHMIPd1B9FHtSCLUh1
NSSdFsoBkG3PAwG+2fdwRMfGkMM8OQ47Zkr2gwGAD62YzrorEC7X7zSmhKbIuXm2
oWNDNRmoD9yfusAdW3q24LEt2dM4zla9Gzn3fpkTDfXPFZ3AhPeun4aEKkKp0sE2
0dcJnp5a0aRNfIX0hagFGlNZiWxnM8TvXvuhpNy2mwVbKabx30wUwKGZPBc/+3kS
z4EQE6xiBDYjXh/PYg4KI7Z0EQaVHbE3tJkzkScxeuMpEdTuKjH1MVnRMA5ZRj8o
UdvimJHyBpe+LnLxjCsc
=tLZa
-----END PGP SIGNATURE-----

--=-oal3xNPYt8EQuE8jTqWv--

