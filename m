Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38723 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107Ab2ETVP7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 May 2012 17:15:59 -0400
Message-ID: <1337548550.4107.363.camel@deadeye> (sfid-20120520_231603_219307_5207CA70)
Subject: Re: Bug#673703: linux-image-3.2.0-2-686-pae: module ipw2100 doesn't
 report signal strength
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: 673703@bugs.debian.org,
	"Gennady N. Uraltsev" <gennady.uraltsev@gmail.com>
Date: Sun, 20 May 2012 22:15:50 +0100
In-Reply-To: <1337548101.4107.357.camel@deadeye>
References: <20120520204153.15102.40326.reportbug@halen.sns.it>
	 <1337548101.4107.357.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-2q2a2Qrg9jZ7S614T49M"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2q2a2Qrg9jZ7S614T49M
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-05-20 at 22:08 +0100, Ben Hutchings wrote:
> On Sun, 2012-05-20 at 22:41 +0200, Gennady N. Uraltsev wrote:
> > Package: linux-2.6
> > Version: 3.2.17-1
> > Severity: important
> > Tags: upstream
> >=20
> > The ipw2100 module fails to report signal strength.
>=20
> ...when scanning.
>=20
> > With a Intel 2100 3B mini card this makes it impossible to use standard=
 tools
> > for wireless. As a matter of fact roaming decisions and many others of =
standard
> > software are based on these values.
> [...]
>=20
> This appears to be a hardware/firmware limitation, which will not be
> fixed.

I'm forwarding this on to linux-wireless in case someone can see a way
to fix this.

Ben.

--=20
Ben Hutchings
All extremists should be taken out and shot.

--=-2q2a2Qrg9jZ7S614T49M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7lfBue/yOyVhhEJAQrI4hAAs3W/87SyI+0TQ+0rPVS6KwMb2vAIDsvK
hFyTpFpp9YVnpXhgyXwJzLZRSHNH56zYnRv15CY3iUyfkT2u1eqy3B2Jm2YTg2rX
fMZScrebqkAlWnfO7pqG15FGyioXlEtCqGSSKeZaLr+K1lOXJ+R5s7SsTg94OGwj
PUfeEFsrPwAY4FDPadCqnYxQHahOv19k1kB4uUX6rHi96qzrzHJUXzbXf2GpaMW8
6VtQ8NSVkJFYrP6oNTVMhaSIGyTrxbXHzR4koFv+fQI1tkntW6jOcYbhpd7FlD/n
Vg6Hl8gsoGu7XAmY8DGC8izKaizk93/j37DrO0btZ0drJddE2w7lqfNa2zpIpNkB
SMRXw03gLpeXDX817lI+TrZr65sU192uKD94re/rukOoIRswqpXRgMBA1AO44ngC
i2kvCoASCUfxG4rtipRmUlw+BF7hinB/blF2W/K/PYxcpGopP9nc1NovXoa+lrlE
K5nK27WBAo0ySRshLO0CvVPSKlzCjjR8tZ3HG/rArGYKH/emmY0qyHroPdUtSqY9
v+cWcVjuiJOnUZ9xQ4xd/d+UW2Llos2P91qJeirS9AGzm7eLT8uCrw0QOg9dhjBW
iphwZRdnPZSf+jtaO12Ib8KSjswYKjVmNlHrR6k7PMdee3L7dTVJ0afmQFsp3iPG
QFkR5FrqRgA=
=tEzy
-----END PGP SIGNATURE-----

--=-2q2a2Qrg9jZ7S614T49M--
