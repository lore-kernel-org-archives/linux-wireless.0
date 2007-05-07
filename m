Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9301 "EHLO annwn13.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934329AbXEGPlE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2007 11:41:04 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] Add 93cx6 eeprom library
Date: Mon, 7 May 2007 11:40:25 -0400
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, John Linville <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Jeff Garzik <jeff@garzik.org>
References: <200705070346.04982.flamingice@sourmilk.net> <20070507142715.GB32546@fluff.org.uk>
In-Reply-To: <20070507142715.GB32546@fluff.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart28748411.TuTEUJFSIm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705071140.29435.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart28748411.TuTEUJFSIm
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 07 May 2007 10:27, Ben Dooks wrote:
> On Mon, May 07, 2007 at 03:46:04AM -0400, Michael Wu wrote:
> > From: Ivo van Doorn <ivdoorn@gmail.com>
> >
> > This patch adds a library for reading from and writing to 93cx6 eeproms.
>
> This looks remarkably like an SPI device, why not use the
> spi framework to drive this?
>
Yeah, it's SPI/microwire. As for using the SPI framework.. I dunno. The rt2=
x00=20
drivers depend on this too and I'd rather not change the code at this point=
=20
since it's well tested and working. Thanks for the heads up about using SPI=
,=20
however. I (or maybe Ivo if he has any time) will check the SPI framework=20
later and see if that simplifies things.

=2DMichael Wu

--nextPart28748411.TuTEUJFSIm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGP0htT3Oqt9AH4aERAoCMAJ9Xc1wZ3D+umBZPbL0PsiWHwP6ESwCgoNr4
635h2sCf7D8z8hsf9UFGLko=
=b10o
-----END PGP SIGNATURE-----

--nextPart28748411.TuTEUJFSIm--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
