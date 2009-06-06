Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306AbZFFRiU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:38:20 -0400
Subject: Re: [RFC V2] b43/legacy: port to cfg80211 rfkill
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200906061138.02636.mb@bu3sch.de>
References: <4a2961a7.RxVbjEA4JdOf01BF%Larry.Finger@lwfinger.net>
	 <200906052338.05653.mb@bu3sch.de> <4A299E57.4020007@lwfinger.net>
	 <200906061138.02636.mb@bu3sch.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-88P8njWwLDGvCRQn+hdw"
Date: Sat, 06 Jun 2009 19:38:18 +0200
Message-Id: <1244309898.17485.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-88P8njWwLDGvCRQn+hdw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-06-06 at 11:38 +0200, Michael Buesch wrote:

> Huh? We cannot do a simple  ifconfig wlan0 up  anymore to bring the inter=
face up?
> Is that overridden by rfkill now?

Yes. Face it, it's the only logical thing: you cannot connect to a
network anyway etc.

johannes

--=-88P8njWwLDGvCRQn+hdw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKKqmHAAoJEODzc/N7+QmagDAP/1oL4lhwfixR4p72M0WgMv3n
/fdbHvKDBrw9IhJHqUzr3UENw0y69f5zUI9ZfFdzausYzlKK4riA1FRs+HxDQWWS
u8zeyb+7PsqhZNzTEY5T7DfGysPIMG4JKZwShN28DH47HU3cWqIXAjfD57VY2bjb
1Vz1upcwAO6gQqyGa+yDjVuYRSlTPrgASt7oHm35LKQ6z2i13Fzy8e4JrhiqQLz+
HpXaqV6uxSUWQS1tknC+8I5rUBKDdOGgkO2g9aux8IHeujT39dqgJ3/pPdsTUEo6
8KOILbRHEy9An9zCh57NYaHHRX/X8DitHLL415A8EfMXeHcwBGFjzvNwHToBLaRg
pQCDoIBgZXNJKH2VQh/6jwf8UiLAZL7V0WZVc93EZma89et9EFgxLETQCE3PwHeK
hgPklSAHdvyKixik7I5Nwy2dx3viGFBsJiaqdGucQryZXQ6ypU2SvsBF6uIzKv4b
1zH/TpH5jPYmQ88RueoijtDDNxrrhRWgiK+Gy+wpvF2rHVnqU20hsVVuTxDd+tIk
vYNtjNPy6itaKfNEThfwnv1tyK/O9y+BewCPwibvtW0AMpLcCx0Em03gF+6i93C9
FJdIM54bNwNSA90+Cp4sSCUGKaFDXuQhYk88fSQg4deYCu3Z9CMTxgWKblUUwehA
qle/yXwFEedlTCfKk5DU
=4DyN
-----END PGP SIGNATURE-----

--=-88P8njWwLDGvCRQn+hdw--

