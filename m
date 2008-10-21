Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYJUQlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 12:41:00 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1224607196.9386.91.camel@californication>
References: <20081015112517.GF6509@tesla>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 <1224485431.18024.12.camel@johannes.berg>
	 <43e72e890810192359g2bc75316v49377ddc9eded934@mail.gmail.com>
	 <1224487340.24677.192.camel@debian.sh.intel.com>
	 <1224520999.9386.72.camel@californication>
	 <1224552899.24677.245.camel@debian.sh.intel.com>
	 <43e72e890810201842o44db616ekd8d5bc66cd1006f@mail.gmail.com>
	 <1224554323.24677.248.camel@debian.sh.intel.com>
	 <43e72e890810201937l3be24156t2172590138fda132@mail.gmail.com>
	 (sfid-20081021_043804_334625_50CEDAE0)  <1224572722.27899.87.camel@johannes.berg>
	 <1224607196.9386.91.camel@californication>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9GWbxnyeh3eIQHUoH2+l"
Date: Tue, 21 Oct 2008 18:40:44 +0200
Message-Id: <1224607244.5521.22.camel@johannes.berg> (sfid-20081021_184104_159318_DCDE1BAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9GWbxnyeh3eIQHUoH2+l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 18:39 +0200, Marcel Holtmann wrote:

> I was more thinking about
>=20
> 	regulatory_band_hint(band, structure)
>=20
> and then you have to call it twice if you have 2.4 GHz and 5 GHz support
> with your hardware. But your solution also works.

It's more efficient with flags. I've posted patches.

johannes

--=-9GWbxnyeh3eIQHUoH2+l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/gYIAAoJEKVg1VMiehFY2tQQAIYELVd8NEj9SocR7bAAXY3N
ZHkQKng6WuiXCiTrwr54IhQP6G9/yLkTloQnMCl5lWPreY2Pde0B0tfCQvoF8dhA
eOW3KQWHITABmR/H7vBC9n4blEYqz/YNVrAWx+lBSsZwk7bmWtFfDwE6ERjpGwXD
cFo7mLhlg/Q7n8ERKuz1Nh0xBAH36FSDqgXp0AmDIgZJhfye3l5/rwOppnVaNYML
/YUX+cIBQhG7HzeZIX1MK+Wa7Y/YdJsV8DrOUYE1Lqwogsyhlj4+wDfWqiFNPYF0
PlxGmIdsjCt57vVp+5/XvGvjIeVRbD7GCYQ7RHpwDNh+n9wpU9WTe9EHtlHx6e5J
RUpBxoyabXxQ90xOrBYo4m+gUXpo/gQYkSlTWiZflr8YZQL2W0TFPQ9OoIIOsxR8
PjBYSzaCe8VkwLxvQkuM2A9meHfJ22DxYWApShRNK7mkw9MfpOtbtu7tpa7rSY1Y
hXyasnRyGEZARWfzQ8fLf+lqu7Htr/YGdAqNN8g1nqmHGdACZISdFlnyEAwhC1Fx
aYNBUdAinuKEXz69r8OMe6Xz/qC9yHIQR+OUafnBeAN6edJF0j9Hgg+D6ScoZI7J
z9FgLp64I27s+XvoYSFcdnumz8D6PjgWNZscAkphmDQk84wIZXEfwliLYn7On7i1
qtUTDOaUazJNlC0AED66
=DYSR
-----END PGP SIGNATURE-----

--=-9GWbxnyeh3eIQHUoH2+l--

