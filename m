Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55957 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbYIXIp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 04:45:29 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1222235866-19805-1-git-send-email-yi.zhu@intel.com> (sfid-20080924_080231_170139_3D180880)
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 (sfid-20080924_080231_170139_3D180880)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o+oG4lPvFe5zfMGDNxeK"
Date: Wed, 24 Sep 2008 10:44:42 +0200
Message-Id: <1222245882.18015.62.camel@johannes.berg> (sfid-20080924_104533_060949_8B92736A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o+oG4lPvFe5zfMGDNxeK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-24 at 13:57 +0800, Zhu Yi wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
>=20
> The patch adds channels sysfs entry for iwl3945. Make it consistent
> with iwlagn.

I advocate just make it consistent by removing it entirely.

> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -7666,8 +7666,60 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR,=
 show_power_level,
>  static ssize_t show_channels(struct device *d,
>  			     struct device_attribute *attr, char *buf)
>  {
> -	/* all this shit doesn't belong into sysfs anyway */

johannes

--=-o+oG4lPvFe5zfMGDNxeK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI2f33AAoJEKVg1VMiehFYDZ8P+QHVk0uBrpmSCwowsjvNV0fR
GmCVIpb3qqqLoAhFy4y9RYE3QkzWk4Se1zreD/B1Np4IPhiI8S0QwKtROwk3lBUi
YA69YJKOwei9kzqD+40phEwKjTdt/40Z0JxWvwUFepgZa0MlVD9fsMq6mh/pkzuC
XV72mt23MbH9RLqcWOQ6afnglRChm3PYcSzkkMRBfe+mHxYBgLqrbYFwlzniTmbj
da8qjklvkH8kKWBYvq7iFgkwOAobHU8bZTODJy1Yihzz9e6XGXuMjLKTy6gfuznw
DWuEr06wE6Ki9as1bN1nP9FT39FVRHIWvTYTb/KTjEij38/WxI7eXsB4C/M0DKkL
5EdsKCj+SBmdZsi9qt/Q3TqbkOw/O7aotQHTjSwROkB4xXGwjc/O/n0ZmZiqBpuq
F1i6M7bbKe/4VH/G6SXB7GuTvzpGfnOh7Nrvj165in8mRxLGt3P9Tuir5FUXM6Zv
9Mq9nZ6r7YV4e1muqrCeIBVprVUdWeSpxPTdtZHZbPyPmTHP7kD+OKPIhFIeCOy4
F7l4snychJv7JKQjzDI8XT2vLJJQa0Vm4z3CFu2CCWk5GuaDvBnZ+JpzIVPRGq4A
hYldL18XnuT1tV1ztLJNv20mVPSAx+XBwExdvjmbzfBH9/e0zAd45GJeXDwBq4lo
pl48dPhKv7yCLMUdH/bS
=9Ovk
-----END PGP SIGNATURE-----

--=-o+oG4lPvFe5zfMGDNxeK--

