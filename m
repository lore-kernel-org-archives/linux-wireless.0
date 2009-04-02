Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881AbZDBKD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Apr 2009 06:03:26 -0400
Subject: Re: [PATCH] mac80211: Always send a null data frame if TIM bit is
 set.
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Vivek Natarajan <vivek.natraj@gmail.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <87ocvfiovd.fsf@litku.valot.fi> (sfid-20090402_075231_784877_7FBB0EC4)
References: <20090302145030.GA4660@myhost.users.atheros.com>
	 <8e92b4100903312115l2f013083jf507b66f8449a63a@mail.gmail.com>
	 <87ocvfiovd.fsf@litku.valot.fi> (sfid-20090402_075231_784877_7FBB0EC4)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fGRrC25B8aTPJ7JPfpjT"
Date: Thu, 02 Apr 2009 12:02:51 +0200
Message-Id: <1238666571.4141.14.camel@johannes.local> (sfid-20090402_120330_300060_EA391D4B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fGRrC25B8aTPJ7JPfpjT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-02 at 08:52 +0300, Kalle Valo wrote:

> I really would like to have some frame ack callback to mac80211, even
> not all drivers support that. Otherwise we cannot reliably go to power
> save because the AP might not receive our nullfunc frame. I have to
> think about this and I'll try to propose something later on.

I suppose we could well assume that we do get TX status for those
devices that do support power save -- which devices would that affect?

johannes

--=-fGRrC25B8aTPJ7JPfpjT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ1I1IAAoJEKVg1VMiehFYCRkP/0W/r0XEPkzFDv7Dt37fuVRK
uN0716NwRKXH99PC5WgN2hvZh3rztuLON2E3YVsg8pku5v09bpbSQOrmQ82mVkCC
Saj0588UW+EIiVG0SPNfYz3HjptYPVL5Rlq3KrKuWnF1BRgUUn/W8Tm67OZjs6ML
jRooHQ70d/0iRf6SkRWbRMPbRvT4YpLbMA2KPq82WW01eiAt6oXy/NvpwqD3n0/J
s+7jTOGnA+Gl6p02tlawWNAu7zjw5lIhCVi9OqoG8Eysg86noFBF+995QBfR6xsY
nyoQZT6EhQU/IjMzFEmiqJk17NKcD52F6sbSsZWRMYu9nQhqm+dNRUYDEfF+SI+n
y3GJIOT+v8n0h+g8qFiiotHVclRmB+pYzGHF6Je5rGkolAODlZd2mQDGSsTl6AwH
NemkyFK/gVTVT2b0vdpGw1t6mW1mecq9/qJ3L8iYvjYjto6NnK/TUrISNWm+IgD2
vARGyDw3pIzaRfrMxFnoZEylevHZzxipQJ4a8eq3ebLg3vdQYpk6UpZeHKBTj9PI
RggRCHVZpJOC0VNHanFq7PDBt6vd+ZEGuQslbn26BGfdkOQ6SD7h5MWS/Omt1MmC
b++Isp65KWjangJL+YcmViKqD2oxEAi6EB8+lbtER/rzf4uI4iUImsLc/7q/iOrz
EgL9MnOIo57iEUGyDwep
=LzJd
-----END PGP SIGNATURE-----

--=-fGRrC25B8aTPJ7JPfpjT--

