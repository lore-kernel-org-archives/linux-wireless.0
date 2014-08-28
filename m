Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mxin.vub.ac.be ([134.184.129.112]:57913 "EHLO mxin.vub.ac.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbaH1Mmy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2014 08:42:54 -0400
Message-ID: <53FF23B6.4070308@telenet.be> (sfid-20140828_144257_221395_802555FD)
Date: Thu, 28 Aug 2014 14:42:30 +0200
From: Ruben De Smet <ruben.de.smet@telenet.be>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: b43-dev <b43-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Looking for someone with BCM43227 and (maybe) compilation skill
 ; )
References: <CACna6rxVjnpMgQx9+d_LbROYNnnjnuMEGo-38MPwjsPtxYdN8w@mail.gmail.com>	<CACna6rx+EkoCPQ06qDTbaDFEJ1hrn_CYSbrPmosF0ikhkqDxpA@mail.gmail.com>	<53FF21AA.5040406@telenet.be> <CACna6rwde+H8K42FgsHH=FT2tW_3o_NwVbk0ZyM_L3fVtfwAsA@mail.gmail.com>
In-Reply-To: <CACna6rwde+H8K42FgsHH=FT2tW_3o_NwVbk0ZyM_L3fVtfwAsA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="fij3sj8bPoxKGPqFHAnARmq6tdsipCpxt"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fij3sj8bPoxKGPqFHAnARmq6tdsipCpxt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08/28/2014 02:39 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
> On 28 August 2014 14:33, Ruben De Smet <ruben.de.smet@telenet.be> wrote=
:
>> On 07/03/2014 02:50 PM, Rafa=C5=82 Mi=C5=82ecki wrote:
>>> On 3 July 2014 14:32, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrot=
e:
>>>> I want to add support for BCM43227 in b43, however I need help of so=
me
>>>> BCM43227 owner. Well, I could buy one by myself (less than 10$ on
>>>> eBay), but I don't want to wait a month to receive it.
>>>>
>>>> So I need someone with:
>>>> 1) BCM43227 ;)
>>>> 2) Kernel with CONFIG_MMIOTRACE=3Dy*
>>>> 3) Broadcom Linux STA driver 6.30.223.141
>>>>
>>>> So? Is there anyone around with BCM43227 willing to help?
>>>
>>> I'd need someone to:
>>> 1) Disable NetworkManager & blacklist wl
>>> 2) Make a cold boot (power off for 3 seconds)
>>> 3) Run attached script
>>> 4) Provide me /tmp/dump.txt (preferably compressed)
>>>
>>
>> Still needed? I have
>> 03:00.0 Network controller: Broadcom Corporation BCM43228 802.11a/b/g/=
n
>> That is one iteration higher.
>=20
> It has appeared that BCM43227 and BCM43228 are pretty much identical
> from programming POV. You can try 3.17-rc1 (or newer) to see if it
> supports your wireless card :)
>=20

So my wireless should work without the crappy proprietary drivers as of
kernel 3.17? O.o
You're saying it's already done, or should I still run your script? :)

--
Ruben


--fij3sj8bPoxKGPqFHAnARmq6tdsipCpxt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJT/yO2AAoJEPgmWogSE9wQcQQH/1DJDLh5RBE8a6kpgItU71tb
/CoHbnyrCkQy9/7lQm4vjZxph+UlWZG5z8Owk4hK+hVv1JmHmjZVSlaewHc9IJn3
9wpPWAQJe8viRgU86ltDNUSJ38JRznbCMuEUI4II4OTnRbCS2S7pWgoBVxAmub15
Q9wfZB/HmlfT1IZ/Rr6xVvFmpgZqeScmNFWB7QLGoh42S70CPA3gyWInoWqeZCw0
VuP0ah8S7oAFgdRUj1utiPYHZHonDUfK7Sje7eddE6owrE5cyQ1JsmZTP/Eq4hLh
wQ7CmTn5+jRlHtfql4KTK+MDIKtRBSuLXMgfVgeXGj30/lWVSFUVJDqx9qZpasI=
=bhs0
-----END PGP SIGNATURE-----

--fij3sj8bPoxKGPqFHAnARmq6tdsipCpxt--
