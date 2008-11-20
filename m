Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519AbYKTSZd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 13:25:33 -0500
Subject: Re: [PATCH] ath9k: Dont update rate control for every AMPDU
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com
In-Reply-To: <1227160312-5078-1-git-send-email-vasanth@atheros.com> (sfid-20081120_192323_892886_92014C1D)
References: <1227160312-5078-1-git-send-email-vasanth@atheros.com>
	 (sfid-20081120_192323_892886_92014C1D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mrsbb+vMO7vD8TYWv2+R"
Date: Thu, 20 Nov 2008 19:25:28 +0100
Message-Id: <1227205528.3766.29.camel@johannes.berg> (sfid-20081120_192538_018883_BF45B32D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Mrsbb+vMO7vD8TYWv2+R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-20 at 11:21 +0530, Vasanthakumar Thiagarajan wrote:

> +	u8 update_rc;

> +	tx_info_priv->update_rc =3D 0;

> +			tx_info_priv->update_rc =3D 1;

You could use a bool and use false/true, that'd generate exactly the
same code but might be easier to read. Not that it matters much I guess.

johannes

--=-Mrsbb+vMO7vD8TYWv2+R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJJauUAAoJEKVg1VMiehFYKi4QALL/f9CW3HJgASvcQHPFai20
Jyk3JsSGV6BDWepxhBKP7DemWTPjZSvw739Y7qwMr1shJF9nIaOVwdeRazn5llM8
6VMA3PV7vuDZ4KoxAaDQOFX6MFULPdv0tQvqmX0u2PS5fGNZ4kl63Rc1Xu6+E1M3
8LNbSB0HECLHn3pTciZKfEzdH4KWV47db5V4qmwPX2xNZdo7p7e7XRLgssVHjJud
7PUOVGBM8wiR6KTiGw9XTgnlbh5GHY9en0MELMSpni5blkOr8BICnlM5Af2hY26a
YUqINrDHoVJTiPvDaCB/q1mczgaRFAinZNFam2RVR8M/yPtAOe5htsW72gIkvi/j
8Uk7Xkf4vAKI2s/3ze67/tO/WKVHjr4kaoxNw0i97p1GneqJkiy94ZnNLXsZ8bl6
H5LHwq6KRGd8Gs6oaZglObM2i53ZMIR2DGFotlkgrSdyNSLETJvz3ZoLDpTIwoCN
GpSNX6Ymz2ydU5ICFBfsHT5eeRQWFl3DGfPfe5Jhewla8noX4jd8RjHux8nAFeQ3
oTjyyI+YDYfy1Abi2YkTdpBj7HXTYmutYvlLFxuU4Uir8uwSgBi9nOLg1elbJn4Z
M6lk89dV8W2l5NzeUauTDzwGZYG3MGJPdOtFgb6Ns8Se+6ba8D8CI2AqwMsbK06H
vWGJAq7OFtLw+ABFxcwj
=0Dxr
-----END PGP SIGNATURE-----

--=-Mrsbb+vMO7vD8TYWv2+R--

