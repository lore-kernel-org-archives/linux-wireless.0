Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759966AbYEBUME (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 16:12:04 -0400
Subject: Re: rt61pci/rt73usb: Hardware decryption IV/EIV
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200805022141.28351.IvDoorn@gmail.com> (sfid-20080502_213556_516117_4DC0B461)
References: <200805022141.28351.IvDoorn@gmail.com>
	 (sfid-20080502_213556_516117_4DC0B461)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V4kq0D5NgS4EiUMNYZZK"
Date: Fri, 02 May 2008 22:11:56 +0200
Message-Id: <1209759116.3608.8.camel@johannes.berg> (sfid-20080502_221143_356008_33AA6DAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V4kq0D5NgS4EiUMNYZZK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Does anybody have any hint on where I should start looking about where
> these frames come from, or what the cause might be of the disappearing fr=
ames?

What are the protection bits in the header? I'd have to look at the key
selection code again I think. What about the ICV, are you adding that
too at the end?

johannes

--=-V4kq0D5NgS4EiUMNYZZK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBt1iqVg1VMiehFYAQK8eQ//avlWo4ZPnIQTXuenObVWpvl44mN0YMeI
FfRYrvpcLJokJWblASY+SESNu8eA4oUU5HKXVtfiaCc2lectsNni2xGaUXUiefnm
qqkn1mV2Q8gazrE0Rl41nfgHLEUixeh/wGRF2uuGMkMv9dMOdYhw7kUWm/vMV4cA
B0pSfOv7yDL5zEnJLKnWcwjWdIUkA/od8DGvH/iR5isRTHfBA0qHAWe8BNOTLhXf
0MIa/4sk6HZEgpTDnkWoYYQq2bWZcq7oI9MlToBD/em5cdEk34B5wM3oeaEh4Try
u+6r76s//MYySov6UPsMiTYWW1BdwjqUZaeh3/g/CCCEPOukwHLSMq5MYrLxU/cQ
yVQPaq4NUgvzGnCRpiURlS/is25MeQTHEXyXUop+UnwfcPRiwzpilPfYDBQADmT+
z3KVPqi4CQwOn1Hewd7jzjrgDoUmAP3EmGDjbxq6v+S8VHzvErEFwZt/xudJTPz1
Jaki5Ii5/RnRJNwry3jUiF4ja149vPa3xc0cA7RGNpAgSJK25V5E8FtzwTYLkRp5
JdjPdJA3r5zNbVdbVtCRGqpOlor8qQ29O3e2S8UI+iqs3jXCS1tteoOUVMldOR3E
ST8hf+zXhYVhBoFS64RAIgSxCHMABfQ8NGIs278e8yKONRWXxMvacujQO+CWb3cI
yRlM+3Wuc1U=
=Uw3r
-----END PGP SIGNATURE-----

--=-V4kq0D5NgS4EiUMNYZZK--

