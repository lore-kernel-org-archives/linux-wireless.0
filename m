Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53717 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130AbZCaMQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 08:16:49 -0400
Subject: Re: [RFC/RFT v2] rfkill: rewrite
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Inaky Perez-Gonzalez <inaky@linux.intel.com>,
	Dirk Opfer <Dirk@Opfer-Online.de>, toshiba_acpi@memebeam.org,
	Matthew Garrett <mjg@redhat.com>
In-Reply-To: <1238451390.5970.59.camel@johannes.local> (sfid-20090331_001720_897384_DD6E5216)
References: <1238349195.24972.5.camel@johannes.local>
	 (sfid-20090329_195345_745378_2F2074B3)  <1238451390.5970.59.camel@johannes.local>
	 (sfid-20090331_001720_897384_DD6E5216)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9xip8XruVCAEKJhTQCuM"
Date: Tue, 31 Mar 2009 14:16:13 +0200
Message-Id: <1238501773.5970.90.camel@johannes.local> (sfid-20090331_141652_651028_28CD2677)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9xip8XruVCAEKJhTQCuM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-31 at 00:16 +0200, Johannes Berg wrote:
> This patch completely rewrites the rfkill core to address
> the following deficiencies:

[snip]

This one has a few stupid locking bugs, will send an updated version
later today, for now at the well-known URL.

johannes

--=-9xip8XruVCAEKJhTQCuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ0gmKAAoJEKVg1VMiehFYzcYQAIZhTw0wvdi5Z9jveADRU1B+
YSqezUfrVgFlh6NDTMal8XZ6FiygdhEFU0j2PSMkvy996ZifKagRRe+Z5PgV4QY1
L6dKGXK07cQRGPYeqHff6xPOJOOFegmh1aQey7XkWPn62g1qNrRyEVQoUVbj1y1Q
AiMtNFm1fzaFj/9rDaayayYpKcuwZEJPLwyGArGuoRvZWoOQ74h1GHX2zOpHRSSe
bJfKeLgQRiS4ZVnPa0M8UpJ2QJYHO8Ltdhn4I/h5JTWUxXE94p+qWzahcPEypx/D
08ZQQLbTVcSQNqY527INbcC67mbMjJhTc7Y7pHiK5OQ/fge7gE6g1hkfOrnmaIO3
wXTayViYFZIMSX/M7zzhO7TKSrxQbiwzF7irmxsxpq/ugt+lNAwDIcsNLeCcz/AQ
ipU5JEXE6M8ruSQvQ14DpXdCvVhQMNDVAzBIBep719/jjrfmrl8GKE9z/1lC3Q21
4H2UscdKy5IeA+eP3IISmXdHKNSxZWeffrbUZaLXNIoTAx9VnbZCoqsgUfg4cl3v
kfw9xZAfiuug4D52LG/96bLzFPvfxUWzf2zk/4B+AUHn6RhqOzXoQjNM6JwV6hRW
yfYEut8N+uEytR0WNdLMKvLY+/7PQDMfNJMmNgea8DPizjcbVlnjyFaDXiHPGNNB
zEwNlq+pZfmf6qyeU0g6
=Gq/H
-----END PGP SIGNATURE-----

--=-9xip8XruVCAEKJhTQCuM--

