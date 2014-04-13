Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46266 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbaDMTZQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:25:16 -0400
Received: by mail-wi0-f176.google.com with SMTP id r20so3131754wiv.15
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:25:15 -0700 (PDT)
Message-ID: <534AE499.6020009@gmail.com> (sfid-20140413_212522_324754_3FB64030)
Date: Sun, 13 Apr 2014 22:25:13 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: iwlwifi 2014-04-13
References: <534AE330.2020805@gmail.com>
In-Reply-To: <534AE330.2020805@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="nXfHdStrGEpGckgRa6pSutcNCGnwBSK5g"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nXfHdStrGEpGckgRa6pSutcNCGnwBSK5g
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable



On 04/13/2014 10:19 PM, Emmanuel Grumbach wrote:
> Hi John,
>=20
> This is for 3.16.
>=20
> I have here a bunch of unrelated things. I disabled support for -7.ucod=
e which means that I can removed a lot of code. Eliad has a brand new fea=
ture: we reduce the Tx power when the link allows - this reduces our powe=
r consumption. The regular changes in power and scan area. One interestin=
g thing though is the patches from Johannes, we have now GRO which allows=
 to increase our throughput in TCP Rx. The main advantage is that it redu=
ces the number of TCP Acks - these TCP Acks are completely useless when w=
e are using A-MPDU since the first packet of the A-MPDU generates a TCP A=
ck which is made obsolete by the next packets.
>=20
> Same footer as previous pull request, I won't be available this week, s=
o let's hope I am not causing any problem here.
>=20
> Thanks!
>=20
> The following changes since commit a31267c30880ebdc73e6815f58c69a665052=
fab8:
>=20
>   rtl8187: fix use after free on failure path in rtl8187_probe() (2014-=
03-31 13:47:41 -0400)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.gi=
t master
>=20
> for you to fetch changes up to 3cd5279b021de6501a8012dd856d7a78ee58ead9=
:
>=20
Apparently I can't get the rid of my tradition to fixup something after t=
he mail goes out...

I dropped 2 patches that I queued up for 3.15 in my next pull request - n=
ew HEAD: e03bbb62cfdf539ae8110b297493c685f9d12774


--nXfHdStrGEpGckgRa6pSutcNCGnwBSK5g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTSuSaAAoJEC0Llv5uNjIB+OoP/0kB4kdNWcU66yAnaNQQ+Wi6
KctvMCCOpbRhLqLHinbysNiON/LjG3//lKvGZKMQQd7GoRy6L6Tg1wqKwQhLQ0lY
e+SkQOSD8yLROw1O/2Ue0AOd5ZWTmTMeTAHdqSHVwBsrvzaparhDvAIaXOvyh9EZ
25uS+uYoZ12T+OQyCznv2d5eDlYnEj6F1IvWnZHWxS36Mai82tXyWq5L3lHyJcus
4JVAc0NPgJdVqKkrUqM2bg2/+AEFaYHFgENNGqPTW0w99mPN605mgrtPCN5GlgGa
gUYfBRl+GzkoTq8YSihm14Aqbkw+nfeYSeuq7QXUE3LHRLHgiKxAfelkjgTaX1Pz
W4F/rGKTyaHSwPWKiisAfn+MWud0YeCUVaNXIze388bzzY0r6n3XVRr0zJLM16Ko
U7y6RO8Uok/pKpcZ4Xl+9KKzqYQlnYkHI5AkUt1hPHNlD+MeHPAjj8IIPPjCabD5
keUY0d+gfsWM6AGwSWfVlITGXtHNh0F9gQzbWXC5x+LLynE6ZY4AJf2pFRgDChKU
0yB86Ek9fCDxzkEdueHWQJS0Xv+CWFpV8Di+5Y8o5ff8bxAZ2CWtmFQhqHU8i7sj
eXzS0i0waJQqiar/4N8N9p9JSnNh3Mbo1uH2j9u8ikJbFIo9o7Og0RBpP3UWurhL
pQ9YWLbja2V3//dTqw2b
=LpAH
-----END PGP SIGNATURE-----

--nXfHdStrGEpGckgRa6pSutcNCGnwBSK5g--
