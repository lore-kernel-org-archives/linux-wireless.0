Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from theos.kyriasis.com ([212.71.254.33]:46990 "EHLO
	theos.kyriasis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbbBLR17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 12:27:59 -0500
Date: Thu, 12 Feb 2015 18:27:53 +0100
From: Johannes =?utf-8?B?TMO2dGhiZXJn?= <johannes@kyriasis.com>
To: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: rtl8192ce kernel panics since 3.17(?)
Message-ID: <20150212172753.GA17043@leeloo.kyriasis.com> (sfid-20150212_182823_320409_E94E0FA7)
References: <20150212121057.GA1804@leeloo.kyriasis.com>
 <54DCD708.3070402@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <54DCD708.3070402@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12/02, Larry Finger wrote:
>On 02/12/2015 06:10 AM, Johannes L=C3=B6thberg wrote:
>>Since sometime around version 3.16 or 3.17 I've been getting a lot of occ=
asional
>>kernel panics related to my wifi driver. My laptop has a Realtek RTL8188CE
>>wireless card and uses the rtl8192ce driver.
>>
>>I have pictures of what I think is two identical kernel panics, a couple =
of days
>>apart:
>>
>>https://lh4.googleusercontent.com/yjwOnrDmioCwuC8FqIXlKMiBTOXddLyJkWTiInJ=
oX2o=3Dw421-h569-no
>>
>>https://lh3.googleusercontent.com/-xM-1wSsVu4c/VKxDnlkgBbI/AAAAAAAAIng/Hx=
tqgHgglHY/w421-h569-no/IMG_20150106_212020.jpg
>>
>>
>>It only seems to happen when I have several days of uptime on my laptop a=
nd just
>>use sleep all the time instead of shutting it down.
>>
>>Also I have a picture of a kernel panic that is different from the previo=
us ones:
>>
>>https://lh3.googleusercontent.com/-Hj06Csglpa0/VKrI1al6QbI/AAAAAAAAImk/Vz=
hmN-dfSB0/w657-h486-no/IMG_20150105_182236.jpg
>>
>>
>>Not sure how to debug it really, but figured that sending in a report wou=
ld be
>>worth a shot.
>>
>
>What kernel were you running when you made the photos? Use the command=20
>'uname -r'. When I get that information, I can then use the dump trace=20
>to determine the locations of the oops.
>
>Larry
>
>

For the first photo it was 3.18.3 and for the second one it seems like=20
it should be 3.18.1 from looking at my package manager's log.

--=20
Sincerely,
  Johannes L=C3=B6thberg
  PGP Key ID: 0x50FB9B273A9D0BB5
  https://theos.kyriasis.com/~kyrias/

--OgqxwSJOaUobr8KG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----

iQQcBAEBCgAGBQJU3OKTAAoJEJAcHDIOsNRdulQf/1LkD3SHg6ZN1LcIR1KmXlgj
bDchvu4X0ZW0MhwGdU9qMdm6b2AFnPAR5RnCo+IXQtNiM4pZSRxkQG3eWNRZsqjN
5TYz5dmgqsRw9cQxvjV5vD3f8wjZ9fLBvssL4mKPj554q1c6qZ0BjvE+9oOzrAU3
mRS+9LU17RZT64UB/fqxhoRxvTLAWtgW5FagR5ZwJ7MeNTPXOWlSmuAISZNFjAcF
LN6aR9+SKyeKT8dh3LMgtSRhnrjIkMB21hD9Pzvhu/PS/BZ4IexVGZ6AT6aSBLFF
smjjQQDUqjG42+3IkGixoPP/rLw1sHMDKJDyyrFfEjoket9CNimszGddHdUymiCv
tXSCtXEd2n1tq+T+rNON6SMgNuf1ntWFcxnAmSC040PyFzQteXFHBETvFGJNfkfm
lzVw+6KhgchqzJNJ45NJ+tfaXFmHji+NiUkET/+GyfA0iSJQoauvvBjjED2PKaJA
IW4sgyMTtlp7LwB460j83SMz3QJWdQjTa7sYmnRRd06FKZxJ2xWNvKiRrCX3BaqY
0maf5pCkqKvL6JhoyNBgUotR55ohfh1jAl4T6yDyit5wqYgyJp7NWu7S8fUAvEvc
WjBWIILtYvMV7RliZgPTBXiOrgbCfbr8UpFOKBs9Kf9Mvxkk3lk6ph76grfcOqfc
SdV2jejPVFxOv5n3XsNLuZjsgsKAwOL984skxEO9onoDvj0khZZSHtrX85jQ3azr
fKCogQPQvN5VfFKpLHd72dRgLQNpMbnSQClivoiNtTbi7Zt9cFcw/lIlxp8TJepk
muB/HOrRRAi7dB8Mp6A9D4I9k1X4Ph1lcAv1FCn8xuKk3HA/87iUlT8ZAT2AVdnO
nAK6olW8dbY4K8mzPJ76j4uNifEXC0dm694sl9IwgJQXPagfAnWkSJB/NB0iSF4c
sxFZC3bHhcCnBXl6jrisOJp+PdjTp8H0xYlK0yOCk9IGr6sss8G9iEMSsR64/5ff
V2rTuro2KqAbj/s8v8KHfVT1Ws7WLjmWXaeYgKIXy6BrdTUtaVD6nl7k/1tD6WL8
DXrVPHxXKwt2/jQ3AhG6Hpa6lWEpbs+1osqvfNq9ff9RXq1TArbFNKZae0jJKWJF
dkwtDJckdvQaZphjowzZPfw3zyCIByD5IVviNeJEUGlUPGKWQzrTpHhzJKcK1XwU
TriGZsm4n6Pj4rO6PxHv2o3fVUyHUHdach3zapP7mpKz/t+EzaGBXaoLEtc7AUuk
haf3jwZ6MH286h5vXhPfp0v3XMAC417DrjOe0yIqRuWQCgPmU7Irs4g+R4p0hhYd
RNafQtJy0/6Yy+pdLylm4Wq3+IOqmzpAoBm5OUtOHhIrgbvq+ns9KfBJPbC2enY=
=nr6Y
-----END PGP SIGNATURE-----

--OgqxwSJOaUobr8KG--
