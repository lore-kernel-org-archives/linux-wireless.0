Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZH1LLr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 07:11:47 -0400
Subject: Re: [RFC PATCH 10/10] rndis_wlan: use cfg80211_wext_handler
From: Johannes Berg <johannes@sipsolutions.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090828102835.15684.52916.stgit@fate.lan>
References: <20090828102742.15684.10566.stgit@fate.lan>
	 <20090828102835.15684.52916.stgit@fate.lan>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-RSUGSCbLux627ck/DX0R"
Date: Fri, 28 Aug 2009 13:11:13 +0200
Message-Id: <1251457873.3456.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RSUGSCbLux627ck/DX0R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-08-28 at 13:28 +0300, Jussi Kivilinna wrote:
> Now that cfg80211 functions are added and wext converted to use wext-comp=
at
> functions, remove wext structures and disabled code.

Very nice patchset!

With this you can also remove the "select WIRELESS_EXT" from Kconfig.

johannes

--=-RSUGSCbLux627ck/DX0R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKl7tOAAoJEODzc/N7+QmaMZEP/j+TDudXwt5/1DKAEAM/M/KK
ZraxXTSesSsPnBv5ec3SJOU5k92KKzy1rJAjMqJyGwj1IOduSfUNih9f9f1ml8+C
Hg8ObRbHiHKGgU6+URLt8OboMun6kRXFQublDNg9osKmdt5yMiYGVrVWFO7w+SW8
jlO2HkwiFWAHlK2aZYFiWrjjpsaI6ksq1+kD9cTwPhcFBqlnXJKzivyIiDVBlh6b
VQxKE+euoDbpTKBoAGmyq44VKUpMDq9Dgit0Q1e28YVYcszxSZ8Vr72DMSNGnbtl
VJa3L6Fc37LyErmDyDIkLQcYntcqMaoHrDAEqZseOX6tQnDL6+6iWzgzWEXKdxQI
2Q4H45QQRUtwrvzr1CuOh7zfj6zbgWn/f86m3ByTiMzXPRGoccwN3qsNQopnIVfl
8lJ8cBxWsqlCx7bMDeqzix2okl7M4UlHLaxQiqUu4uUAO17cf1HQywzwnuQAO8zu
ZijFDL1U0G7ryUBlL3+uGiS3h1JdRxJsfgy78uZUmaLzqcJqoMvPagHwNi9gycHr
ajN4JKQ/pnmsyR4ZCRN3YcHYc+jlQVqVAsKA7kp43VSKgamR+u2kVQa/0z4SIUCl
eB3C6jed57jGV8ghG3IqSPjws0+0m7J+c+mEMkGS5k79OwpUkGcpkjZbyZY1br+9
nx3wEyddF3DNE5SAkTbO
=x5iZ
-----END PGP SIGNATURE-----

--=-RSUGSCbLux627ck/DX0R--

