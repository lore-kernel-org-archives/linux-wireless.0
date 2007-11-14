Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout.hostsharing.net ([83.223.95.98]:33646 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbXKNTds (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2007 14:33:48 -0500
Date: Wed, 14 Nov 2007 20:33:40 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
Message-ID: <20071114193340.GA14921@frodo.home.lxtec.de> (sfid-20071114_193352_990800_C3C8FC46)
References: <20071024120739.GA4897@aragorn.home.lxtec.de> <20071024124109.GA9442@frodo.home.lxtec.de> <20071104032006.GG9695@localdomain> <20071113220235.GB9008@frodo.home.lxtec.de> <1195053964.4091.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
In-Reply-To: <1195053964.4091.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Nov 2007 the mental interface of
Johannes Berg told:

>=20
> [FWIW, my powerbook worked with -rc1]
>=20
> > 2.6.24-rc2 works so lala :)
>=20
> > b43 doesn't authenticate via wpa (bluetooth isn't loaded):
> > WEXT auth param 4 value 0x0 - ioctl[SIOCSIWAUTH]: Operation not support=
ed
> > WEXT auth param 5 value 0x1 - Internet Systems Consortium DHCP Client V=
3.1.0
>=20
> Those error messages are unrelated. My b43 works fine, even with a
> multi-MAC patch.

I tried it as follows:

wpa_supplicant -Dwext -ieth2 -c/etc/wpa_supplicant/wpa_supplicant.conf

eth2 is renamed by udev via MAC address.

b43-fwcutter intalled

Could you please enlighten me.

[...]=20
> What is the problem? Why is this on wireless? It'd help if you'd make
> one message per problem and post it to the correct mailing lists.

My apologies. Next time I'll separate the regressions.

Thanks for cooperation
Elimar


--=20
  It's a good thing we don't get all=20
  the government we pay for.

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHO02U3Ig8bsVPf7ARAizCAKCNiKnytJu/kRaGxBdORjJ8YG0srACcC/3E
5FIvTfaCwKt7r9gtqAvY4io=
=nqYa
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
