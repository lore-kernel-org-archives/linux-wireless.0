Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0BQSgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 13:36:21 -0500
Subject: Re: [PATCH] v2: rtl8187: micro cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: okias <d.okias@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, herton@mandriva.com.br,
	htl10@users.sourceforge.net
In-Reply-To: <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
References: <c2673ca61002171015j375922c0y4c7f61c3d3322bab@mail.gmail.com>
	 <4B7C35C9.30607@lwfinger.net>
	 <c2673ca61002171034q18edf1c2o817ac4e1ff367177@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Lf1iguPAEz+ZktqbnlQe"
Date: Wed, 17 Feb 2010 19:36:04 +0100
Message-ID: <1266431764.15836.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Lf1iguPAEz+ZktqbnlQe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-17 at 19:34 +0100, okias wrote:
> I did test on small C program, and "int a" is equal to int a =3D 0; so
> it should be fine, but maybe I'm wrong.

It's not equal. It will be uninitialised stack garbage if you don't
initialise it.

johannes

--=-Lf1iguPAEz+ZktqbnlQe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLfDcRAAoJEODzc/N7+QmaaJkP/1NZN12xb23CpxWWPylaU7cr
XvSMB2DnMIm4v3YxhIzu7SYNWEfa8u/znnIf5mgl/0Di35vrzG3ah2ImUVduNx6I
l8Cw5Amz2GE4y6ILgn4LrZ4Kqi0Da5UEpRb8ZX5gZ/adksWfTlbW1vRKsgu6ebFa
I4LsD3vP3U4OzWIoIAc0MPoZSCrwidrSxaw1wCxXGxXjvTKM9iuPIi9iFCkg7PvY
gEfErWsNdXEBIUw2t0wCzqXx6mXc+kz6hcGV2T4oHd7H9/4ABcpBYCjwTLaAhGQY
wTCYgn3m6PYNLkHYU8BdweITu16Y0aWQpKIaBwsYqUDBp3jl5Vl8rTMGQutK3i4K
ETpVVhTG7jmy4YFRj8BnL2tIgUIwjdIeYsPvGHlYaYnQJCApj+Z6kUnqrTONNQUr
556y4Vn0mWnpIfJhQCpHWpCpz0y+e6/yPOwEDIdmXNhGaSDSGyme6y0HYt3WGzK2
X9GZkQNE+wlmrquvBIMo9lWUbtYRhlhooFVkssASE4OYhTNsmQWF8IXGWxQWsvKR
+XiW0cCR/hFcA7S9cDlXumSPQMg02f+IkBjfqTWyuupFHsStuo9qsKERRnJ+e2z9
HcM5bCZmkNFK2u2DE5lUZVhTd0PVHUqaFua2OtO9yfB0u8rIyMM8CbDaDJE0bQL5
z5W8dB3vzIEMIHyo/jdW
=HtqC
-----END PGP SIGNATURE-----

--=-Lf1iguPAEz+ZktqbnlQe--

