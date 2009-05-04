Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48505 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbZEDSGq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 14:06:46 -0400
Subject: Re: [PATCH] add support for showing power constraint IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241460224.8683.87.camel@johannes.local>
References: <1241453167-3720-1-git-send-email-marcel@holtmann.org>
	 <1241453408.8683.53.camel@johannes.local>
	 <1241454909.2903.17.camel@localhost.localdomain>
	 <1241455125.8683.60.camel@johannes.local>
	 <1241455848.2903.18.camel@localhost.localdomain>
	 <1241456088.8683.62.camel@johannes.local>
	 <1241456863.2903.29.camel@localhost.localdomain>
	 <1241458558.8683.84.camel@johannes.local>
	 <1241459295.2903.40.camel@localhost.localdomain>
	 <1241460224.8683.87.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DeZJc9INyR2GqNKDIlDo"
Date: Mon, 04 May 2009 20:06:16 +0200
Message-Id: <1241460376.8683.88.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DeZJc9INyR2GqNKDIlDo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-04 at 20:03 +0200, Johannes Berg wrote:
> On Mon, 2009-05-04 at 10:48 -0700, Marcel Holtmann wrote:
>=20
> > > Both are HT.
> >=20
> > do we have the specs somewhere then I might can give it a try. Also WMM
> > needs some improvements.
>=20
> The IEs are defined in structs in include/linux/ieee80211.h.

Oh and iw already has some code (in info.c or phy.c?) since the data we
transfer for HT capabilities is the HT caps IE.

johannes

--=-DeZJc9INyR2GqNKDIlDo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/y6VAAoJEKVg1VMiehFYUMsP/Rkft3Zm7xPib6CXeyz7tBi5
jBfCEvewoYGMqeRWn+QfLT0rhduraI+vY1bGjZrYjCAb5s/geDbMP3+OFMMN7/Oa
JK+PwuRhwY6w3Z9zGGUcrm0zTJvspAdfbMVMmszkO0rENEMX6F6uEb6Bzr8tBsKI
IaBeFUSEL2R2lIX7FWRYUhNNEbMXfhBv4ChI2gb15ckIyf6IHsbwmps6y1vpV/qk
qssUbjP+OpD8lWwL+WDsqQUf0b2RdbLrAC9eYHRh2/pZviv/tZp8PJJXF5xVnywI
umVwNZgzNxxKF35N5aH4oknDaR3mba3AeKkAtu3/LMVXksbJZQjXQWzYfdtCOfzj
48dvTzBo0TvPNBhPWHiM97QRywmeHivktYYDyj7qazEusDdfoVgC97awZRcbGLWy
VHloLsW3TFOGjiJPj588OYop1Iktk8JxGEILq5YcWfKMWEcdH0Y1//CEbXusmkRh
CCvMrjKCZ/gZFmzM9xkW9STzKs8xv4Bvs7Amp/VOi1qews0nRhywWCZl9oF1BhzH
xE3R9o9SG+CaFmqLio39IUbLtYncYATkXCzhBKMyQlgl2kmxe32QNDgxsI5TP6jp
kClPoh98Mi6g9Cf/QCtaLyHlczvsOVucXqesklWPBUg8WQnwiaVEoV3YmYy9K6Zx
83uWXkwfvLGZJdyB05ev
=Un1p
-----END PGP SIGNATURE-----

--=-DeZJc9INyR2GqNKDIlDo--

