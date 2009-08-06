Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36290 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754121AbZHFSsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 14:48:23 -0400
Subject: Re: [PATCH] rndis_wlan: wait association to complete
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Jouni Malinen <Jouni.Malinen@Atheros.com>
In-Reply-To: <20090806181746.31308.15687.stgit@fate.lan>
References: <20090806181746.31308.15687.stgit@fate.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-a98L1s+ImLZMxch+qJyq"
Date: Thu, 06 Aug 2009 20:46:25 +0200
Message-Id: <1249584385.28278.124.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-a98L1s+ImLZMxch+qJyq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-08-06 at 21:17 +0300, Jussi Kivilinna wrote:
> Fix WPA authentication problems by waiting to association to complete.
> Otherwise userspace (wpa_supplicant) receives authentication packets befo=
re
> association events from driver.

> +	/* If we return now, userspace would get association events too late
> +	 * (after receiving first packets from access point). This causes
> +	 * WPA authentication to fail.

This is a bit weird, shouldn't you just send the event later then?

johannes

--=-a98L1s+ImLZMxch+qJyq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKeyT+AAoJEODzc/N7+QmaMY8P/3tAPr8t0qrGgwzwk/krM3yv
chLK3vXBVGvPHcBF6Rn4WHOdS00a9O7VuesA0FoBrmCFSZnwuK12zVOlHrzk7Nhq
MBMRg913kHYv5hYsnvxeB4Gjg2ddAgNXcK0qtO0iHn4VN4Fx8ujmIYb3gS4Fu1+k
7eXLw5MbDI1kht8NC4zdVnd5+F9AzhgJPRqBcGgHDFn+0Y5TGz8xE5XADIHNPI64
DGcnGVzc6hcDFBr7OHeZ8zYZG15BJsIoA8nLNuyKX0NkEA4ELGo6WMBu2m+NAzj7
q7bXGhKT5tkC+bjiS5QyGyg1xuJI7B/6niPnQv4dUAUfkiklWjipNovVTrL1gLYP
soNYnIQ20LUYdxQBM8TkHzDQgK5bXHVvm4FZzvp4VfYA8Qsxpk/p6ED00bfJ0OCw
oqhTE6bMhIe2fR7dz72OlEttr/IVsNnuB9swITrXY38k9gkuZYkxT59AlV/UAQkQ
FasNKY62Yi52/L+3pWwBAyYhIBtLVZgmQDy3YiGPgovGsaCzGJKkAuwThSKtkXXG
/V5mCQYTaP0iv42WS2miLBPxAhK4P9IU38j/2ywoNvmOPLzVAJcoIc0L8HcT7c+4
S/Y9WdbRFcVzyEu3etl6IVaOgVl5wb0FS7/EEhbsmD0mLwxxvbRTKsv/6Z9fkysP
pXP5V9GD9yClsWXvOkBT
=YukH
-----END PGP SIGNATURE-----

--=-a98L1s+ImLZMxch+qJyq--

