Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZELTVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 15:21:09 -0400
Subject: Re: [PATCH] cfg80211: fix a couple of bugs with key ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	dcbw <dcbw@redhat.com>
In-Reply-To: <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
References: <1242125077.4331.0.camel@johannes.local>
	 <3ace41890905121205v76d6b61cg94d0bbe55c04da7e@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fNXqpvibO9kFPdKlqwi5"
Date: Tue, 12 May 2009 21:20:37 +0200
Message-Id: <1242156037.14227.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fNXqpvibO9kFPdKlqwi5
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-12 at 20:05 +0100, Hin-Tak Leung wrote:

> I tried this, NM/wpa_suplicany still doesn't work, but if I shut those
> down and do it the old fashioned iwconfig way, I can get
> connectivity...=20

That's odd. Are you getting "connectivity" with a WEP network then?

>  the last chunk looks a bit funny - '(idx < 4 || idx >
> 5)' is just '(idx !=3D 4)' so why it isn't written simplier as such?
> also the idx < 0 maybe <1 ?

No? <4 || >5 is anything but 4 and 5. And idx<0 certainly is correct too
there.

johannes

--=-fNXqpvibO9kFPdKlqwi5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKCcwBAAoJEODzc/N7+QmaRLQP/jf1qPIRtVeKoYrrMHtMTOiJ
1HLQZ6PXpKuCXk23p/BCS1gqkg6ZnVvUTy2b+BAwyvhGWsN/GrO1JgMCF8H50zCj
D3X9XWly3XCMRZfo/wpVykuhrBXV2+kof1xJdTtC3t7//TfvTHTDIO+xICmSHN8b
3X/1fX8oxlB2S+FsjCr9EgPNM190tkLWhFpd52fo/2w0EO2J1m/wZks9Cd5zGeZq
J487BaWeFODzHSDe5RVDYueCT3UV48YCxM4Yu/sy8exxBbgsoDg7iZkc5c3iKJS3
54AP3fKm6TzvqqiX9ZFnA+/HoQgmNf8R68fYQHwVhLBFU4wuIzU/McPKj6zGSaN1
RirV4iPKaVRX96ZdhzCwmqmPLg1kEoWTR6HYlU6ZgXPcHqwR6RGgs6K4ezuBLxnK
RU4fYQXkuUlG8cVlvryKwEhP7Y5T2ZqhyWHs+kT3aKaAdjwLtXAVPmeumDiIFo59
UA9HakHvdMDYPRDq6mkNo56AUM4taefa0GYG8BgM50Oim4JEXapU26PdVwsxvUng
UBcQrCvNF4xumpcqL30JmnRH+FaeFAJKnuoEov/jINGkUPsgIJ9klrOu3S9vhJSa
pjK2gDFYMioZi8xj5U3+Q24tyj14NYmLQv/svwo1kuysbpgTeM1zVaj++W7eE6Ty
bj0/ZXQaJv/Dz/OxWmGq
=Etri
-----END PGP SIGNATURE-----

--=-fNXqpvibO9kFPdKlqwi5--

