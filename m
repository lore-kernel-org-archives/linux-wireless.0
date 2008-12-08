Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbYLHTv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 14:51:27 -0500
Subject: Re: Monitor number of packages sent and ACK'ed by AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200812081932.40499.IvDoorn@gmail.com> (sfid-20081208_193244_484980_62238B59)
References: <0161CC9B2A3341A19CED21A365A90FE4@gotws1589>
	 <200812081932.40499.IvDoorn@gmail.com>
	 (sfid-20081208_193244_484980_62238B59)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5MynfAUYkx+C/bqy7P9h"
Date: Mon, 08 Dec 2008 20:50:56 +0100
Message-Id: <1228765856.22164.114.camel@johannes.berg> (sfid-20081208_205131_231811_98487455)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5MynfAUYkx+C/bqy7P9h
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-08 at 19:32 +0100, Ivo van Doorn wrote:

> Right, because mac80211 doesn't send the control filter to the driver by =
default,
> it does when using monitor mode. (Not sure if it also does this when havi=
ng
> a secondary virtual interface running in monitor mode, but for full-monit=
or
> mode it does).

It does, depending on the flags you set with iw.

johannes

--=-5MynfAUYkx+C/bqy7P9h
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPXqcAAoJEKVg1VMiehFYdhsP/REb7bC3ugUDqPmfQSGq5f5N
VwZBkhJzGgy5EMk5y04N4upfXHFI16rdJM3z3xRCJQwXehi6HYFA1/45uMBNGdO9
Kn5zw+KAIxEUtP3YCsmKtzEawsoGS7a6DbAQdS5+SU53XvHhFZEiDiserElxFsBm
Sj4m4IEHkYwxXVnXieCtbr2oxR5hw0D+t23UliCimJ474VQwabCnVOy7CJJO4o4E
NGJnJeYvHYSM9RdVxdZR/onijPXWMaBNySL63LN+J/wdGTEeKB0CASH508/a+lcI
/w9wjsGZSwS6neFgH3K+y3a9DWwVyphrrkT9uzGFAfvgcUA/woKGzk3LvDNN7Xxz
gpM+QNhB+PMwa6Vmce7QHX9tqhfAyGipg47tpkrHZqfuXcQCwGOKexXpaxpS748J
e95XSPwx3YtfQlro5mnjCvA1JGxdV0BhK7xnn6Vcic4PUGNI1VE4z/fYGfSE8zZv
JSVaK0a570bExmvSFbMoj2VFeB/0tecUBm8pcPQZLEW4RkdhlOYenZCLwl5d3SSF
LflAVlxs5mL2jD5X2KW5fx5JEOauhm7DPjkm1B1oeef2pbI7b4l+IYSAAiLZdjyh
jtKkbLQ35/W6oA4rYQ2W10b69IoLsHH1C8UO0rJbPBk3JcJ0vkNEoYnnGTSjMfK+
2JKqDUuW6C8YyMiEdT6/
=XgPH
-----END PGP SIGNATURE-----

--=-5MynfAUYkx+C/bqy7P9h--

