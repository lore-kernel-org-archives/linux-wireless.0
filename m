Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966106AbZLHVo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 16:44:57 -0500
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors
 in 	2.6.32
From: Johannes Berg <johannes@sipsolutions.net>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	linux-wireless@vger.kernel.org, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com
In-Reply-To: <4B1EC842.7040407@gmail.com>
References: <20091204233202.GA13658@basil.fritz.box>
	 <4B1BB44E.90706@gmail.com>	 <200912080006.28892.s.L-H@gmx.de>
	 <20091208095755.GT18989@one.firstfloor.org>
	 <14add3d10912080219u17c65cbemf6d56290a8f12efd@mail.gmail.com>
	 <4B1EC842.7040407@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Gg2Wh01t1JGIjDEt6oT0"
Date: Tue, 08 Dec 2009 22:44:29 +0100
Message-ID: <1260308669.32227.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Gg2Wh01t1JGIjDEt6oT0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-12-08 at 22:42 +0100, Gertjan van Wingerde wrote:

> OK. Please try again with the attached patch. Basically it disables going
> to sleep when there are still unacknowledged frames in the TX queues.
> This mirrors the behavior of the Ralink provided drivers.

Kinda looks like you forgot to actually make it go to sleep once the
queues are drained though?

johannes

--=-Gg2Wh01t1JGIjDEt6oT0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLHsi6AAoJEODzc/N7+QmaO2EP/1laQZHz4wHgRha9Kgyze+vj
4gyUgPLSOdvSWge9ZqRbi8CVicQtPkaYks/3wqQJr7VvwiOOcfY4BK0kb65wrDbC
+3WkX5ewYGRM3z/KBtFXiU3DpvYl8QIvNwKdVn/m+m93/X/JPuRKqqrt1QDdotoi
bfIYTqkw6euKE/xfGd9x07Ph2+54zEsuVlLaLm/7TRnWZ/9zf7h93luNj7WE8/+F
oSp9kSuftUZWT+GU8LRqO3EnKF2y8pyA89j9Tju2fnSUnm//tU7ZMGAZT0P0h2Ew
2IanuNJzV2feVjezYZgeEXveNepHSiniX10FD9fI76BbaWMyw4zjdGXIfpYHpPq/
dq2lk+yPQvq3JliWupDbcZQGNSOCuRNEGBpK2L4HkmZ0Q2zYZZARWwIBHwIvSFfE
KULVaxoFZPtXr8OBVoScxB02Vs0jVq/+RD78SU5ibGlsXRZm3yGjimqCtC3LlNrV
g0HdKAImp+LuvC3uV2cgcnkeCafeKMvAoV5LBpEdbopTb2MaJNiV7vPf/vVFWZoR
2aUtw/I0RHoOOsLFGsziZFi+tzh0kcaMuvfZEWrvlXu2WnBQOWzrgdIXTDtiCe62
v+9utZD2JLctVLIJefydji/M43d7+kTfvzyaMWSdu0V3SfXi3E9AIcl6hu/89u5i
RhejGm9MdWJny/ZcnEAO
=sZXb
-----END PGP SIGNATURE-----

--=-Gg2Wh01t1JGIjDEt6oT0--

