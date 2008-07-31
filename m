Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.tu-cottbus.de ([141.43.99.247]:53612 "EHLO
	smtp1.TU-Cottbus.De" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbYGaWwu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2008 18:52:50 -0400
Date: Fri, 1 Aug 2008 00:43:57 +0200
From: Eugeniy Meshcheryakov <eugen@debian.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Q: support for AVM Fritz! WLAN USB in kernel 2.6.25+
Message-ID: <20080731224357.GA9741@localhost.localdomain> (sfid-20080801_005256_222874_A96C698B)
References: <4891D1B9.70703@imap.cc> <1217517915.10489.143.camel@johannes.berg> <4891E97C.1060302@imap.cc> <20080731165054.GA14485@tuxdriver.com> <4892391D.2010305@imap.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
In-Reply-To: <4892391D.2010305@imap.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

1 =D1=81=D0=B5=D1=80=D0=BF=D0=BD=D1=8F 2008 =D0=BE 00:13 +0200 Tilman Schmi=
dt =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=B2(-=D0=BB=D0=B0):
> So as soon as the AVM driver switches the stick from storage mode (where =
it
> offers Windows drivers for installation) to WLAN mode, the acx module sho=
ws
> up.
>=20
> Anything I should try?
If you see some new device like /dev/cdrom? or /dev/sr? after inserting
the stick (and without closed source driver), try to run 'eject' on it.
Hopefully this device will disappear and stick will switch to WLAN mode.
Then try to load acx module. If it works, then it is possible to do this
automatically with udev. This works with my UMTS modem.

Regards,
Eugeniy Meshcheryakov

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiSQC0ACgkQKaC6+zmozOLGgACcDUZ3OKxc+fgrxL1i+F0VTN36
zTUAn3QQv31iBS89hyHw90pWS+S4vo2t
=DwHW
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
