Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.anarazel.de ([217.115.131.40]:47414 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116AbYI2IfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2008 04:35:04 -0400
From: Andres Freund <andres@anarazel.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: bad DMAR interaction with iwlagn and SATA
Date: Mon, 29 Sep 2008 10:27:49 +0200
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Muli Ben-Yehuda" <muli@il.ibm.com>,
	"Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200809251511.20132.andres@anarazel.de> <1222441955.3798.13.camel@johannes.berg> <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
In-Reply-To: <1ba2fa240809261630y7a8e5f20g75ab47ff98a1e614@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1577835.l5VFPfxJ2h";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200809291027.50453.andres@anarazel.de> (sfid-20080929_103509_209488_62F5C33A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1577835.l5VFPfxJ2h
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

On Saturday 27 September 2008, Tomas Winkler wrote in "Re: bad DMAR=20
interaction with iwlagn and SATA":
> Meanwhile it all reported bugs in this case points to 64 bit
> installations, I'll give it more testing
Would it help to test on 32bit? I have some dissk with 32bit system install=
ed=20
lying around somewhere...

Any other patches to try?

Andres

--nextPart1577835.l5VFPfxJ2h
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjgkYYACgkQporPraT14ih2MwCfSIgBIgsrNfWIhpQh/bzMNsX9
u68An1P8oc0Ar347iHUA49Vmg0IhSLGS
=hT7l
-----END PGP SIGNATURE-----

--nextPart1577835.l5VFPfxJ2h--
