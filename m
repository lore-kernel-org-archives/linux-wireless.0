Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbZHBHq5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 03:46:57 -0400
Subject: Re: Regression since 2.6.31-rc3-wl
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <4A74F1E3.8050502@lwfinger.net>
References: <4A74F1E3.8050502@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Rk63opkXvo27wXetVeeH"
Date: Sun, 02 Aug 2009 09:46:54 +0200
Message-Id: <1249199214.2007.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rk63opkXvo27wXetVeeH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Larry,

On Sat, 2009-08-01 at 20:54 -0500, Larry Finger wrote:
> When I tested 2.6.31-rc4-wl on my old i386 laptop that uses ifup to
> control the network, wireless did not work. The problem was bisected
> to the following:

Thanks for taking the time to bisect the problem, can you be more
specific as to how the problem manifests itself? Are you using ifup to
configure an ad-hoc network?

Thanks,
johannes


--=-Rk63opkXvo27wXetVeeH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKdURqAAoJEODzc/N7+Qma2ioP/RQnt+PPHw8r4i2i3IFmAs9j
/ZDGpTunVjecAySaVUvy68yakN/we24hmzdoBWrNKldkC+h21OD/qhC7uP2f5NOR
mvgtAmuq06GNowgNIediBEXfVBw4DyLIgYVJrgYLuLs7gt92Ks35UOpNgGSiawLN
L4W1chej/vO1dlizU/dphyBXA8woEXIJdgquqjOdZbpxna4T7z90ZCHS7U3PH6JK
q+FQzd1NoXS7hg7yQdBfj0ek/HSPCT1P7qn1ULAEMBfBY0mAazBmtUEK1+MIZJZS
vSGMAB/njHG+koMS2eoQBYeCVZsZcY4h5eSIPHxYT4Xp5ZBkjgVbYMfPSaiF4BdT
wNhxyHxzzyBbWeF/134Q+kQodchf3WqISgi8Qk14fjvavHnmFkV1sMq5FGyV5AZC
W8UddfHO/JjBO+n5eIC+hZTW13PNgfChCgUuNDCKu1KY3XCVqfczDmGmBTsP5UjM
OuAOnJGb3+SBzRC3sdSRV71tO1ASpJpkxB+Iga5WvdC+DMuc0yncqw5mnRtCTd1p
aErrGpu/sKq4XbCI7iFJh4mNyTzy2l05GhlJusVydku3KDX5C3Yw1mc3Rdte+aM6
Oyt3Lmsptslewf3eQXrrsev9i7PVVvMO4fqjpXpzELX/WE7oGSnvI7yb5rH13h6v
ietlxaXP0l6jR4jGCj6H
=M/wI
-----END PGP SIGNATURE-----

--=-Rk63opkXvo27wXetVeeH--

