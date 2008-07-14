Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbYGNMiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 08:38:52 -0400
Subject: Re: [PATCH 2/2] mac80211: make listen_interval be configurable by
	low level driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
References: <1216038684-29725-1-git-send-email-tomas.winkler@intel.com>
	 <1216038684-29725-2-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uEPKL7/UV6McoaNGserI"
Date: Mon, 14 Jul 2008 14:38:47 +0200
Message-Id: <1216039127.11189.15.camel@johannes.berg> (sfid-20080714_143857_086570_AEA692D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uEPKL7/UV6McoaNGserI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-14 at 15:31 +0300, Tomas Winkler wrote:
> This patch makes listen_interval configurable by low level driver.

I'm not sure we we really want that.

With this, you're again putting more features and more decision making
processes with the driver, I would much prefer this to be worked out in
mac80211 so we can do it across all drivers.

If this is a knob that should be adjusted then we want to enable users
to do it, and if it isn't then we can put a value into mac80211 and fix
it. Having drivers make these kinds of decisions is very bad for uniform
wireless behaviour.

johannes

--=-uEPKL7/UV6McoaNGserI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIe0jTAAoJEKVg1VMiehFYMpcQAIijNHzSnR9aFpjggRf5v2IF
bzi1dyzTkcKM9yp3xYrHf9f+6sBQzRl/bjqNx85EEabHnTKlrbnGvLobFN1+Iiw+
7xjyVcQPimmcJ/Dp7ZiOeldlryft5XC2tcLde32LFldLyNYJuUVJXhGZiVkeOZCL
0KCw5d8OfBx6H/5i6Ni9encubN1NB8ThPSd6OcULZoYnfneDj4Q/fHpEw6pJFOKX
giFs8GaQeWP5BU1W5S0BDXW5MR2kO3zvr9oCj5268/3RmQ2bIiDCXH4tii2uK063
+uLhDcSNk4qABBrVOV6uNb/ScIXtbHQux4p1o9yOJlrYHAl1sOqYGf4eQtSEDhMj
a/bB1sEueWkA6xGblcfM2uauXR26aI9HcLIHsmYinTe7cWg8WOVGS9+xO8luGdiz
09VOKWl4XIASwkdEO5Jrgz2oavqkvSlhKZUkBkWwcyqFHpxbOYhhSCuGwELjWY16
K4prZb0t6AbiYh+XWCib4A+35uQKzg4aQIzbybECdxrrBy/kMw8ZjW9LvsH7Cf36
YfrdX6npGoHT4T1n5OwSHtiB7zScTtRdbXihfTyoYOYpyp5UlitpOz9ZwNAjCC9l
Ouei1P9ZYiwSSnkaUa3bj39iUZdNFh1NDxUliXPjj8d89zjgUPnamGS0OLUKA9Py
mzPShdClt0csIi9lCrRC
=s6Od
-----END PGP SIGNATURE-----

--=-uEPKL7/UV6McoaNGserI--

