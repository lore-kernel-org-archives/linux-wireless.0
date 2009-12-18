Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbZLRSas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2009 13:30:48 -0500
Subject: Re: [PATCH v2] ps3_gelic_wireless: Fix build failure due to
 missing WEXT_PRIV
From: Johannes Berg <johannes@sipsolutions.net>
To: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Hamish Guthrie <Hamish.Guthrie@sonycom.com>
In-Reply-To: <4B2BC8E6.9090007@am.sony.com>
References: <1261115574.2173.18.camel@pasglop>
	 <20091218085547.fb8bdaf5.randy.dunlap@oracle.com>
	 <4B2BC8E6.9090007@am.sony.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fPnoSaeSXGA91qGIZ54b"
Date: Fri, 18 Dec 2009 19:30:36 +0100
Message-ID: <1261161036.14206.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fPnoSaeSXGA91qGIZ54b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-18 at 10:24 -0800, Geoff Levand wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>=20
> The option to support the old style PSK interface in the PS3
> GELIC wireless drivers requires CONFIG_WEXT_PRIV to be set
>=20
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Geoff Levand <geoffrey.levand@am.sony.com>
> ---
> v2: Added 'depends on WLAN'.

Won't you want 'depends on WLAN' for GELIC_WIRELESS instead of here?

johannes

--=-fPnoSaeSXGA91qGIZ54b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLK8pIAAoJEODzc/N7+Qma+toP/iarWy2EipzMYswHGNrgA3h1
RdMr4Gy93ESxqWEpKPxZaFwbAsdmr7z9zIhQxhkz//Fzz/scu6DvgGaV8sqsZQqQ
uVlZivy7TOdVuzXs6ocjZKV144Waq3VNdQwmJ9AXemfOFTTIZbA3RYXS+oSe1SEa
jINun2K+XnNp8oPcHJayoo5BMu8ou8hBr+hXonVB8srj7dTAfGHkwyjkwaMgGvI0
u5Ksw1TNzMlo75xENOWzmi9bsc9jIeCSpHg9BWS0zdTjDObkJYJLEerWEZf5w2kd
C+T4NM04BU1eainx30sIcqGqMq2R3KDQwx3DI+FrGhDu6VJI3/y6Eu3d3YfUlqGk
bn5ZLbwpNYccI4LA7k/cFcX8gz/IV1kYXAc+g3hGKZQCMcQbWgSfQXDJb3/jGTsT
R5IWwIg0oEoCY5ZIFrqcBTne/n7snWnxrdjXi+DQN0YGufzD8+mkJQDJV8jPw+Dy
8h1W9u8IzFAt86rHdC8zp7vSbO9D4gv3havsxgk7Z+j9l0SiIT0Yxh18dCvG85yy
vNcmJw4sMSEYl8VLEfgLj0a8XA7MU/xXYllU5Eo3Ts2Ac7PhhyczedvV0GA52asP
uUdgFMNwe9CB3BNmk4NSs9m+krTkndgw6Lffmw0SdE6wMNJiECg72bneU1wlyIbr
Svww/5qZVwiAB7gOviVC
=jbIL
-----END PGP SIGNATURE-----

--=-fPnoSaeSXGA91qGIZ54b--

