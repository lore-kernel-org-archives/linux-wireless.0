Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYF1IAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 04:00:41 -0400
Subject: Re: Missing channels on iwl3945  shipped with 2.6.26-rc8
From: Johannes Berg <johannes@sipsolutions.net>
To: janconrads@gmx.de
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4865B3C6.1030007@gmx.de> (sfid-20080628_054520_514865_A52F30EE)
References: <4865B3C6.1030007@gmx.de> (sfid-20080628_054520_514865_A52F30EE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UGfimbFB1px8UkT+4WK2"
Date: Sat, 28 Jun 2008 10:00:29 +0200
Message-Id: <1214640029.5507.10.camel@johannes.berg> (sfid-20080628_100044_117182_12E3505E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UGfimbFB1px8UkT+4WK2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> vermagic:       2.6.26-rc8-jan SMP mod_unload modversions CORE2
> parm:           ieee80211_regdom:IEEE 802.11 regulatory domain code (char=
p)
>=20
> I read, that 64 should be ok, but if I set any option only the 2.4GHz
> Band is listed. For germany 276 is a common valve on atheros cards, but
> this doesn not work, too.

As you can see, it's a charp, i.e. a string. Try setting "EU".

johannes

--=-UGfimbFB1px8UkT+4WK2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIZe+ZAAoJEKVg1VMiehFYJJgQAMCDSSgGSJtQ7EVom2LHZjYe
pbLx9FhhrRaNHx5C9qKDmD94d4h69iyEp3ldXkQiALFIGaNndzn++Q2qDBpmFanG
YClxYKn7gvDVE5laILLcrXTRK1rhoXn/GpsvlOAU0y5A1alF+CyJOl+3bSgvmKSF
oc6Tozkl/URGtczTTuKQupMm2mLSUcKPXU6OmaQPwk8J4jmoBKKYKir1xXBP7mhN
tlX7SFkaoRaC2LWd5l4gsJPv52vE3+Kgcp9nkbJoiMpxG77uGz7/1jl+WYNfkdH5
Gsq4oToTb34lVYXijjhLSSYYD9tseAhVyxZlmmvrDTtAw4WXY/K/ndLc/P+U6bzY
M0MKpApBrQyXQktT7NkJe2IBSNh4703Uw3JN7zeD8RI5Xx3M/0hW4svm07Ap37fn
8JRcsDzjNk+q3iB5R63nr2KmWCuq8qcUOqLyLxm5MfzISFnV50D1pT1zCSzX2qqK
XYmShoJuDpta1Jhhfc7iaxDP/YYdrCnS6T/n7Q47e0nRHx5Yy4eVC6hz9C2nDx11
OdHFomBx/AzDTphzGjqsCNKYTDDgMNhit735bBxSxQ8957FLi+l2h5nI5y0i79hW
4jsDw1Pk5j6W8xxCk9ddh9vmg035SSBamSGph1acbQiFTkLTaLmnUGM3JPfL+b9v
WTQJNlW3gOJIDc2+PyW3
=A9Fz
-----END PGP SIGNATURE-----

--=-UGfimbFB1px8UkT+4WK2--

