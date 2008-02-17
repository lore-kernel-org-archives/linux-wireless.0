Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:59853 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbYBQOLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 09:11:16 -0500
Message-ID: <47B8406E.8020105@hauke-m.de> (sfid-20080217_141123_577033_9BD68BB6)
Date: Sun, 17 Feb 2008 15:10:54 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Wu <flamingice@sourmilk.net>, andreamrl@tiscali.it,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Kernel panic after insmodding rtl8187
References: <47B71171.6040805@hauke-m.de>	 (sfid-20080216_163902_820241_FD2C42FD) <1203243029.12783.25.camel@johannes.berg>
In-Reply-To: <1203243029.12783.25.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F5B120668040D47D9C74BE0"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F5B120668040D47D9C74BE0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi

I have no powerpc machine and no serial console so I mad a picture with
my cell phone.
http://www.hauke-m.de/fileadmin/rtl-wifi/kernel-panic-2008-02-17.JPG

The error appears when starting the wireless network with "ifup wlan0".
The insmodding works without any error.

The picture was made on a up to date wireless-testing kernel.

The errors after doing ifup are also printed on an vanilla 2.6.24
kernel, where the module is working.

It is an AMD64 System with a x64_32 kernel on Ubuntu Gutsy
--
Hauke Mehrtens

Johannes Berg schrieb:
>> If you need more information please tell me what to do.
>=20
> Do you have a powerpc machine where you can put in the card? ;)
>=20
> In any case, we need whatever came *before* that stack trace. Got a
> serial console or even digital camera?
>=20
> johannes


--------------enig3F5B120668040D47D9C74BE0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBR7hAcoZ0px9YPRMyAQKDpQ//fd3o03W/vQKyVmaSCA7NEO5JZ9fJiPEK
wY1PBm5ZpKQvtdslgzBjvIu8q4QKf0C1Jv0XnIa2E9res1q3HQ36+RFXkcBp8eRm
YcDOHr1RO8yvl/o5Rq1QgknV+C7KVBByY+b5ztVMU3T0zeIQRXZNl/6514vCGi7b
d4M4FDMkfYig3OH18IJmioSJ+24STSSHedoeevcYRHa65wsW0oyIRD6WK3gz6n2r
22eqvdQz6/RcEQIjXEbR0Gt3KIMWM9RtdABZ49w2iyY4eMlfk8LjQ/MAU5P6AMET
5pWwb4sG6zpPRAqNWFP0FowAUHl5xMe9xl4SPybLLVbqmE9RmIOTa1igYvjwWYHD
dQd72Uotscm3fepr1qwS36hLh7WwqiotBIIhU9pvUtde5CQNzHEcD7dLZvN6slb3
CcCcwi/pin/2sITQZP19MQovzgTk5+k9TIaZBHcCOLvyRNLKZcWcLotxOf8ZfhqR
evcCP8zXA5/yoE9Qn3Y7FJyQD5/ku5cub773OS+GHsgCCkYsutr2281BdqbYj+Jr
VbVm7Mt+xKtULXDKzilsyQJNHP8gglvZuA2Lds97TXBXVJqBt9Lqbgd3DUVMVa4l
Io8COx/HeeC8lfjJp+TZHIcIsXy0yU4WxO9WCSQOJsHMxR7/mKnV8tK4KnDInX6r
zPCUzcZy8Ow=
=phds
-----END PGP SIGNATURE-----

--------------enig3F5B120668040D47D9C74BE0--
