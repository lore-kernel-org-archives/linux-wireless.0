Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout.hostsharing.net ([83.223.95.98]:40765 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbXKPB37 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 20:29:59 -0500
Date: Fri, 16 Nov 2007 02:29:50 +0100
From: Elimar Riesebieter <riesebie@lxtec.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 2.6.24-rc1 freezes on powerbook at first boot stage
Message-ID: <20071116012950.GB3948@aragorn.home.lxtec.de> (sfid-20071116_013005_970393_BDA1B3D8)
References: <20071024120739.GA4897@aragorn.home.lxtec.de> <20071024124109.GA9442@frodo.home.lxtec.de> <20071104032006.GG9695@localdomain> <20071113220235.GB9008@frodo.home.lxtec.de> <1195053964.4091.20.camel@johannes.berg> <20071114193340.GA14921@frodo.home.lxtec.de> <1195145325.13846.70.camel@johannes.berg> <20071115182144.GA3199@samweis.home.lxtec.de> <1195151212.8147.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
In-Reply-To: <1195151212.8147.10.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Nov 2007 the mental interface of
Johannes Berg told:

>=20
>=20
> > Nov 15 18:51:31 samweis kernel: NIP [c02b3060] rfkill_register+0x6c/0x1=
2c
> > Nov 15 18:51:31 samweis kernel: LR [c02b302c] rfkill_register+0x38/0x12c
> > Nov 15 18:51:31 samweis kernel: Call Trace:
> > Nov 15 18:51:31 samweis kernel: [c7517d50] [c02b302c] rfkill_register+0=
x38/0x12c (unreliable)
>=20
> That was fixed post -rc2.

git5 runs well ;)

Thanks, Elimar

--=20
  Never make anything simple and efficient when a way=20
  can be found to make it complex and wonderful ;-)

--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHPPKO3Ig8bsVPf7ARAqu5AKCUZejc7UbIvLxIt1yXCZoLK8mUWwCgg+tm
UtpmoT01inMkrn3PYOIOmnc=
=BSoD
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
