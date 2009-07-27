Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41457 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZG0TJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 15:09:18 -0400
Subject: Re: [PATCH v2] mac80211: redefine usage of the mac80211 workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1248721179-16079-1-git-send-email-lrodriguez@atheros.com>
References: <1248721179-16079-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HI153z6DzS/1WdDoz72N"
Date: Mon, 27 Jul 2009 21:08:44 +0200
Message-Id: <1248721724.32365.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HI153z6DzS/1WdDoz72N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 11:59 -0700, Luis R. Rodriguez wrote:

> +EXPORT_SYMBOL_GPL(ieee80211_queue_work);

Do we really want to allow these as _GPL only? Most things are not _GPL
but usable by anyone, which of course isn't too useful since mac80211
changes all the time :)

johannes

--=-HI153z6DzS/1WdDoz72N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbfs5AAoJEODzc/N7+Qma2gcQANGwxtrf7oEtSNryBox0AzRo
75d66lrvJ4Mp7vM6oV1901kMlqcSevFIqnv4A3tXB2tI7PeSfHmmxJy5IUIkxi+Q
QK89I/ldGfAqeKCHOsLJGO2/JgRrb92Ll7xknhlnDWXDukdiIkN1d6mgoKPHSrqj
BZ0QggmDPvwRZKcdJWAmZFj03B5LXlvGGD7zYakJZrRxsuPbWiqe54Cm0nyFuO3H
wijAxtq+RDzH/4IrJgfzonRsBqNXO9ULYwNKFHSNVZ0CVlxlPkVjg2edQnVmFNTG
ZEXh6uD7qqywDiBdgfKS7A4585+U+i6yFv9aRDfDgNKhCa329WwexmTl2xPHpVMQ
UhCZ749Wt1gEfIe3007vz4S8vMK6MRS5QCrXu6FLZW7C6XYLYb7zqYEv1QiXNVk6
vmbhQos9U2FOi3EA0PRyvfzRSKD+9cQjG7PpMGt4XLmZV5OiuGx3IUfBqoDRnn+x
rn3rL00+pBXWsPZyTvCIOsEJtGiMxbEPPVQzrOE6VDCRjMtbq7HOCOxdShAN+1/d
OpCvpIc0eVjWcVnoYz6YLD1r/YwBT2+lxbOAZeY02eIJMvdlNoPLXT9RlGy9jwWk
oZMx1XM+KejhGA6oKb2ZduwNAA8RCnGYmmQBY6rGExQ6apXZKLoNUQhmu7qEAqR2
fr61fGbmIm2UYupy1YCQ
=yQKf
-----END PGP SIGNATURE-----

--=-HI153z6DzS/1WdDoz72N--

