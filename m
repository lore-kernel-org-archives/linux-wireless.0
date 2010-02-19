Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38950 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822Ab0BSSlO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 13:41:14 -0500
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
 definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c911002191033ye37355dm2b091b0c4ae83933@mail.gmail.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	 <1266591292.15178.1.camel@jlt3.sipsolutions.net>
	 <4B7EB31D.2000603@lwfinger.net>
	 <1266596602.15178.2.camel@jlt3.sipsolutions.net>
	 <4B7EBF0A.1060907@lwfinger.net>
	 <1266598974.3754.0.camel@jlt3.sipsolutions.net>
	 <69e28c911002190906n647d1a25o5f7268c585fa05c8@mail.gmail.com>
	 <1266599361.3754.2.camel@jlt3.sipsolutions.net>
	 <69e28c911002191021w1a1d9656oa762724e398da212@mail.gmail.com>
	 <1266603853.29775.1.camel@jlt3.sipsolutions.net>
	 <69e28c911002191033ye37355dm2b091b0c4ae83933@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-peV/KFNLOb5K48xHzqMg"
Date: Fri, 19 Feb 2010 19:41:10 +0100
Message-ID: <1266604870.30470.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-peV/KFNLOb5K48xHzqMg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-02-19 at 19:33 +0100, G=C3=A1bor Stefanik wrote:

> > IMHO a manufacturer would have to be immensely stupid to build an
> N-PHY
> > design based (!) chip that doesn't at least support MCS rates 0
> through
> > 7, i.e. 1x1 11n operation.
>=20
> Well, check Atheros and Ralink for an example. Usually, such chips
> aren't "built" on purpose, rather, they have 802.11n support disabled
> due to having been found defective (but usable in 802.11g mode) during
> manufacturing.

That ... doesn't really make sense either. But we can leave it at that,
I don't care much :)

johannes

--=-peV/KFNLOb5K48xHzqMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLfttDAAoJEODzc/N7+Qmatc8QALM1OA/XZ+9BJQwe2PHBsP2+
139gRtfT8v6LGmtmbllcqDoFJ0wLeuaeToql+7QjGOSzAP8+7uZRxQu6j+qldxci
24L9hBp78XlLVQkC9g4qMiOFqr600ZBOr8FGWvCaWEMkjsuNGjCvcohQhN/wwE6G
YVdHKQhptIwvZDQ4ZYMV914m5WS7FiG/p9DU7pUY+FYZVwziTBThi+Jq2IuPsL8D
MunzvVBe/aP80fOCbqiVfHrKBJi1ohh4McYUGGcKRsS16+VIbsSbZ0mKGGelHWVO
HNdDu2A7fZ0f4kFVhhj2h0HdefAH85JloogNJ2c/NpHcuEYrWnKeu87U+yzxRymG
CJVotub7yvuqwfrU6Copor7nQ5ywOScaC+MuXQntF6KNduEZgrzaguSaeeMwTaNi
WL5v4MCk8xeGTDy5TpXuP0ulH3ObMfaoEYeVYw9GA6M7NhtmYNU7W+rvzcTcSr2y
iuF7dtHLqi+M1UrpgHVl8poTj+dImgKkLJF01vahQUeH9g8UYbgz7iZqvm6flkVY
cJ7iC3gtvRoUF2URaySknNHAhQgKbMegp7f5X1bGqBDnvSK5zaRjl0o5VB+cx/5f
lrVPoDJmCIhoySEht0l1L5UWMJL3+yPyxkxYEIs6UpoyySzxjafVgXUglQS9mYv4
rOoigWemBt7wkmKNHjrZ
=8U2K
-----END PGP SIGNATURE-----

--=-peV/KFNLOb5K48xHzqMg--

