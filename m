Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbXLQRq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:46:59 -0500
Subject: Re: [patch 9/9] mac80211: Publish rc80211_pid parameters in debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217012550.634829179@gmx.de>> (sfid-20071217_012738_052213_B631AA79)
References: <20071217012517.882216322@gmx.de> >
	  <20071217012550.634829179@gmx.de>> (sfid-20071217_012738_052213_B631AA79)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Az2uBUrj7+AsVM7iG/YL"
Date: Mon, 17 Dec 2007 13:02:36 +0100
Message-Id: <1197892956.4885.28.camel@johannes.berg> (sfid-20071217_174706_855471_C2E1E0AF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Az2uBUrj7+AsVM7iG/YL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	period =3D (HZ / 1000) * pinfo->sampling_period;

That isn't going to work correctly with HZ < 1000 because the
parenthesised expression is going to be zero.

johannes

--=-Az2uBUrj7+AsVM7iG/YL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ZlWqVg1VMiehFYAQIwMRAAgKhnBbDazsEGw+mXs/rLxz4X/cwP0w8k
expigkYM1hhgRJMHMWzjv+w+kRJyFjE9eUqLqTCJkNcZCrVakG79BKv+fe+FDbVW
tvG7OJ085RuGw6BcniMjMRhslK+xLxIiI4jj1xEq9rgv3nrsgIuQiZdGqNKTLkTq
CxnBLLC+t9gFnJN8VHShQf/mfnS2fOol0AorrO5b42msUPsgecuUT7Zn5SqjO5Ca
31mzCRuAO6om1thblFBcaIhrC7hB3O0t3kqwA3iWxHXy6/Ocn91hXwOK9L7pd8wR
6MCnlyQhDcxZGDBQR3omEgASu8gZp+50YzB/PGgRpvJfElxYDhdcIudoEE8fa8AY
yNy6GGde9VrafmXiHJpwxi8P0VozHJM796VKjH/uUiY5hf9Zy0D4eb+3o7C0sOQ3
1Y9MlQ6u3KSd5bCYRIGOPrjHsR/1Dc8XvPohTwveZM80TqQfVW8RphKK4XETid3K
gjQdZzoc9CYeCSq5o9onu6lwpZTzFHGOAj0aHSZjAqYVzkKtDYKrI9iXp7miXpN6
8Y9ItaWI5zM9NotG3OYI3XNcChBRUzvK3muJVSWjOCg07uAOfQdeVWVI8dSIa8UL
B6o67IR+3ky7Kr/mb6DgWBsOeEjQOqfuOb+l1mPvljy87tsDHtQjfotERiIBucvt
mzCqqDSRjys=
=76uC
-----END PGP SIGNATURE-----

--=-Az2uBUrj7+AsVM7iG/YL--

