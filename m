Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36008 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221Ab1EQDpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 23:45:32 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Gunnar Stahl <gunnar.stahl@gunnarstahl.org>
Cc: Richard =?ISO-8859-1?Q?Sch=FCtz?= <r.schtz@t-online.de>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	622753@bugs.debian.org, Adrian Chadd <adrian@freebsd.org>
In-Reply-To: <BANLkTikr6LBGPf8roLyf9n9yL=7qk4y72g@mail.gmail.com>
References: <20110414123925.31837.14741.reportbug@noomadix>
	 <1302785635.5282.690.camel@localhost> <4DA6EEF8.9090701@t-online.de>
	 <1302840012.5282.745.camel@localhost>
	 <BANLkTikr6LBGPf8roLyf9n9yL=7qk4y72g@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-pPbzLrrE7ryXF6HInD44"
Date: Tue, 17 May 2011 04:45:20 +0100
Message-ID: <1305603920.19966.119.camel@localhost> (sfid-20110517_054536_005308_A05C0288)
Mime-Version: 1.0
Subject: Re: ath9k: Connection over wlan slows down and dies
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pPbzLrrE7ryXF6HInD44
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-04-15 at 15:52 +0800, Adrian Chadd wrote:
> On 15 April 2011 12:00, Ben Hutchings <ben@decadent.org.uk> wrote:
>         [...]
>         > https://bugzilla.kernel.org/show_bug.cgi?id=3D31452
>        =20
>        =20
>         Thanks, I've set our bug tracker to follow that bug.
> =20
> Has it been established that it's the same bug though?
>=20
> I had a brief read of that and I'm not so sure. There's so many things
> that could impact TX throughput.
>=20
> I don't have this problem on FreeBSD on my AR9285 NICs and I've ported
> almost all of the (non-power saving) related code from ath9k. They
> happily sit at the expected TX/RX speeds in 11g and 11n modes.
>=20
> Is someone who is experiencing the problem able to do some kernel
> version bisecting between the known good and known bad kernel?=20

The bug fix from the report on Bugzilla has been included in stable
release 2.6.38.5 and Debian's version 2.6.38-5.

Does this version fix the problem for you?

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-pPbzLrrE7ryXF6HInD44
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATdHvT+e/yOyVhhEJAQqz5BAAqpZNudtfzhpA7H7kkkybplsyP2y37syi
5S7uuMgz3305QWapohI2/X+ASNsWE9OT3Pnb04Ka/z/PWpGjbAL+znQq6kQkgxWQ
c46hEuUllLXyLlKWRBRNEh80U+nhG61+ts0Xz8s4T4CtGlU1sgnPDABKxbMssK27
ngOTRNZjMS67VjXbNR/77MmpeB+/8uPSouuA/GOFzvgebYgfX2MCIUAemN1ad04U
gJR66AfV1G3nmg0x5zxwxXVtlxW5L3lykc+tdDOWQ1pUTNCSVGX7Zgu6A6wa+X7N
WrFNob1v0FduE8OWzTQ7EnbqpfUw7ccNgdaKpc/H4lEp+kpn3NY8gjIuM0paK/Pq
uBOyXKngAUReklBltq38Ui+BjHbdY2nPqpIuWOKp5K06e0y3Ur7srPV/DaNuVwpf
iPhP+9j35yFabkup7Ek1c2kvKtVRB53+OzigYvYILGnuqFdQE6mZDgyjuhTNvgvN
06YVlxmamRrVwFZRGIg1rc52LHo+Yb8u5pPSTV0anbm7jKAVSispYeuGL3XsBuGW
u2+Azmw6pUrFEMWIbQ/3VU7ae/EputckDeOCZwQlAvic8saJfmDJGx8ziVigbEDL
s4adBL8CNUyspcA8wNsZ/2EUa9dWNMxShUfuVqLjkuln72uqT3NSQcYl6tjgNEbM
HQex+CjATfc=
=2rTT
-----END PGP SIGNATURE-----

--=-pPbzLrrE7ryXF6HInD44--
