Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZA1KzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 05:55:12 -0500
Subject: Re: [PATCH] cfg80211: add get reg command
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1233111125-7955-1-git-send-email-lrodriguez@atheros.com>
References: <1233111125-7955-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OJTKWGUNMHP+vJpuwmp1"
Date: Wed, 28 Jan 2009 11:17:21 +0100
Message-Id: <1233137841.3936.2.camel@johannes.local> (sfid-20090128_115516_038832_CF6A33B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OJTKWGUNMHP+vJpuwmp1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 18:52 -0800, Luis R. Rodriguez wrote:

> +	mutex_lock(&cfg80211_drv_mutex);
> +	regd =3D reg_get_current_rd();
> +	mutex_unlock(&cfg80211_drv_mutex);
> +
> +	if (!regd)
> +		goto out;

Any reason you need to copy and can't just build the whole thing under
lock?

johannes

--=-OJTKWGUNMHP+vJpuwmp1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgDCtAAoJEKVg1VMiehFYA0MP+wQsU32cI+B+nqD/CLGA5SbL
GodrKtjw40JB83Dn1ioFsCz9/8gBdplGn6K61rNe0rqj8JHZTyfZGlDJX9l/MSZ+
BTQonuqv326hLhmYZBmN/TlQiRk8C5JjqBy+ekc8lOnCgj6sQOumxNzrCvpGrvd0
hmN19obvz2LqdKrOLuM/B7oeXiCs8fsDKS8+pfIdZD0UrqwxEdHQoruD8EDG4lr5
sbVQ5JIYswjVJksIc0zgD3IIrAjK2Swn37yawJPTv1bqZklLJlhFXp+b9VeDw3nC
oo4nzorEtwhKmj3+QwmIzH75yBp0EeTR/ckJ/T+N0ZzKzrs0b/wTAMIyK8dSWMO7
SXxzx6Qo0h5orceGCNOPRkUW1qY3OsHs1AVhJdMrWHVLyiqJALEIeLGC00EBIOIE
7vfw1QWX4fcA4mMt+823GGRIynYb/Xb4ISoK3IRbOxWg4TTjCNnwuziSNZdI4r34
mbR8b0hFslyATaAXuli8J58beF86WV+HzzSH+xLJuLoReaZDqeeDZcn5ic4ZS8G5
M4oeNJ2aGIzbeZDiaQ8qiO7JNmY9KccutVvV7SxapgqWw0+vWV3d9hRYYSSMoi/I
Qc5b5AKdtlwgACtg8G8yJE10XPxESVILf8z3VrXZVmubznWqaGNq8A2Bah3qnvbr
eL+O3r6AkUn3MlCQxg+r
=TrAk
-----END PGP SIGNATURE-----

--=-OJTKWGUNMHP+vJpuwmp1--

