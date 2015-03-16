Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34289 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933838AbbCPU6y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 16:58:54 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v6 6/6] wlcore: remove wl12xx_platform_data
Date: Mon, 16 Mar 2015 21:58:50 +0100
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
References: <1426162154-8716-1-git-send-email-eliad@wizery.com> <2070859.WcMooC33YH@wuerfel> <20150316152939.GP5264@atomide.com>
In-Reply-To: <20150316152939.GP5264@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2394951.4rG3PKCz3q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <201503162158.50587@pali> (sfid-20150316_215859_788018_566CC797)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2394951.4rG3PKCz3q
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 16 March 2015 16:29:39 Tony Lindgren wrote:
> I believe the last pending issues is the support for
> ATAG_REVISION in device tree mode as posted by Pali.
>=20

No. In DT boot there is missing /proc/atags file (readable by=20
userspace processes). And also broken AES/SHA/MD5 support. Fix=20
for crypto DT stuff I already sent.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2394951.4rG3PKCz3q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlUHRAoACgkQi/DJPQPkQ1L/dwCfRCUG0IYxQIYaZfCmkq2uNjTz
WhIAoJqZnxe8b6bSnrw1AQHyDYVifALf
=du7Z
-----END PGP SIGNATURE-----

--nextPart2394951.4rG3PKCz3q--
