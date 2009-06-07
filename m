Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56733 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbZFGM22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 08:28:28 -0400
Subject: Re: [PATCH] ath5k: added cfg80211 based rfkill support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
In-Reply-To: <1244374833-11987-1-git-send-email-tobias.doerffel@gmail.com>
References: <1244374833-11987-1-git-send-email-tobias.doerffel@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-hVZFKh8Tgo4LvW2cLvoC"
Date: Sun, 07 Jun 2009 14:28:24 +0200
Message-Id: <1244377705.2907.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hVZFKh8Tgo4LvW2cLvoC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 13:40 +0200, Tobias Doerffel wrote:

> +config ATH5K_RFKILL
> +	bool "Atheros 5xxx rfkill support"
> +	depends on RFKILL
> +	depends on ATH5K
> +	default y
> +	---help---
> +	  Include support for enabling/disabling WiFi via rfkill switch
> +	  with Atheros 5xxx cards

This shouldn't be necessary. All APIs are always present.

johannes

--=-hVZFKh8Tgo4LvW2cLvoC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKK7JlAAoJEODzc/N7+QmaUHQP/2Qy3GGE4YWm138scf0Yo0yg
W6oIuPfn150JNjUmJ3QFnpcHFgbzV9BwpwyjtwWcf9+hKFQpLECnZSoHBQZ/qfTb
8hCEyyB1Nxoc01iFRNGXxbnHTMLZOheYypES8eTM0myZEdfItrUGVgtsPBlYE67G
vIW+vvIg9euyUatSSkAQlntP1C/D7uDF18gmf6qMxq8vZPMEGQdJwkrso3D4+RcJ
PbCK1e96QhHkRCaSIl7D/p79wPJKbyBuLIz3usg8QX5yKDiqGfYkQoK0j+eZao2i
Cxp1yJPKkXXvaVgm1W/2Sjzn54OPdB1sZIuFR7DBjL8ajwtb6VCRA4x1VqJ5XvZn
sil5hNbpBj/xLSVbI0KjEWOqc1x4Oi8vrgsMZpClN2yeCgVHLA3XlFbzrHGmz34A
S6EyEXhKu/nJHUC1OGkLnBQakIBl0zLo4lh7YNuV9KXeuiD5ul0yTKaG1fAUD/jv
aUkAj8LOlYNBOuVJgSgU6JIIEiKlJcZnfbIQ3lQHy4dRJHvcsRlz5Zl/ZMHFGQnj
HMCRy0rH/9oUoPGKCJzXRr6beHQG1V/DTJ7bioKKmzzhqBX9wED87x1FKD1g1srL
TWm8Ti3CerJUWk4dG0oZi0xDS4Vi9tIr+ovUuTKAcSlbSoz1Ub3GYK2+kyuH0Db0
exaBIoPIqwKFnCpboD+r
=H5QT
-----END PGP SIGNATURE-----

--=-hVZFKh8Tgo4LvW2cLvoC--

