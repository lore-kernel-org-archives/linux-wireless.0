Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:35548 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3EQAFC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 20:05:02 -0400
Date: Thu, 16 May 2013 19:45:26 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Ignacy Gawedzki <i@lri.fr>,
	Oleksij Rempel <linux@rempel-privat.de>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
Message-ID: <20130516234526.GH3795@alittletooquiet.net> (sfid-20130517_020507_871739_4276D8FF)
References: <20130515134258.GA9033@zenon.in.qult.net>
 <5194DEB3.2060407@rempel-privat.de>
 <20130516172030.GD21850@zenon.in.qult.net>
 <51951B90.70909@rempel-privat.de>
 <20130516185030.GB16833@zenon.in.qult.net>
 <20130516234857.GA17867@zenon.in.qult.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
In-Reply-To: <20130516234857.GA17867@zenon.in.qult.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, May 17, 2013 at 01:48:57AM +0200, Ignacy Gawedzki wrote:
> On Thu, May 16, 2013 at 08:50:30PM +0200, thus spake Ignacy Gawedzki:
> > I'll try on yet another one and will tell you the results.
>=20
> Just tried on ICH7, same thing.  The easiest way to reproduce the bug is =
to
> boot into single user mode ("recovery mode" on Ubuntu), in order to preve=
nt
> any NetworkManager or udev from interfering.  Then, without any attempt t=
o up
> the interface, reboot the system by typing "reboot" in a root shell.

FWIW, this has also been a problem for me on Ubuntu 12.04.  I can reproduce=
 it
the same way.

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGVb5YACgkQRO4fQQdv5AyWvACfYgoWIzov3K0GKv2SGzsIgmKI
GK0An3RPpceARzNCkIjRvyXNkfuwTAuI
=WWRz
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
