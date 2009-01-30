Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbZA3LRm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 06:17:42 -0500
Subject: Re: [PATCH] mac80211: convert to net_device_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <20090127052926.44d3fd5f@s6510>
References: <20090127052926.44d3fd5f@s6510>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m6hntm9XxKhiUWkWXxNB"
Date: Fri, 30 Jan 2009 12:17:37 +0100
Message-Id: <1233314257.30970.6.camel@johannes.local> (sfid-20090130_121747_128792_58F3B8C4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-m6hntm9XxKhiUWkWXxNB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 05:29 +1100, Stephen Hemminger wrote:
> Convert to new net_device_ops in 2.6.28 and later.
>=20
> Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

John, please revert this commit for now, it's breaking monitor mode
injection (and thus AP mode) because the xmit handler assignment in
ieee80211_setup_sdata is not effective.

johannes

--=-m6hntm9XxKhiUWkWXxNB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJguHOAAoJEKVg1VMiehFYaewP/iuI8j+D9Ffyp6k70E63zymx
7xfT0iswrCtbsiWJSLO1pjgUQpkg6ME8GRJBIHhTuOrtpy5i3vkzd1ENPCEczzcd
/Hx8GvqyuepeKuVhl9/OLlup0jmP8ysE8yApPqYiTb+DzXn+M3Us+4beWdUZaphS
DGuvUyASjJ/YP0BASBnmqYU3uDV3z/5IbCG6kwlXzKu5qV2ZyUvhgsl5UGe4w0cu
hA4HQlEt2hC77eS00z3oXLupPRDeMwpbhX/Rtw7wR+l/XWGJJWDWVp8YwZHaoJ+F
Jhf7pviCTftN6H7H1Zli4DwLP6v8iWlepOkiSbLXObLlbwqPStn4x13BZJlxct3P
9F53a8jux8krQj4bkrjrgo8h16Fmf9YoFKqFdNu7Atq6G+opY2qmeNbSZIBAU7T2
V+u1va8yIVTeU/zqcJuxcUGavZaOKKY5jDx6jvODlMZp5No2/ynntKBxX3c4Xn8+
mkuYa2FFuRW0D8TGuVJ3oXG6M4k719/l3Q7uzInVJ4RGyDIGUGeIHMPKx4GTlZPd
FRkwUqYbtvE0w8Dp3oPXtEI/rgYZezwwu03wjmb8Gv6ZD6Zy3Ussv6P0Q7gdSGbk
zVZ/nAXQi3KaJzP/KKvJuLDN2U5SPZXSrPKi10hb0TAyA7egc/2e1oAO0OsrUaGE
Oc7UGMFYkwKRMnnmKq2L
=6ykP
-----END PGP SIGNATURE-----

--=-m6hntm9XxKhiUWkWXxNB--

