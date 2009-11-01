Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59521 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZKAS1W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 13:27:22 -0500
Subject: Re: [PATCH] ar9170usb: add mode-switching for AVM Fritz!WLAN USB N
 devices in cdrom mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Frank Schaefer <schaefer.frank@gmx.net>
Cc: linux-wireless@vger.kernel.org, linux-usb@vger.kernel.org,
	chunkeey@web.de
In-Reply-To: <4AEDCCA0.8050709@gmx.net>
References: <200910171606.02961.oliver@neukum.org>
	 <Pine.LNX.4.44L0.0910171130550.25594-100000@netrider.rowland.org>
	 <20091017220313.GH24502@one-eyed-alien.net> <4ADC3657.6080906@gmx.net>
	 <4AEDCCA0.8050709@gmx.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mlccmCJKTMJRkiTAcRCQ"
Date: Sun, 01 Nov 2009 19:27:25 +0100
Message-ID: <1257100045.3555.160.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mlccmCJKTMJRkiTAcRCQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-11-01 at 19:00 +0100, Frank Schaefer wrote:

> The attached patch adds the mode-switching-procedure to the WLAN-driver
> (ar9170usb) and disables the storage device in the usb-storage-driver.

This patch looks weird. Have you looked at zd1211rw, which also does
this? I think it just adds something to usb-storage for the device IDs?

johannes

--=-mlccmCJKTMJRkiTAcRCQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK7dMKAAoJEODzc/N7+Qma/2cP/jsobJIKkVkTVJUcvexmV6Kr
agWT73CCFkTUG6c+QOfXkxyLWVx5GAxMCpwjdw6oecq1lPEHUzwFvoHYMvd5gne8
UhVoQizn8M/IG7zla4qA3iDWvEHZAJ6+mBu7i8Bvpy48Jyqija0aXCaJ0u792Vsa
gKWZwfj9JUCZ+xUKV53ox6XPnwRAixnPyPWL2J9r9Wkzr2/BLwWXRzEYvHqoconb
S3AjtyXnf19Yy1oFlDSKhjZ0HwQEYhl11MOAlLE/D+dy3dwM6X8D4xOLUXl/gWMw
ECuaLUEmRBdkBsReBReUZyROP2rlp5w9S3qdrw5sMYYEJB394KOSDlmcEcynziwi
pVRRZs1IIQNLTFqLk9owya7IKV532jn64+LBPYtLw8mZHLPKYKb6EHm1OAuCbl2Q
CIIHYid603ccb9Z0jezcKIYnJpAS0nmF41mWHiUt3I13V/+9vk3eqW1ldJ3+sWMC
ksQO8dfFqvzoxZ1deklNLGz+E+mDyQmUyKdylrmJ+gbkMDNgjaXTGsmD2vzlF0QJ
hf0cu59uX/UpAZtJGeHESUf3c/JPwGiCuLv6fX97JWqa6QYb1aZFBAmnutoUznY6
6YgNE9bc6/AgRB99FaJeYszFUPgHFvhnomNkXk4ooIafp5qZTfs1tGAalokHd/Zk
PzWL6iOpuplzA00W/7LJ
=6TvN
-----END PGP SIGNATURE-----

--=-mlccmCJKTMJRkiTAcRCQ--

