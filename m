Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35971 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbZKHN1r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:27:47 -0500
Message-ID: <4AF6C74A.4020208@hauke-m.de>
Date: Sun, 08 Nov 2009 14:27:38 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: IvDoorn@gmail.com, gwingerde@gmail.com,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: fix build of rt2800lib
References: <1257682021-23810-1-git-send-email-hauke@hauke-m.de> <200911081325.23424.bzolnier@gmail.com>
In-Reply-To: <200911081325.23424.bzolnier@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig94D6C9917D070B98313EACC0"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig94D6C9917D070B98313EACC0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

I am building recent wireless-testing. Without my patch I get the
following error while compiling it with CONFIG_RT2800USB=3Dy with
CONFIG_RT2800USB=3Dm it compiles fine without any modifications. Looks
like there is an other problem and my patch does not fix the real problem=
=2E

Hauke

  CC      drivers/net/wireless/rt2x00/rt2800lib.o
In file included from drivers/net/wireless/rt2x00/rt2800lib.c:35:
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_vendor_request_sw':
drivers/net/wireless/rt2x00/rt2x00usb.h:205: error: 'USB_DIR_OUT'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:205: error: (Each undeclared
identifier is reported only once
drivers/net/wireless/rt2x00/rt2x00usb.h:205: error: for each function it
appears in.)
drivers/net/wireless/rt2x00/rt2x00usb.h:205: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:205: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_eeprom_read':
drivers/net/wireless/rt2x00/rt2x00usb.h:223: error: 'USB_DIR_IN'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:223: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:223: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_register_read':
drivers/net/wireless/rt2x00/rt2x00usb.h:243: error: 'USB_DIR_IN'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:243: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:243: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_register_read_lock':
drivers/net/wireless/rt2x00/rt2x00usb.h:263: error: 'USB_DIR_IN'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:263: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:263: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_register_multiread':
drivers/net/wireless/rt2x00/rt2x00usb.h:283: error: 'USB_DIR_IN'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:283: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:283: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_register_write':
drivers/net/wireless/rt2x00/rt2x00usb.h:303: error: 'USB_DIR_OUT'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:303: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:303: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_register_write_lock':
drivers/net/wireless/rt2x00/rt2x00usb.h:322: error: 'USB_DIR_OUT'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:322: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:322: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: In function
'rt2x00usb_register_multiwrite':
drivers/net/wireless/rt2x00/rt2x00usb.h:342: error: 'USB_DIR_OUT'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:342: error: 'USB_TYPE_VENDOR'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h:342: error: 'USB_RECIP_DEVICE'
undeclared (first use in this function)
drivers/net/wireless/rt2x00/rt2x00usb.h: At top level:
drivers/net/wireless/rt2x00/rt2x00usb.h:439: warning: 'struct
usb_interface' declared inside parameter list
drivers/net/wireless/rt2x00/rt2x00usb.h:439: warning: its scope is only
this definition or declaration, which is probably not what you want
drivers/net/wireless/rt2x00/rt2x00usb.h:440: warning: 'struct
usb_interface' declared inside parameter list
drivers/net/wireless/rt2x00/rt2x00usb.h:442: warning: 'struct
usb_interface' declared inside parameter list
drivers/net/wireless/rt2x00/rt2x00usb.h:443: warning: 'struct
usb_interface' declared inside parameter list
make[4]: *** [drivers/net/wireless/rt2x00/rt2800lib.o] Error 1
make[3]: *** [drivers/net/wireless/rt2x00] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Fehler 2


Bartlomiej Zolnierkiewicz wrote:
> Hi,
>=20
> Could you please tell us more about build problems you have
> encountered and which kernel tree this fix is for?
>=20
> Thanks.
>=20
> On Sunday 08 November 2009 13:07:01 Hauke Mehrtens wrote:
>> rt2x00usb.h uses lots of definitions from linux/usb.h.
>> ---
>>  drivers/net/wireless/rt2x00/rt2800lib.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wir=
eless/rt2x00/rt2800lib.c
>> index 5c7d74a..b601a1a 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> @@ -29,6 +29,7 @@
>> =20
>>  #include <linux/kernel.h>
>>  #include <linux/module.h>
>> +#include <linux/usb.h>
>> =20
>>  #include "rt2x00.h"
>>  #ifdef CONFIG_RT2800USB


--------------enig94D6C9917D070B98313EACC0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJK9sdOAAoJEIZ0px9YPRMyE8cQAJuJXXFaNFftVdJ4ZD3irRLM
eEIVBZbpUAg6fQtR+Sax/HvQ9b2xLzmzSprpFuQr6K723DnyJLi4ri+xwFVQuHqS
pc+b0C8VAwgPv/RJI9N10CXc8ooTB5Y4jEEc8jx8I8tlnevxCDp1UoCVhfpT8/57
Qxvc6mqGGvziTnSa+N76bd9YIeuU6aPHCSA/Qu0fMcvx3yppeECKAmbEp+GGr23R
YITzjwSmr322VGnUruHxsCttRPvy7Pf6GE65i7PO3Uy6+BdipJNj6TA7/pJaonKX
Ncnzd787SkHjXGJy7CPWfY/vuG4ahUrUr+iIuniUXD3wqmWTX2PJELRYJqmhWUwB
OYz0/cdqaYLOkcNL3NqM1DOBBQHid6vneGTFJXf7rnEOQfwL4Oh8Zt7SkrBOHwve
2HzOw3npgRihpT0NFdx789oKNqkSTTfIVQy+hcQCaZijp8C+hVhMP145dWB6fDNn
emQK4ccGXnLvyJxMfZLn0eT0rMJq6mMQUDlxmgFFOhUiunnw/UTYekDcN/m2c8Ph
/u0PPZYetp3MkHENmFkhztqNcsh7oAdO+wKMH6HjNc7PTE3XQz1PBmlsMH5nYe1g
FnbVYNmsgcuuatKdzO1NZaHSFpxr491vJUHXQVeisanVyz2w1sFwlEeoQlkNV0DU
4wLx/76k5HhQaACw/6R7
=deuF
-----END PGP SIGNATURE-----

--------------enig94D6C9917D070B98313EACC0--
