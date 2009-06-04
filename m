Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51913 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbZFDQba (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2009 12:31:30 -0400
Subject: Re: [PATCH] rfkill: always init poll delayed work
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4A27F649.9080203@lwfinger.net>
References: <1244015729.7176.28.camel@johannes.local>
	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>
	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>
	 <4A27EF6C.8000208@lwfinger.net> <1244132396.22576.82.camel@johannes.local>
	 <4A27F649.9080203@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-S/KSieVuyl3FVXcm1ShM"
Date: Thu, 04 Jun 2009 18:31:27 +0200
Message-Id: <1244133087.22576.86.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S/KSieVuyl3FVXcm1ShM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-04 at 11:28 -0500, Larry Finger wrote:
> Johannes Berg wrote:
>=20
> > But this is without the patch?! If yes that would confuse me.
>=20
> My bad. That test was with the patch "[RFT 3/3] b43/legacy: port to
> cfg80211 rfkill". Without it, everything works just fine. The LED
> works and the radio follows the switch.
>=20
> Sorry for the noise.

No worries.

> Now that I know the problem is in the patch, it should be easier to debug=
.

Would you do the same test with the uevents w/o the patch? I suspect
that you won't get the event at the right spot.

johannes

--=-S/KSieVuyl3FVXcm1ShM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ/bcAAoJEODzc/N7+QmayAcP/RM0TiwbfYT++ACzWz7x6O/M
Gw6TBeykHJENsHM8iyY/TfI8/5E9XNw7G6SnRezYOTrNXP4i+LP4YBNmLRsuvl+i
TBeUniiNqYmRGQUj+UqCd4jiWCqqBClC+T0DM1raW9SqzzYTV6bA7djzqtSXF/+J
TP8Sayp/umxpiGIu41ayJziPEgt5l2rPS8VNrI59XDyE8abmsNGcHtZgKnCn4Fxq
2yp+pijRa0+fVX+mxX3SdRV8UIEA73uQEQY63ELhS31sL41qF0UOpwbOkixsYPam
7i7e3PKFHQvXJLQA9yZ1XOsTT070wafcSOGbP8E2+WinAwq1ekd2SOKVORbi0Tou
OTGbE1brojiwpA4z8Q5EsFhDk4lPHi0UbDNjKzP7A+tjMZv0y2BxTN5pi4fcOKza
uSZGFf4GRI+12hT9GyWMi47pwYmz4xHH2iupWfIyAQv4kzWF4Rkm32RCtdKZ4pRC
UC109d7Oc6ogTOyulFBQJNKtlIxuv3zDPnQ/B7548bAZTR93p9obn/c8DkxGCIC6
yeIhkxye3/Egq9iibEzGIf0lM/gC74zDAzPKQzrRujv6WWPfheGYQu6C2XFox8Qd
NDcxcZox16EPcQPOgpucW2e2HaOVJzXlHFG6ZLPcVj3keIWrovPvsT3IiBxLJzJ/
KUFIEiFwzxFKPcMmrMtN
=jH+d
-----END PGP SIGNATURE-----

--=-S/KSieVuyl3FVXcm1ShM--

