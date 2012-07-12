Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from storm.alittletooquiet.net ([67.23.28.199]:37708 "EHLO
	storm.alittletooquiet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895Ab2GLA3o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jul 2012 20:29:44 -0400
Date: Wed, 11 Jul 2012 20:21:49 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: linux-wireless@vger.kernel.org
Subject: Anyone using rtl8192de with 2.4GHz 802.11g?
Message-ID: <20120712002149.GA14850@alittletooquiet.net> (sfid-20120712_022948_423966_15792A68)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

The rtl8192de driver is working fine for me at 5GHz, but I am having trouble
getting scan results for 2.4GHz 802.11g networks.  I have been doing a lot =
of
debugging but am not making much progress.  I suspect the 802.11 b/g/n phy =
is
not being initialized correctly, but I'm pretty far outside my domain on th=
is
one.

Is anyone successfully using this driver with a 2.4GHz 802.11g network?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.rapidrollout.com

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/+GJ0ACgkQRO4fQQdv5Az2tgCgi3fyIm26KodMp3woZ5LAsfXP
FFUAoJkOCi0GUAYMnsKslCEGndUfLa4L
=ctS+
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
