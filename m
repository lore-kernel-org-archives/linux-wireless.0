Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44404 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748Ab0BEJjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 04:39:13 -0500
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Z3UiY6OfLwn6DBXEk6G4"
Date: Fri, 05 Feb 2010 10:39:08 +0100
Message-ID: <1265362748.3613.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Z3UiY6OfLwn6DBXEk6G4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-04 at 23:00 -0200, Thadeu Lima de Souza Cascardo wrote:
> When trying to use the NEW_STATION command, it fails with -EINVAL,
> because there's no STA_SUPPORTED_RATES parameter. However, for mesh
> mode, this parameter should be NULL. Besides, it requires
> LISTEN_INTERVAL to be negative. We allow it to be ommited in the STA
> case too, in which it will be -1.
>=20
> ---
>=20
> Hello.
>=20
> I was trying to use iw station set in mesh mode and found out I wanted
> to call NEW_STATION.

Hmm. Can you explain why you want to do that? Mesh usually discovers its
peers, and you can add paths, but peers doesn't make a whole lot of
sense to me?

johannes

--=-Z3UiY6OfLwn6DBXEk6G4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLa+c5AAoJEODzc/N7+QmagOQP/1BIpDmLWkdNTGGiiMc5u4FU
UZiLHbv3OpcofQ3CdRWiXyHhYsqj3menVkPsQsX7vaUSgbWeWrhFsc6qbqvPC99D
Fkb2bZtQSEmn3tn/GFDgXq07kKAc+wB+Mg+vx6iy6ieLDlK+evRplyWwrfdYLvIs
S5zKjwU41Vvm4zIfNNYwLGnvZCtzGYPlFx4xFV5AMyBgwmyboS/uBIaLKsFkTf08
sEerR8hZxoEKzJo/34YvHFvnKrUeQA7UlJ2SE5AAXy9VHfKVXOXsemABnhRZlfnK
gu+0KUEeZ8hm/Juesh8hPFvZJvHuAcG5UAYkYfoTNOvBOmljiIqTsrKUXPDu8DVO
zU+rR1gDIg8QixchqxBOxoJCVsYfVtyJ4ajbsJxmCbak3dlMUNX6CXaE/pHooEhA
IHSJBL0ilR0VBIybRQNtTjgFg6z0d3fHjUS/yG+pfN5eoL7q+m8k0M/ek/eUEMfW
wxwiNIHQ2V2F1BFPRXM1cKC9kqsLR6wh6S5yly1JUN8utoL/a4czBak5XF2YKTbc
EzIq3mn6v0bryasx+epITA4ZGHqQ281ec3ilrN6ARwDDJ9YQjHDv9DpvGqq1y81C
ZV8pv9bEgqBYnPGprrgT5LapNaFU0MpP79FoTEovoLCifHhIYwa4dRdcvVKuhYmC
99x5xHcw6pXhc2HNPakC
=We3F
-----END PGP SIGNATURE-----

--=-Z3UiY6OfLwn6DBXEk6G4--

