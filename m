Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:33896 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779AbbCPVPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 17:15:10 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v6 6/6] wlcore: remove wl12xx_platform_data
Date: Mon, 16 Mar 2015 22:15:06 +0100
Cc: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org,
	Eliad Peller <eliad@wizery.com>,
	Mark Rutland <mark.rutland@arm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Enric Balletbo i Serra <eballetbo@gmail.com>,
	Sekhar Nori <nsekhar@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kevin Hilman <khilman@deeprootsystems.com>,
	Rob Herring <robh+dt@kernel.org>,
	=?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Kumar Gala <galak@codeaurora.org>,
	Javier Martinez Canillas <javier@dowhile0.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Luciano Coelho <luca@coelho.fi>
References: <1426162154-8716-1-git-send-email-eliad@wizery.com> <201503162158.50587@pali> <20150316210143.GF12397@atomide.com>
In-Reply-To: <20150316210143.GF12397@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4421972.f2NvejiPmL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201503162215.06436@pali> (sfid-20150316_221521_434165_76F32E35)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4421972.f2NvejiPmL
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 16 March 2015 22:01:43 Tony Lindgren wrote:
> * Pali Roh=C3=A1r <pali.rohar@gmail.com> [150316 13:59]:
> > On Monday 16 March 2015 16:29:39 Tony Lindgren wrote:
> > > I believe the last pending issues is the support for
> > > ATAG_REVISION in device tree mode as posted by Pali.
> >=20
> > No. In DT boot there is missing /proc/atags file (readable
> > by userspace processes).
>=20
> Oh OK thanks for the update.
>=20
> > And also broken AES/SHA/MD5 support. Fix for crypto DT stuff
> > I already sent.
>=20
> But this is not a regression in mainline with legacy boot vs
> device tree based booting, right? Sounds like it never worked
> in the mainline or am thinking of some other set of patches?
>=20
> Regards,
>=20
> Tony

In legacy board code are DMA channels defined. In DT files not.=20
So I think this is regression. Omap secure devices are broken in=20
both legacy & DT code, but non secure could work with legacy=20
code. But all devices booted with DT are broken.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart4421972.f2NvejiPmL
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEUEABECAAYFAlUHR9oACgkQi/DJPQPkQ1IhNQCVELNe1gVIPPPrPwemu8Z7K4Ml
7QCgwsZ9t67OaNK8Bdmi+lJRjGY//mM=
=npYa
-----END PGP SIGNATURE-----

--nextPart4421972.f2NvejiPmL--
