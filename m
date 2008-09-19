Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45572 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbYISJAT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 05:00:19 -0400
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890809182257r65da8757g1de0ce4f132bf019@mail.gmail.com> (sfid-20080919_075910_170016_8805CBD1)
References: <877i98iw4h.fsf@nokia.com>
	 <43e72e890809182257r65da8757g1de0ce4f132bf019@mail.gmail.com>
	 (sfid-20080919_075910_170016_8805CBD1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SG0CZ2HwWX6cXXd+Hc92"
Date: Fri, 19 Sep 2008 10:59:38 +0200
Message-Id: <1221814778.10419.23.camel@johannes.berg> (sfid-20080919_110022_667358_A8B6FBCC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SG0CZ2HwWX6cXXd+Hc92
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-18 at 22:57 -0700, Luis R. Rodriguez wrote:

> > After the driver has received some serious cleanup I would like to try
> > to to get it into wireless-testing tree. But I'll send another email
> > later on.
>=20
> Cool! I thought n810 basically used a p54 type chipset over SPI?

Yes, but the firmware (lower MAC) is sufficiently different that it
would be painful to support in p54, afaict.

johannes

--=-SG0CZ2HwWX6cXXd+Hc92
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI02n2AAoJEKVg1VMiehFYWIEP/jsOsU/Acrtja7zOeH3HIvaF
prZZ9AKu/M7vbJug9nudYWhqlGmXAo2ePMIOiziJmGlAEvLnRQ6bcv/Gg4ytsLRo
+T8VTgOKXJACY9R1Rn3gqYg4dUUdBQeDlBCsb7dtU0QovClwr3s9j/zM0T2XDjrf
hg0MUON+f5hQAwDkNMGLLqx/CQ5kIuwgia6gPpAwf1D/3w4q5sysQuZSFCFNpFv4
ZbHy9nFQxTA0wwbA0cCblT2Y88UrwGgPVReuPHFeZa9iBSKGTfvY63V4SEvjRe+u
X49UrSTPwxWq+PlW18jqcj3kjnoIWBiHT2bABceazYknA4b1X7FU06NYaDGF1rPt
n/gNE16gD1VlNqdyzb6jZFSZ8wQtjkmgtpxrvm17Dg/T//QsQvDfZk/W7JNJu5e9
M62DsA2DSyLlo6xC+larNTuJNLSz61btYId2Aa6vWYHY+6ULqcquG2aTI5bTfQvd
8+gpoeBmclg5nFHYiDUEKW9SHHTMVbtRjJ/WjXU6BsWP5rQtM5SqUjz3L0ac9fZb
zVq4n3Xiw5UqGBgUtoJZi7hFqAoZFd4bcZ284xANsY5vvy6o9P6etK1t1W6OOP2q
pZR4Hdm0NG8/8XX5AfZ46nrNxMFAEyONoiORPivrv08QX55YlPEJ7METUZ+7HOo/
P2iRBA5yZP15kBsvE9JE
=r7uA
-----END PGP SIGNATURE-----

--=-SG0CZ2HwWX6cXXd+Hc92--

