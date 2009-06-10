Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZFJHXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 03:23:13 -0400
Subject: Re: [PATCH] rfkill: include err.h
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: David Miller <davem@davemloft.net>, sfr@canb.auug.org.au,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090610013440.GA3523@tuxdriver.com>
References: <1244555812.4672.9.camel@johannes.local>
	 <20090609.174952.40068461.davem@davemloft.net>
	 <20090610013440.GA3523@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KANZ2/5w4teBGQg4AsSc"
Date: Wed, 10 Jun 2009 09:22:35 +0200
Message-Id: <1244618555.18481.52.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KANZ2/5w4teBGQg4AsSc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-09 at 21:34 -0400, John W. Linville wrote:
> On Tue, Jun 09, 2009 at 05:49:52PM -0700, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Tue, 09 Jun 2009 15:56:52 +0200
> >=20
> > > Since we use ERR_PTR and similar macros, we need to include linux/err=
.h.
> > >=20
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> >=20
> > I'm applying this directly to net-next-2.6 to fix the -next
> > build.
> >=20
> > Please submit the more critical build fixes for regressions
> > introduced by the wireless tree direclty to me in the future
> > thanks.
>=20
> That's a fine policy -- no objection.  However, please be aware that
> Stephen picks-up stuff from the wireless trees even when I haven't
> yet asked Dave to pull (so Dave might not always have the patch that
> causes the break).  So, just keep that in mind (and CC me as well,
> please). :-)

Alright, I'll do my best to differentiate based on what's in whose
tree :)

johannes

--=-KANZ2/5w4teBGQg4AsSc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKL180AAoJEODzc/N7+QmaWQcP/irOJvWBb26u8xgSJJBCSevi
q8kVazynhptLiR+qb2jnnkaHG6sMtQg6nuT1INSuLeriwCPTyyZTOCAsKFb63anN
DRxq+spVigXY3hw+w/U0wZNb8B1RVTBwhrpC1ExdcXXAG3Vsw08jPc3kNifFfSvR
UllE2330R2IKOvZSiSHNTjhMzuaJFbMeuScYpcf3l4sj+s5fR7/FyKeaUmyQpje3
3wX8DPY0jh2V82ZhI29BVYTQJec2830c4H9uZwGlmVJRnaRrRxuXveGXmrKGFtgt
CXbmsYSyAY0SyOSd22on8zuGaoFvg0k5+vLZ1jYo1gNb4CfNeAfo8RRhYH4PzRj4
Yi5mV3iYoPfNCG2hQpzuz9X812Xh/If/A0CjHALssns1afESu9LQeBgyv7r3v2Tl
yGKPjuOc3PNWXYP7H3wyTfQMlCQZ+IRqlRQhoE///lQkeF0y97irNhTpgPWFlWSa
X1Uz5sOLBjxXCVota+/tu2aWPNatd+KiXAb1jX4RffZKs+MQosAbu8Oqhf98JTAQ
DzyOGRTFNUZRr/a6/fmhu9/3jKAHaDHwGeTzgC9Ml7L/84RDI3/ALa7JfVx9dtAj
MAPzw6b/3CitWWqhkRBe7c/RmTeg3cbf+OPuGgEL5KBzSpzC6GS8BRSribsHkZvm
+QQfXsqBGfpcyloXLkl9
=KFvf
-----END PGP SIGNATURE-----

--=-KANZ2/5w4teBGQg4AsSc--

