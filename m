Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45720 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770AbYJWGWs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2008 02:22:48 -0400
Subject: Re: [PATCH] mac80211: make use of regulatory tx power settings on
	change of tx power
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1224706433-12582-1-git-send-email-lrodriguez@atheros.com>
References: <1224706433-12582-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rt1YiDLXQRiVtiOzUKcv"
Date: Thu, 23 Oct 2008 08:22:41 +0200
Message-Id: <1224742961.5865.5.camel@johannes.berg> (sfid-20081023_082252_340129_98D45844)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rt1YiDLXQRiVtiOzUKcv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 13:13 -0700, Luis R. Rodriguez wrote:

> +	if (data->txpower.fixed)
> +		new_power_level =3D min(data->txpower.value, chan->max_power);

Incidentally, are the units really the same? Just wondering, haven't
checked, if yes this looks good to me.

johannes

--=-rt1YiDLXQRiVtiOzUKcv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJABguAAoJEKVg1VMiehFYCJ4QAKB16UneUZ4lzTKMPXbzY1ae
ahqzq12Myo4qaPjnExsaP+HBU+vDCpku6uWotumDGAnvGFzuvviEcIUzGDivSe9z
HZG2OYUN1nvMkOBQW+V1PMb1NyCuGhfQjEMCIxJan0T3Az/+WDbAxQAS8IYDFnQR
nmeMOPFnPIUftEPABczfQMZscDpqSLTYq1zw3E2uNE9Gek0xMSjM32aoB+xdavVg
/pgSmDE7MOvzTZdqvQWWqALHx9cag0FlrCK8jcSDQCn5RRae36D9pVLgx9sywACz
B7RrH1pvic8l0T5MoI8GJS2hsvDUmiATSnmIO/XgAsrFfnHEipZGe697ADc4VMRw
mb7r/iHIk0HDC+seDAUqIZa26vmDNuRLKEEL2GjbIWrwDwT6PvQDX+HbAKnBAvTb
J+wU/rdRObyHQX1BMdBNBIzkjKz2oS8SDvmjzWV00FbwWIb+MkUNXVtmwUC6YiM2
1/Tm41RqrzNpSecEoZuLeqmUYnAUYQW/CvGgh+GKUcNzu5pI1pc5V2/pYtua1QV8
5rjWhTnyA4P8WYfLollvtb/4fNA5JJc0CWxcPOhT9Tgdd3uiPiVUCDr/iY89Bl2c
FiHYaDauOpJV0aibAW6b8DC7mgseoyA2qSytCiNdrlbQ8mdI5OU6Lw4UPwEK+vsx
gRP5s4/lf9ixg+FtCgr2
=1FQv
-----END PGP SIGNATURE-----

--=-rt1YiDLXQRiVtiOzUKcv--

