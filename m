Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59961 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZHXU7E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 16:59:04 -0400
Subject: Re: driver_nl80211 broken again
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1251144381.9374.4.camel@maxim-laptop>
References: <1251117161.22951.4.camel@maxim-laptop>
	 <1251122885.12007.12.camel@johannes.local>
	 <1251144381.9374.4.camel@maxim-laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-PkYyU8wTIcFogsDYnKPh"
Date: Mon, 24 Aug 2009 22:58:35 +0200
Message-Id: <1251147515.20161.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PkYyU8wTIcFogsDYnKPh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-08-24 at 23:06 +0300, Maxim Levitsky wrote:

> This is typical output of iwconfig, after failure
> (and I know that this output means trouble):

Hmm, thanks for the info and especially the log. Unfortunately, I can't
reproduce this at all.

Can you run wpa_supplicant with timing info (add -t to the command line)
and at the same time run "iw event -t" please?

johannes

--=-PkYyU8wTIcFogsDYnKPh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKkv73AAoJEODzc/N7+QmanWEQAJu96N8eV5JVTwehgC+d64cO
y0u6d7rCLZ3FqTCzgmLtc2muNwYo0uQAjPXFGq8Tp7WnJryU7a+mhzgvJlTR+lDF
twEqi4C/3ukwhg7OnHjcrvgynvJ9vHnC3+0kjXs9aftX2+9M/0DPbZ7ohDEQ1Skw
GfWLJS8ZQJZOr6FrqkzL4ILHMx4n4EJvY0XEv17Z3ilFAa3c1w8dcCJQSsLiZT0I
A3i8naNMEJkUka+7qAUyOCJJBpyFpJUsZEXZwzqVH8rRj3MPCW1Rhe9E5yVDF9gy
Yjfj/V2k9IRts1+dsoxiVGgrzhy8CzMQccC3qSld0CJfx/C3z5k2PECQfjRG51ns
KM+5NWr+6bsFmNOSaeQetUVPqSaeNhvBvLzuIu38FxUw4Kdcvt3aT+GxfPU8jwdM
U2d2aX8H8Gc5vajnk6xssPH8ghR3NCTwwtUn3G3MboZT1CahWvU6ueB9z5ZHjmNQ
JhGDWtAoS0JZwLf1vb7hYJDtYq1hIUxO1E7LfpXWR9su2iJP2/YO+JaeHifn23dx
g6lDIi3OSJXt95T+Sfggvez0+kFJx0HBvJG2S6IbOdzMsaGu5NZSPlK+v9FkbppT
1axeQQta0o0EUC/LTH2mqxgk/GPPS+uS66aQF/KaHWBX6C7I9mmUjxcWuQlzl2qD
iqVlkZqpixvp3g81kANK
=v9Ag
-----END PGP SIGNATURE-----

--=-PkYyU8wTIcFogsDYnKPh--

