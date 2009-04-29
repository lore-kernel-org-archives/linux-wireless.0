Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56512 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbZD2Q3T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 12:29:19 -0400
Subject: Re: [PATCH] mac80211: tell driver when idle
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1241022006.4104.6.camel@localhost.localdomain>
References: <1240997537.593.35.camel@johannes.local>
	 <1241015587.997.76.camel@localhost.localdomain>
	 <1241015999.593.62.camel@johannes.local>
	 <1241018085.4104.4.camel@localhost.localdomain>
	 <1241021479.22715.6.camel@johannes.local>
	 <1241022006.4104.6.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-laXEHfJX4MEahbyYza7T"
Date: Wed, 29 Apr 2009 18:28:47 +0200
Message-Id: <1241022527.22715.7.camel@johannes.local> (sfid-20090429_182924_110135_0FB7B5B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-laXEHfJX4MEahbyYza7T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Marcel,


> > Being idle between auth and assoc probably is a special case, yeah. So
> > far iwlwifi has handled it just fine for me though, so I'm inclined to
> > not worry about it too much. Well, with the race fix...
>=20
> I am all for just trying and then actually see if hardware falls over,
> because we are too aggressive. However you asked about it in the first
> place, and got my comment ;)

Well, yes, thank you for that, I just didn't understand your comment
properly, I think :)

johannes

--=-laXEHfJX4MEahbyYza7T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+IA9AAoJEKVg1VMiehFYotgP/3pj0qcByJ3oZ0225w0UGx5o
wIWZnz1Rov/Dh9ZnxqYMCugYpO+J4RP8xalTy1XnrhZs1k+Bmoi4FPVTsSmnmdpw
fXuaZ+GdJ/AyJsGPtneMDpyWzVO6Rep9pJnnHc4lRh9cC5GGzAu9Gv737FotHk4G
tDBVG2KyskhDqnNwzwC1xS8XmgTpMI/mUbr5EVFdyugq1o+bSKK6p3evE8lwufpy
5tX/YkgfVqMT+BRC152QhMz1tjA1HXW7mLUGiSRz/4GPfRMllXNkRuFAzgtl0fu8
DzveYuepqQnSwuu/KooyqmEnRgk8sTC69g1Rs7IznpJ7Mme1pt8BvL3XKOI1Dgdm
biMHb+BbSKvmdl7+BQu6cAGvmcJmulXQ9LXVTAuyBKzRzhFyQ6UvsKZFc/it/sTG
rVxm9axafZccoB5lEBZcE/yvMnRnIveUP5IonFY4aLoyhR0uISevTl1PqwDgfjI7
AYqHnTOG/uLxiUymTq/gHMHFyay6cQ6Ww/877TO4i+AD458oaXkx+1idUYsG7VLO
U8+Cpf+UPUHQjGPb1xiDibByFj52CiExg7worvl+sc7TIm79xZUbqJbbPMckqyBM
+stZNhE5nSMUyoFHVSSNJroJ1ePYvAcoBdds/S+lisKpeLC740r5tHLCyX8DJwsb
1/tK8lxp7QQuqae6rVVa
=izp8
-----END PGP SIGNATURE-----

--=-laXEHfJX4MEahbyYza7T--

