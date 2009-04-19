Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60045 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758463AbZDSOL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:11:26 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419140523.158830@gmx.net> (sfid-20090419_160555_446977_A429511B)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net> (sfid-20090419_160555_446977_A429511B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FA9XpZtFpDec//V3CeQB"
Date: Sun, 19 Apr 2009 16:11:17 +0200
Message-Id: <1240150277.898.7.camel@johannes.local> (sfid-20090419_161132_826594_9038E8C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FA9XpZtFpDec//V3CeQB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

Can you please spell "different" and "difference" correctly? I keep
getting confused! "deference" is an English word too :)

Anyway, I think you're confused because cfg80211_assoc_request looks
like cfg80211_ibss_params. Trust me -- that will change.

Either way I'm not going to argue this with you anyway, I've already
decided to do it this way. You'd have to find many many people who agree
with you to convince me otherwise.

johannes


--=-FA9XpZtFpDec//V3CeQB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6zEBAAoJEKVg1VMiehFYPiAP/1uMBCbk7XwuxUZkQhfBhKK6
SOKHIxG/miL/z24JZ0im8LRAQNp4NlQ41Q75rN1i8rGlS87gSeWmXU/KF1UcIxWH
r7u3fYygmhTvw3Aa51XWdthNG6JOv+hZ0ie1QOK5xqK83QNzVXXXRBL7vQFXaiWU
BS7H1dl5ibGx6iEpp9QGhOdVwR7YlHfcJd2M2cCYb421m2T5jmsC2YXFES4xv3Cz
Bzc1uGI3vbFxucvkh7Q1zu3Rz5Sed6c33wISbgC3kXKpo0CQ6xw5ENQ0hsnUcyBJ
+WKbyk0X6eOXlQdmniqV/kvkonDo7lECK/W4ctEPHyXfdR/z5VmpiJys0QBP+iiY
RA+nhm7QgllZxNmrRwj3VJ8KslIGp5B8Paz/VOmP+J+i4Vd0L8pBigk/gshQfGUd
L+dS2r3bsvS2qE385iyF0AbrsNFldxjZ6QzmyoodNuJOf8nFrOBo8PZbep4V2UlI
Zw21Bp+YgOYnIyyeXcF1BhFHLPsaXclVdqmIoyu3UcDji3V25tuPXoP/ktcZezwg
zTNzLPGR2eF5/5y4o1SpQgaDOac4L7CQroZ7qd++WAij6ajHD79GfiuZZDfD5QfR
Jy7bPk3/S0bOA3u9OiivttfofWS2j6cZx2zfJeMlopueQzBy+oyMFN2pRGd71qgW
b+dvuzV6xIDLQqYfGTCF
=8U1z
-----END PGP SIGNATURE-----

--=-FA9XpZtFpDec//V3CeQB--

