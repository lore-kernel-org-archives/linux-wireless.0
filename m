Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430AbYFZSYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:24:30 -0400
Subject: Re: [PATCH 1/2] mac80211: add power management support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Samuel Ortiz <samuel@sortiz.org>,
	Miguel =?ISO-8859-1?Q?Bot=F3n?= <mboton.lkml@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com
In-Reply-To: <20080626175507.GA23142@tuxdriver.com> (sfid-20080626_201701_325174_F72A9F8D)
References: <200711161929.36283.mboton.lkml@gmail.com>
	 <200711161953.26801.mboton.lkml@gmail.com>
	 <20080626174058.GA3063@sortiz.org>  <20080626175507.GA23142@tuxdriver.com>
	 (sfid-20080626_201701_325174_F72A9F8D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jV/nK423R9HBnaS2QJew"
Date: Thu, 26 Jun 2008 20:23:43 +0200
Message-Id: <1214504623.3783.22.camel@johannes.berg> (sfid-20080626_202445_253350_555EFC8A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jV/nK423R9HBnaS2QJew
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-26 at 13:55 -0400, John W. Linville wrote:
> On Thu, Jun 26, 2008 at 07:40:58PM +0200, Samuel Ortiz wrote:
> > Hi John,
> >=20
> > On Fri, Nov 16, 2007 at 07:53:26PM +0100, Miguel Bot=C3=B3n wrote:
> > > Ok, the previous patch had a little error.
> > >=20
> > > --
> > >=20
> > > This patch adds power management support in mac80211.
> > Sorry for being late to the game, but would a similar patch against you=
r
> > -next-2.6 tree be considered for inclusion ?
>=20
> It seems like a reasonable start to me.  Anyone else have comments?

I had one about it returning -EINVAL for all errors that was never
addressed afaict.

johannes

--=-jV/nK423R9HBnaS2QJew
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJIY96sAAoJEKVg1VMiehFY/6QP93D8Pc3TZ2pw4EUEGAv5CphX
ivtJfrYmK0O2FhiuT3V+kwxZrbbXgt199tP+oJ9S6ZYsECff5bQCoY5Oixq73CDN
qF2EmGvEkqtPJbPbmb+a7TrP58T5quEAMZHZJ0bYgiZuVRH/PCeT3DEEkTEZtbKF
9hftyQ7TsPN8jXlDhXp0vUOCd5n9lNoNRjM6AwLKHIgpogI4rZAA0aX0f0RF6zD9
qQSws1qJbwb9ywQ/fbl24+0FWvE9eR5+hfw4/HB9usIBiNZXr2QzhgvRv12rKFci
8O16A9dEoOSEDFdDfhFFpPt2CmomF9pznN4HOU/0Bf7rYPW6puheC437bJwru6x+
NIzTah/zRIj9CjXY02NaSux9nZtpEulCD6YPc6kHpnDhbNt/MLLMI8vSJGBpNKZ5
xZQR0IhCOmI8hRPBq/rRz4iQDPGKw1w3Qv7YOD7kK/GcCqmESqGeUVI79B2I8j+7
qlOnTHG7NitLGGALVMBC/m1fwhbwxZfMjgV5LoMpwxSzdgCMZIfrprKpq81HdwQc
1ttNmrSjSUP+SJBfJUIqLpG8oXGDziQ8Q/j0qEEkqGrBXiO+eh+xietXipO/U15q
CQM7T2FR8KToqSN9/QJBNTFzn9SDgfZr+whyl3+znCMtW7j8o2KeIx+xz4SGQBni
BhgSMx6jxXMqeWkShOI=
=ktaN
-----END PGP SIGNATURE-----

--=-jV/nK423R9HBnaS2QJew--

