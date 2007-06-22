Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52280 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbXFVJ74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 05:59:56 -0400
Subject: Re: [PATCH] mac80211: kill antenna select ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200706221132.30211.mb@bu3sch.de>
References: <1182499821.21939.62.camel@johannes.berg>
	 <200706221132.30211.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zjGJYbeCECj+CvEfvVXI"
Date: Fri, 22 Jun 2007 12:01:04 +0200
Message-Id: <1182506464.21939.81.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zjGJYbeCECj+CvEfvVXI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-22 at 11:32 +0200, Michael Buesch wrote:
> On Friday 22 June 2007 10:10:20 Johannes Berg wrote:
> > Not used anywhere.
>=20
> It's used in bcm43xx.
> Though, I'm not sure anybody in userspace actually calls this strange ioc=
tl.

That's what I meant, it's not used in userspace.

johannes

--=-zjGJYbeCECj+CvEfvVXI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGe53g/ETPhpq3jKURAvUKAKCUdTPhUrsbH0lAWNNlK/aZERuVYACZAXmB
1JmyXZWeinckB30xTK1WwoM=
=d8j5
-----END PGP SIGNATURE-----

--=-zjGJYbeCECj+CvEfvVXI--

