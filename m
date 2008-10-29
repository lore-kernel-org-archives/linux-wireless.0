Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx30.mail.ru ([194.67.23.238]:16154 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbYJ2Dn7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 23:43:59 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
	"Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.28-rc2: new PCMCIA device instance after resume - orinoco can't download firmware
Date: Wed, 29 Oct 2008 06:43:50 +0300
Cc: linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net
References: <200810282219.51492.arvidjaar@mail.ru> <20081029004235.GA17879@isilmar.linta.de>
In-Reply-To: <20081029004235.GA17879@isilmar.linta.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1431681.2TQ0hodyI7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200810290643.54707.arvidjaar@mail.ru> (sfid-20081029_044410_561693_899102B7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1431681.2TQ0hodyI7
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 29 October 2008, Dominik Brodowski wrote:
> Hi,
>=20
> On Tue, Oct 28, 2008 at 10:19:50PM +0300, Andrey Borzenkov wrote:
> > I am running PCMCIA based orinoco with WPA support (external firmware)
> > and two patches to cache it after request_firmware to use in resume.
> >=20
> > This worked fine in 27 and wtopped working in 28-rc. The apparent diffe=
rence
> > I see:
>=20
> Hm, can't find any suspect patch which would change this behaviour in PCM=
CIA
> land. Could you try to bisect it on {drivers/base/ kernel/power
> drivers/pcmcia drivers/net/wireless/orinoco*.c} possibly?
>=20

Yes, I too checked log for drivers/pcmcia and could not find anything
spectacular.

I am afraid I can't estimate when (if) I will be able to do bisect :(

Rafael, it looks like some serious changes in suspend/resume framework?
Do you have any idea what could it be? Original message is here:
http://marc.info/?l=3Dlinux-wireless&m=3D122522165719760&w=3D2

TIA

=2Dandrey

--nextPart1431681.2TQ0hodyI7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkH2/cACgkQR6LMutpd94z7aACeP4lsm3RECoNFCj3mhFyPBQXy
vUAAoMwt67NpqMT8XdsBoel/LSrcruwf
=RLJn
-----END PGP SIGNATURE-----

--nextPart1431681.2TQ0hodyI7--
