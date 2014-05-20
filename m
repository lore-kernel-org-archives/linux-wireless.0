Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:3346 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaETHLu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 03:11:50 -0400
Message-ID: <537AFFEB.1040707@meshcoding.com> (sfid-20140520_091153_285306_B1EC3259)
Date: Tue, 20 May 2014 09:10:35 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH] b43: xmit: set 5 GHz bit depending on current band
References: <1400568385-26182-1-git-send-email-zajec5@gmail.com>	<537AFAA0.3070401@meshcoding.com> <CACna6rwa6zKX=ngSQhmWTrZcy_W7fjMrTmQ-A8XURZCVMX1nrA@mail.gmail.com>
In-Reply-To: <CACna6rwa6zKX=ngSQhmWTrZcy_W7fjMrTmQ-A8XURZCVMX1nrA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="eOMs538DCpmKxKE479ehKbLXjPXSCMhH5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--eOMs538DCpmKxKE479ehKbLXjPXSCMhH5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable



On 20/05/14 09:09, Rafa=C5=82 Mi=C5=82ecki wrote:
> On 20 May 2014 08:48, Antonio Quartulli <antonio@meshcoding.com> wrote:=

>> On 20/05/14 08:46, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> --- a/drivers/net/wireless/b43/xmit.c
>>> +++ b/drivers/net/wireless/b43/xmit.c
>>> -     if (phy->type =3D=3D B43_PHYTYPE_A)
>>> +     if (!phy->gmode)
>>>               mac_ctl |=3D B43_TXH_MAC_5GHZ;
>>
>> I am not familiar with this driver, but wouldn't 11b mode fall in this=

>> case as well ?
>=20
> What Broadcom calls a "gmode" is 2GHz. So this is a simple bool
> 1) gmode =3D true; // we work in 2GHz mode
> 2) gmode =3D false; // we work in 5GHz mode

Oh ok, thanks for the clarification! I think the variable name should be
less ambiguous then, but it's your/broadcom code :)

Cheers,


--=20
Antonio Quartulli


--eOMs538DCpmKxKE479ehKbLXjPXSCMhH5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTev/vAAoJEJgn97Bh2u9e9YsQALsT/JoxvoF4TiMYjMlWcCP4
HOHsgkeo67XTblZcLa5oENHNf4vk7eKDYF1FGU7i/DLE0sSF5I4OljdXbs0SYIpb
Pu3yjL3UQvY+SoxGm7fE4Elvy8ntF82eV3YgJ2SqSoSGMdZsTLZfLV1F9YOc8xoJ
xU9+LkRpng5ILWDTeuFUBBCq8WfrX5rYq+CoB4zw4LvZup6b3xVmpN1b26ksSAg0
c2y8cmoSv3OxVjyIxqiH0tSbnFiGpHXNfGg4TU8zoo71dugiihpKhkeRVuVLX8Oy
WVLGeZ2peXONaVeitXqIY9obgFhL9KafK9xsIILoJ0wj0Bnm9YsMbkznYVuwpnsp
/uNS9LZAomK+yiB4hfnqiF1GluYr9rq9W8G/MYmKtNiHfKzaTavquuQemrIlfq8L
41ecfD6msf7qqdyAx2oBea1Dpxczxf8Go6TfXHDRUl8QUeLjDVIHsmfxSqqt97KO
C73/6UHQ2/lXnx73vhCoCZM4K/fwOc+tUizXKo+Hkt8G/q/JoSlK2t/fX9NJIXCW
vrYUyRVQwV2ByhW6AkFFqKknAtok3J+r9aGTjFA8vWPSmLzVFmFngBw6BVsZQrQj
awzUY/ave7ZeR5APNJF2dCF/ZysrFdQ48XVBAkXbQXG8ys1g/zaYoHZJ0BYAvtYo
Qff5+c3eJkIXuDgo50r1
=mwzC
-----END PGP SIGNATURE-----

--eOMs538DCpmKxKE479ehKbLXjPXSCMhH5--
