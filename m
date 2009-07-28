Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58838 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbZG1Iey (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 04:34:54 -0400
Date: Tue, 28 Jul 2009 10:34:52 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-pcmcia@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: Problem with exclusive interrupt in hostap_cs
Message-ID: <20090728083452.GC3170@pengutronix.de>
References: <20090420101340.142b6bc6@dp-indexing.com> <49ECCABE.40805@lwfinger.net> <20090420225740.25307.qmail@cdy.org> <20090421103617.05737b01@dp-indexing.com> <49EDF923.2020102@lwfinger.net> <4A6DB08F.2060108@pengutronix.de> <4A6E2A12.30009@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
In-Reply-To: <4A6E2A12.30009@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> As Dominik was missing and there was no action on the linux-pcmcia
> list, I took advantage of the fact that this is a wireless device and
> submitted the patch to John Linville. It is commit
> e4a01604b8e5656f3a059f52b3e8f2560740c057 in the wireless-testing tree
> and was sent to DaveM on July 24 for linux-next. It will be in 2.6.32.

Great. IMHO the netdev-tree was the more apropriate one anyhow. It seems it=
 got
into linux-next shortly after I checked, so sorry for the noise!

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpuuCwACgkQD27XaX1/VRsBEwCgtA2Rp6j5ztewzt5w0D9IWs19
XasAn3UU3j+SF2Uy4jtH5WUmNjDFzfOR
=wAz4
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
