Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:49020 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932987AbcFCVgM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 17:36:12 -0400
Date: Fri, 3 Jun 2016 23:35:19 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] b43: Remove unused phy_a code
Message-ID: <20160603233519.4606b1ef@wiggum> (sfid-20160603_233616_517355_C2F82CF1)
In-Reply-To: <1464989566-1393-1-git-send-email-linux@roeck-us.net>
References: <1464989566-1393-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/GoH64hS27nGJOm4mgDWYd/V"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/GoH64hS27nGJOm4mgDWYd/V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri,  3 Jun 2016 14:32:46 -0700
Guenter Roeck <linux@roeck-us.net> wrote:

> gcc-6 reports the following error with -Werror=3Dunused-const-variable.
>=20
> drivers/net/wireless/broadcom/b43/phy_a.c:576:40: error:
> 	'b43_phyops_a' defined but not used
>=20
> Turns out a lot of code in this file is unused, so let's remove it.


All a-phy code is usused.
So you can basically remove the whole file and any other A-PHY code.
... or just leave it as-is.


--=20
Michael

--Sig_/GoH64hS27nGJOm4mgDWYd/V
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXUfgXAAoJEPUyvh2QjYsODCQP/RKpxE69wX0oQf7rLDl14s/Q
WuBQ8LU8PwcHJMymq2xe1pGNRAvJhoEg30hQGm3DeOX2wJNfDDFm4S3oYTmnacxL
YYzs2nSPnRiYzFP8PE7OX10EiOrMlYVMiYJY+mW0BVO1uxlJ5lmsGT/44TJhoerg
a9Z007ffGu0PM2EGltnr06OmnEqoEOt6o/P3lnJcXeMqBn37gL32vtE9HcWcfNl0
2i/B2+mIHfE0t+a/ZRViNICOOVNVNRPDmz+qHFix2lB7LHATDJ0msCkVyoWzcBZw
+unmqqJ5HpIdKdB9MYUjwUb+OX94TifJs/fq06t7Gi6pyzZSfiDjHZYlDqARpB8T
x3HV4Qqbn7kJF5I13qkK5Z5hJJG8aDr06J6xkqKwC46KxwTxfJt1H8R8QMFCjLIR
hqPj6AwAMQzIpqybT/pxzTZQ5PMBM8pDkv+pAUqBE7TuSM5lFvQusTGQJyV/nqT0
XCeU7f4b9wOetv8LrWtfQM2U5vvGBYbqesJtgIhpBvcDpMz1ALj75WPIAqLJdbU0
R1GtPYtARXXHftYwY1zFTYXJbFR7cr+M3ZIZzd8a3SlkTtZiAK6STm8yZGy8YVZp
slJoOliVlSosgMZigfCBsn3mAt9L3Y/ZJM4yM8Ao3CpQZ//0cI2jpbIoQU0V490j
27jnMszysvfI7LHDDA+J
=2o1O
-----END PGP SIGNATURE-----

--Sig_/GoH64hS27nGJOm4mgDWYd/V--
