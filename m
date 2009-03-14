Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZCNRZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 13:25:04 -0400
Subject: Re: [RFC PATCH v2 3/4] mac80211: disable power save when scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <20090314171445.11126.97668.stgit@tikku>
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171445.11126.97668.stgit@tikku>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OAY8pGZtGO9QP92kgcc1"
Date: Sat, 14 Mar 2009 18:25:02 +0100
Message-Id: <1237051502.5235.102.camel@johannes.local> (sfid-20090314_182508_766083_95B30FFE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OAY8pGZtGO9QP92kgcc1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 19:14 +0200, Kalle Valo wrote:

> +	if (!ps || (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
> +		/*
> +		 * with IEEE80211_HW_PS_NULLFUNC_STACK and power save
> +		 * enabled the firmware sent a null frame when power save
> +		 * was disabled, so we need to send a new null frame
> +		 */
> +		ieee80211_send_nullfunc(local, sdata, 1);
> +}

Now I'm confused a little. I thought with PS_NULLFUNC_STACK the firmware
_didn't_ send such frames.

johannes

--=-OAY8pGZtGO9QP92kgcc1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJu+hsAAoJEKVg1VMiehFYKB4P/3pI7dlR/XQqyGyda2OJv5k/
n1DyrZ//DrCZLfTpuZ0eLcJVe72IlF/KMhbIVHzugcfXw8LSWYzXP4DTJZoi+EOf
mO8M3wWeZXP9LpdL63/yQ/Pu+OO+WmaOEooNCWHf04R6cepVxxvOHVZRVqXdaekC
cXDw+hKfq1Pr9AhGFbqvXuAElwIIRQmJ/i6j0cNjQcaKLGU+SGTLkwu/8OUd66rI
02UBdTBb4Xb+m/M8PBuRI9zN2Sae6FdHJK+ABgwckuEOpTnvpb8h2bDC8f0ONbrL
hQSXSf33Q20Gs/cLwah9Ch0EnIwMWd7cN5YdICUob1w7HVAd6ZWhVlYkKxpI94aY
Z6i7zHZSLG1qX9dNXAczn7TM2zyXDGN/WjyoKcPX2y5MN7IlwH9mHnEYnUnuOtbg
Z8hjQybSWv1uX6MAK9wIo8D9rMDJoq9jlfqduBgfAkMspan6MUn4COOMSkguO679
OjnfPde81WU+eF/VChyMcxmuK2j3OkJiE2PxQqB1SydHUzEGh7ZFIodR4ADe9ag0
hSy4LaCJ2Ko/lYCLj1E7LwaMkpd1Wt6fK96cPZ1E+9FgTyBGMpIAfptMNhnLO8mv
Fc5aybuFqP4CtoCOf+Czd94WzTYs3cT4IXOZ/9sioHnSsz64gPUxeSplWj8GzEPI
1UU+31LgwqN7b2QW8135
=i25h
-----END PGP SIGNATURE-----

--=-OAY8pGZtGO9QP92kgcc1--

