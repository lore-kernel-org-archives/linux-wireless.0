Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:23106 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbaETGtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 02:49:16 -0400
Message-ID: <537AFAA0.3070401@meshcoding.com> (sfid-20140520_084919_333885_9A9ACD7D)
Date: Tue, 20 May 2014 08:48:00 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH] b43: xmit: set 5 GHz bit depending on current band
References: <1400568385-26182-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1400568385-26182-1-git-send-email-zajec5@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="WukjErK3AGaCDa6Q1F0TR8xQKd47hTkGf"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--WukjErK3AGaCDa6Q1F0TR8xQKd47hTkGf
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 20/05/14 08:46, Rafa=C5=82 Mi=C5=82ecki wrote:
> --- a/drivers/net/wireless/b43/xmit.c
> +++ b/drivers/net/wireless/b43/xmit.c
> -	if (phy->type =3D=3D B43_PHYTYPE_A)
> +	if (!phy->gmode)
>  		mac_ctl |=3D B43_TXH_MAC_5GHZ;

I am not familiar with this driver, but wouldn't 11b mode fall in this
case as well ?

Cheers,

--=20
Antonio Quartulli


--WukjErK3AGaCDa6Q1F0TR8xQKd47hTkGf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTevqkAAoJEJgn97Bh2u9es2AP+gK/YfoYbXJMqbfmPx4al6x5
Nrl7AD1U6EPJSFJuhMhbUje/YHDTFXlmsul6XWOsHxVnFI3EfOorZbgblyAGtSQj
0iy3n8rYxjoVI2AjfK9A98lMkvehQpIoQf90I0olyKxXYun7zsBfN8zzBxYrD9Uc
JT5QrzD9p/teBqQrerJx/TPFJywspn5We1ryjuOqKnSH2kDOykT/0xlsMJGsGemd
MD4IMQIpyxZeZKrT6/RJ45NIH4KCcofwxXfHjRw4aAfP13VOOXnHFgy9nDVSPWVj
KlXm1d10EprEy4/q5LL+ELV/+E3rv1uwqlFfMW+fwdQtj0UUA2apNOkMUogB1qQu
If+nmGEqNzkA+/iOqg2t2Z1UBgl7dd3fJ/W+Qw5sJxZEPK4ahgoWRmMU2ZTcX5Lm
WrcmzIq33v72up5XcBynhO1usCTii742fawdZ/BAIzLi0stg/IaQfKmSffKdusDB
ZKb24gO7uykoN3wjFm955p2nka2W5f7zbvFGp0MJwZfJA8PxNrqc13NVTa923jJ7
Bs/Mmz4Q2iqaGEA8Xcc11Y971BDllpitg4C82geg9DlrGKLaiuPokH9gZzv3KVa9
UER58ltArCXfbd9/P8Fxau7blqVTc+1fhzp6GFEK7Y0cPU/bSQuG2ZQcZbjCeU20
GWhVVZu/2hPikYRHN+ZY
=2+i7
-----END PGP SIGNATURE-----

--WukjErK3AGaCDa6Q1F0TR8xQKd47hTkGf--
