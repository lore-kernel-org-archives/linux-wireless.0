Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57740 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbYIQL0S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 07:26:18 -0400
Subject: Re: iw packaging
From: Johannes Berg <johannes@sipsolutions.net>
To: "\"Adam" =?ISO-8859-1?Q?C=E9cile?= "(Le_Vert)\""
	<gandalf@le-vert.net>
Cc: Jochen Friedrich <jochen@scram.de>, linux-wireless@vger.kernel.org,
	Thomas d'Otreppe <tdotreppe@aircrack-ng.org>
In-Reply-To: <1221650286.9262.57.camel@johannes.berg> (sfid-20080917_131902_131893_ED5266A7)
References: <1221596962.9262.12.camel@johannes.berg>
	 <48D0DEF0.2060407@scram.de> <1221648205.9262.48.camel@johannes.berg>
	 <48D0E463.70008@le-vert.net> <1221649638.9262.50.camel@johannes.berg>
	 <48D0E5CE.8050401@le-vert.net>  <1221650286.9262.57.camel@johannes.berg>
	 (sfid-20080917_131902_131893_ED5266A7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/FLiKiM/TM3ph+oAh/Mp"
Date: Wed, 17 Sep 2008 13:25:29 +0200
Message-Id: <1221650729.9262.59.camel@johannes.berg> (sfid-20080917_132638_501947_7A619287)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/FLiKiM/TM3ph+oAh/Mp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-09-17 at 13:18 +0200, Johannes Berg wrote:

>  * removing interfaces now works like this:
>      iw dev monitor0 del
>    I didn't feel inclined to keep the old syntax because it's rather
>    ugly but if this is a big problem for you I can add a hidden command
>    so you can continue doing "iw dev monitor0 interface del".

I've gone ahead and done that since anyway who knows what else is
already relying on this...

johannes

--=-/FLiKiM/TM3ph+oAh/Mp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI0OklAAoJEKVg1VMiehFYYvIP/0RbuBWd4oOCukp4rwSpxkVW
zcFLFZBwFbB+x2dfXsoBex3X8uI7YTjAQZk3ZFvKgekxEcnuY7ItNeR2lLbieEe2
OhtZdfdQy7D7lhwy2Igu8cydfPMJuK0F7grtJ90ifBH0D1Y/zJYFCsEPpZtnX2gy
HT2my2hkp7/25NKvIOUJK/KehsXwSvNoCAvSwpOIFbp/w6gZqnbfXseZEV+9+6RB
n0CuzOwDVwGfulDX7wuvRSf0A+NHas6ZyA7TypxZ9TMZoQA/AMETqv6TVriv+iLx
xcu2OqD6Qbwx4XykfIV4VgF2/0gmfVkfoj+Y1LyBDq3wtaeHODvClnMkp15thYfm
TTMFhvu5anIkhW4/XoQkZ34/byms5DWj+bVBwViJ95acPFdg5Gdq1vytx9jV+9d4
Qwat53IaBx9k85MDpGsO21d0QWnGl38AatV7ZIikGzloS4mieBfRzuOIyffoo/c/
61N5KDPzepqW8Yuhh3OYCmbKnExzYymbU6jUq9SVhDjJSsp6/v2kel8oEqcULbNB
IiA0lEOvh0pFy7QY38ykAja9zO0QUJ3XcHMmMv+hP9b3BAjrH3xSZDk5YiFQr+pZ
2VAOmL9lFKXznQnUKlBFtfLcYkoq72/uw+iCTZlAhuABxZ51hlNGFa+e4R1GGp0s
eFSKGDi3UAZAOF/7c++7
=Qnnh
-----END PGP SIGNATURE-----

--=-/FLiKiM/TM3ph+oAh/Mp--

