Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43253 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbYIRR3c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:29:32 -0400
Subject: Re: [PATCH] iw: add kernel version checks for pending upstream
	kernel features
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221758783.6782.29.camel@californication>
References: <>  <1221748533-11000-1-git-send-email-linville@tuxdriver.com>
	 <1221752489.9262.81.camel@johannes.berg>
	 <1221758783.6782.29.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dbIUxST91flkfo4k+Boc"
Date: Thu, 18 Sep 2008 19:28:54 +0200
Message-Id: <1221758934.9262.89.camel@johannes.berg> (sfid-20080918_192935_606145_21164576)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dbIUxST91flkfo4k+Boc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,

On Thu, 2008-09-18 at 19:26 +0200, Marcel Holtmann wrote:

> if the numbers you are planning to use are stable, then please use the
> above approach to just add the missing defines to it. Like adding a
> compat.h file with
>=20
> #ifndef NL80211_ATTR_SUPPORTED_IFTYPES
> #define NL80211_ATTR_SUPPORTED_IFTYPES boo
> #endif

Well, at that point I can also just copy nl80211.h from wireless-testing
whenever I think the numbers will remain stable, no? And that doesn't
work as-is anyway since nl80211.h uses an enum to define the numbers,
not #defines.

I guess it's the lesser of all the evils. I'm not too fond of copying in
the header file, it creates more work and doesn't make all that much
sense, but all the other proposals take even more work, and as long as
we don't change the numbers after putting things into wireless-testing
we should be fine.

johannes

--=-dbIUxST91flkfo4k+Boc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0o/TAAoJEKVg1VMiehFYvjMP/iudPA9qCpR2LjVcdcsM5y8X
cIWcLfHWMv7srwXd3yBjaYpiWJAqIu5Bn1sIeoXg/Ivxe/vb0eFlz3qKy0+oRSrV
+iNqDhyuGR9UDfSFrKQHcppBBufMxoNoxXMAthQAnzezBK0cXtK86jah/8TYdPP2
CIwkTMs0+Z8ZtZ5SdWJPFNOZDdUWmNzaxrfXIIQ9RSOZdwt1limc79QxlC8lpiN3
U52VZP2MBeDN61NeSmRYrExaxeQKf24X4h/c+SkCZ+3lfi4qsfylpj0ixpGxlAjN
NChwkLlEya0DxB/P2LGMw4lxFqn7oAgWIBCSrgKuTh5z8GlBVPJZVGG0XTexiqs7
qKriUjyp7kTRZQ0Okj1Gc+42kmNhSB/3lpalsxf3Rvi54D2GySbiG6kEqQeSisrE
iqecAeLJWi282KJokqrwX1uzLGMYG4AsOuogiPXgZQSHAAziuUhK+yrLSk6G1wy6
Riccms+A6cijwpvfyUH8LBYNRhFcSMEZ54A6DXSeOP8C0Zk71mS1Asl/1YbMqoEp
WUJBJYzIxno6xYBUAyy5Ztv9IXDHPzgi8TueFUdflvJKdPzNflhRLnny8P+yjsuF
t0oG/LmN3ssS2RCDrVm6QWC7JOT/Ra7fuEWacO7mVYI7WEw6teNiWhCGLLqcmFS6
PtM1V3bZRrh3sMI5G3YW
=nsMt
-----END PGP SIGNATURE-----

--=-dbIUxST91flkfo4k+Boc--

