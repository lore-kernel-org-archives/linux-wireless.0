Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36181 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755030Ab2F3Oz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 10:55:29 -0400
Message-ID: <1341068113.4852.25.camel@deadeye.wl.decadent.org.uk> (sfid-20120630_165603_739064_87DB7225)
Subject: Re: linux-firmware: pull-request wl12xx 2012-06-27
From: Ben Hutchings <ben@decadent.org.uk>
To: Luciano Coelho <coelho@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org, arik@wizery.com
Date: Sat, 30 Jun 2012 15:55:13 +0100
In-Reply-To: <1340817712.1631.633.camel@cumari.coelho.fi>
References: <1340817712.1631.633.camel@cumari.coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-l6/TW8WCLnWH6dtIf8Wz"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l6/TW8WCLnWH6dtIf8Wz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-27 at 20:21 +0300, Luciano Coelho wrote:
> Hi Ben,
>=20
> Here are some new versions of TI's WLAN firmwares.  Also a new one for a
> new chip we started supporting recently.
>=20
> Please let me know if there are any problems.

This adds firmware that's requested by a new driver:

[...]
>       wl18xx: add firmware for WiLink8 WLAN chips
[...]

The new driver should get its own section in WHENCE.

Ben.

--=20
Ben Hutchings
Lowery's Law:
             If it jams, force it. If it breaks, it needed replacing anyway=
.

--=-l6/TW8WCLnWH6dtIf8Wz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT+8TUee/yOyVhhEJAQoRgg//e4mK8YHCjYCoyMEeQq1QFj3Hpea1JD1u
fVu/XpzUC26D9TGuOpW53cpnw0jU0dox6KutCBwddPmM77W1QI4QfFUI0TjENxxS
dHO0mmdsOb3t2isV2Ns+v97clsKLjMxNrYx8Oe56grRpLrFTNJvnTnk/TqUXCVmv
QlFqttRSjN2Bwl4AtJA4rFY6GlGd3G9Ex8O3E5G08lFy3zwAasIakW/BMIsWIaL6
ukGFX14KowN+4ARisMFHES5OXzDGdFcoF3szwJFqeyIW+EJ4wpMtSrCHU/jDn+lO
1PO+7PjTxA5Ab3911cdTL9QabOdLqfhSl2iAMj/Q0C2hQpwd0fuBTv97jlFNKWy3
6sEVhPPaqvmI4mlK2+OUsk7QZ8swVbR2f8EbuEEknziV3B9EAfgqOLsHrtyuivmF
m2saoGod3hoc/43ZMNKgab9Gan9HWZsZO/+p2qSnGNN/7HNWJa54jCycGQCiPoS4
jIN8DTbXrJXl8+VTcaROFOMEmvNRtXVBdFXV9oI0eA6Kc2BQ6doRmt37L6djSP9o
4GNNsGml8pLeQL+Og2c5vJMDIZW2n1vsUAB8h6bUSW2Ma4gqFpmGe1UXJNzS6r+K
U3SDn+5aRJ3KqN10Dpwz9KQ4ZKTPHf+ytRlRKMzAoLuX40PbBBJR4/Tf2LkO4Fsz
9BLF33GuYT0=
=dLYb
-----END PGP SIGNATURE-----

--=-l6/TW8WCLnWH6dtIf8Wz--
