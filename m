Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:24177 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858Ab2EJNHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 09:07:17 -0400
Date: Thu, 10 May 2012 09:07:11 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Kevin Groeneveld <kgroeneveld@gmail.com>
Cc: Dmitry Tarnyagin <abi.dmitryt@gmail.com>,
	Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
Message-ID: <20120510130711.GA15533@shaftnet.org> (sfid-20120510_150722_525129_C5EC5CC6)
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
 <4FA15A70.2020108@stericsson.com>
 <CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com>
 <CAMG6FYgcep04reRKFe6vjpW+THbCT=+FnJ_-eLrcgE7+3UJEfA@mail.gmail.com>
 <CABF+-6XSA8OOjwuQqM-iDKHVTriJ04BzfA-VN0MqVAiN_ZrsEA@mail.gmail.com>
 <20120509203730.GE17416@shaftnet.org>
 <CABF+-6VUMoueQTA5_JUEOjiya5eQY=bAzt=cnr23HJ=ssedQSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
In-Reply-To: <CABF+-6VUMoueQTA5_JUEOjiya5eQY=bAzt=cnr23HJ=ssedQSw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 09, 2012 at 04:59:21PM -0400, Kevin Groeneveld wrote:
> As I mentioned in a previous post I am using the SG901-1091 module
> from Sagrad.  The only SDD file I have tried that works is also from
> Sagrad.  It makes perfect sense now that SDD files from other sources
> do not work.
>=20
> I still wonder why there is a PTA record in the SDD file if the
> SG901-1091 module does not have Bluetooth.  Could this negatively
> effect performance if it is trying to play nice with Bluetooth when
> Bluetooth is not being used?

I don't believe it will cause any problems, as the bluetooth pins aren't=20
hooked up on the SG901-1091 module.  That said, the PTA record on the=20
current Sagrad SDD files for the 1091/1098 modules specifies that BT=20
coexistence is disabled (ePTA mode =3D 0), so it should be functionally=20
equivalent to no PTA record being present.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFPq71/PuLgii2759ARAuVlAJ0SBJXZme7HZPHnw15QUY709d14QgCgiYjV
7J3JNSvBsIxrZymThtR87OA=
=OMub
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
