Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51967 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbZLUM6f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 07:58:35 -0500
Subject: Re: [RFC PATCH] wl1271: add testmode support
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20091221123632.18850.74951.stgit@tikku>
References: <20091221120745.18850.67739.stgit@tikku>
	 <20091221123632.18850.74951.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xMFplCVY29P9HmFSsA6O"
Date: Mon, 21 Dec 2009 13:58:30 +0100
Message-ID: <1261400310.3733.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xMFplCVY29P9HmFSsA6O
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-12-21 at 14:36 +0200, Kalle Valo wrote:

> +	cmd =3D kzalloc(sizeof(*cmd), GFP_KERNEL);
> +	if (!cmd)
> +		return -ENOMEM;
> +
> +	/* copy the buffer to make it work with dma */
> +	memcpy(cmd, buf, buf_len);

kmemdup() (more than once in the patch)

> +#ifndef __WL1271_TESTMODE_H__
> +#define __WL1271_TESTMODE_H__
> +
> +#include <net/mac80211.h>
> +
> +int wl1271_tm_cmd(struct ieee80211_hw *hw, void *data, int len);
> +
> +#endif /* __WL1271_TESTMODE_H__ */

probably wouldn't bother with a file for one line ;)

johannes

--=-xMFplCVY29P9HmFSsA6O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLL3DzAAoJEODzc/N7+Qma1A8QALZIddnMOAFadREEWg2R95Fj
4kaps7Lw94Ug+MhkCBB8McLdVQ3xyU7LrRg26J1z61cVK3OBQsnFrUgXwqAfwSSs
t/e5h86i3JpvCKgR6auxz9Twx41gl8Bz8lEuR8au5jIKCBdfHqnnRriJccq857Xn
Cda5u83xKEXPj/oP46S1Cz2IO/PkuN6tJwwddrdygaNpoqweW+u41hm5LMFx6c9G
zkVya9ixW5Q4VzaG3OT+D6LSBn6370gpE+g7wj8cO5iwNL5vWGbbwUKiYEYbkXQL
D6ZltEBxLTItADAS6ccXAwnjI/w9RrisOWQrtrohKn+Uxczymq2bZC7sJNpl1hzf
Uern4oopnBr/cxKuxeLuF6HkCrDX2LqBhu0QoqOCiBCnHN/FiWgkUePdRicJ5woi
IHa0Uq5StlcDSHkDEcZqQHQnBpdRpCPAJaHGo6M+YqKn/Ci13Mgw4YdgE+UJZ1vh
5dAe00uZ0a2tHxNd85sSXWasvDhUPMsC7eZNrixlVcq6otfcz5oCXlxs5wh8VsQj
v0p0Na7ZLiDFmvYoWtW7C689E1btxldjcB4tLuKSTB7NUJqY+aM5OK7EMrwn9etJ
y98aYBrNoOhQ9iJJGJwlmXNFG5jNKVP474RzOzEJoT/vQbBp0jNx2AEeAz+fX8lY
bzYzC5iTAuZu27noXY/X
=W4HK
-----END PGP SIGNATURE-----

--=-xMFplCVY29P9HmFSsA6O--

