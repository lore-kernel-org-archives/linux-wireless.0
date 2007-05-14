Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13533 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754696AbXENO5I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2007 10:57:08 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Ivo Van Doorn" <ivdoorn@gmail.com>
Subject: Re: [PATCH v3 1/2] Add 93cx6 eeprom library
Date: Mon, 14 May 2007 10:55:56 -0400
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200705140138.52596.flamingice@sourmilk.net> <a32f33a40705132349h367ba18aoa046d5583329ead@mail.gmail.com>
In-Reply-To: <a32f33a40705132349h367ba18aoa046d5583329ead@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1312275.mTsP9La7GT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705141056.01199.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1312275.mTsP9La7GT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 14 May 2007 02:49, Ivo Van Doorn wrote:
> For the record: I am still not happy with the removal of the udelay() from
> the pulse methods as they were indicated by the original Ralink code.
> But since I cannot test the effect on Ralink eeprom reading at this time,
> and I could otherwise just add it to the register_write handler if
> required, I am signing this off anyway.
>
The udelay is necessary to set a limit on how fast the eeprom is operated..=
=20
but not on all hardware, apparently. adm8211 just uses a read from the eepr=
om=20
register to perform the delay.

Thanks,
=2DMichael Wu

--nextPart1312275.mTsP9La7GT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGSHiBT3Oqt9AH4aERAmkMAJ4ikyPZofWLNUyBUaZIkBZiBCDpQQCg07pM
jap7XTZJrOTFypZM0vKqSwA=
=P+iM
-----END PGP SIGNATURE-----

--nextPart1312275.mTsP9La7GT--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
