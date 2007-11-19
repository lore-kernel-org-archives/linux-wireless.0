Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59514 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXKSQag (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2007 11:30:36 -0500
Subject: Re: [PATCH] Remove ieee80211softmac
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <4741B853.6080708@lwfinger.net> (sfid-20071119_162247_094333_2D1C58ED)
References: <20071119160626.ED6F19D4B5A@zog.reactivated.net>
	 <4741B853.6080708@lwfinger.net> (sfid-20071119_162247_094333_2D1C58ED)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iBL5leHF3uge2vm6Bbg8"
Date: Mon, 19 Nov 2007 17:31:55 +0100
Message-Id: <1195489915.8642.36.camel@johannes.berg> (sfid-20071119_163038_521220_F339F37F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iBL5leHF3uge2vm6Bbg8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > With the port of zd1211rw and the removal of bcm43xx, there are no
> > remaining softmac users. Remove it.
> >=20
> > Signed-off-by: Daniel Drake <dsd@gentoo.org>
> ACK. Larry Finger <Larry.Finger@lwfinger.net>
>=20
> Hoooooooooooooray!!!!!!!!

Seconded! :)
bcm43xx removal should be on the list now too.

johannes

--=-iBL5leHF3uge2vm6Bbg8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0G6eqVg1VMiehFYAQJkqw//SKf6NzqJ86/L8MtGJ+b5oMbtL6eOwKdL
xLEHnjEdvAjb3uZB7b6K1uy+EpGAqhlY6X7L8hY5h7Eb0iLSdxj5I5ouGTdaN48f
M7e5/VHlO0XPXAP87gTH+9GGdfZ3CLYU62KtIv08jf0IbulPWmPGSMh1PyZidMqg
1KHkX/XJEA2/ziddrSaehinlBxjDB9hR3AKFoch2qz7WZxOnS5o2ydUW4lSWGkbE
YEMlzvlvTusqWp0jFUS5qKs6jvnxgO48tNalkSmbPTg2qKq3UNScwiOM0mG051Es
Fx7tH7Q9382uEsEBRtD+ma+RDjpAZsoG7Ab2QQ6i4aWjjvpwRNY+kAHgWrTHRXFp
nISSyTof3/nQzqEnEhmeY9d7hRZ2hVL+iEbC9E92HYg/+o5w60uZHATT7oTAA7tR
k/VnJ7xLXGU/Y3c/e9T/nF+NsXVL6uut4bX1Jx0Oah3E2nWqbVVRvaPL3xbAC74/
YZz5GTcJLOA/OYyCFLgr+HT//mBvI9Ca5DJtbOwD+xK6J27tBPHMa+sCFqiU62+U
hVDHI6bOY4G0GPkO8KUyaVSpi2QY6k1I1Tx7+EluJ37DfmS6iFAZTTWCCJdMBaO0
iQ19yQKVFACCy3M1z/JVl6WuR/4qmxBPTBn+BkQ+BtYecAG0Z12VdtH++5OmazIM
x4JX5HQJtIQ=
=YYYP
-----END PGP SIGNATURE-----

--=-iBL5leHF3uge2vm6Bbg8--

