Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbXLQRqy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:46:54 -0500
Subject: Re: [patch 7/9] mac80211: Dump rc80211_pid events to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217012550.464889334@gmx.de>> (sfid-20071217_012731_162132_E62DF268)
References: <20071217012517.882216322@gmx.de> >
	  <20071217012550.464889334@gmx.de>> (sfid-20071217_012731_162132_E62DF268)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jjb6VK2QqmTg8Vo75avy"
Date: Mon, 17 Dec 2007 12:57:16 +0100
Message-Id: <1197892636.4885.25.camel@johannes.berg> (sfid-20071217_174704_095556_52A9D4E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jjb6VK2QqmTg8Vo75avy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

=20
> +#ifdef CONFIG_MAC80211_DEBUGFS
> +#include "rc80211_pid_debugfs.h"
> +#endif
> +#include "rc80211_pid.h"

Don't ifdef includes. Also, I think it's overkill to have two header
files for a single rate control algorithm, just use a single combined
one.

johannes

--=-jjb6VK2QqmTg8Vo75avy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2ZkG6Vg1VMiehFYAQIDIw//VCDjqAy7RWJbrTesOyBdJFyoBk8LGCK2
i1AMsP7FUsFgWk/GorJJjf472+CrIlecwOt2J4XGuDfrTBD/yGny0zxPwAgov7rW
J8MaWLiuyV+fWWuwRP2nOimOeB22R5G12E9veKutkYJtvxpwklVXhg75RuOaYMgi
KJYJ/JpVca2vO+KTUzDKAUfyLLCYWzEShfbZvda+h70aHJ7qoVI+bEum2UvCY64k
cdu3bmq1uftuC9Qb2Lly187cUy35hnFILHnaV8HhHRIKp7fF6PNlz+S6CPbtAdgs
Zca2r8Ull2UzJXZgpVgoc+G8E/OtX/OTbYGMBnkzIs1WbJWr+ADa0oQtK4cZ/tw3
+iVX61etE0uunrbARw0ww94Q5bOrVhas4QXoJyWGeqvrib4bxrD2n13gPh544tHh
vD3f5I9CRGAkDqcrnOH1WABhMrj3SrH9KwfCmXNWCE4t2R3KClRP00HOOk2dq26U
g1orHvDWLuyNjEdsOeDLxIdg5TpD3eScMh6CncdI7rVewBqSwYoa8qSzs+vxWMK/
3TIpUpsCKKPS+K3SHDeEQIf+TWkNH9gJhU+6gHmvnijfOESfVHGw1c1r8hc7oFGS
4KgidoAv1vMTWi0ECOh2hq/4G/1NV2RRbmc6LlJFMt3E1BFy/y+g9dmF4y7/Wea4
wD6zuvfEOqA=
=QScs
-----END PGP SIGNATURE-----

--=-jjb6VK2QqmTg8Vo75avy--

