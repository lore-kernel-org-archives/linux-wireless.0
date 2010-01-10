Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab0AJL60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jan 2010 06:58:26 -0500
Subject: Re: kernel panic with b43 and hostap on mips
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B490DF9.10802@hauke-m.de>
References: <4B490DF9.10802@hauke-m.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-SkoAC6IPoBuoo37SZWDl"
Date: Sun, 10 Jan 2010 12:58:21 +0100
Message-ID: <1263124701.7773.4.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SkoAC6IPoBuoo37SZWDl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-10 at 00:15 +0100, Hauke Mehrtens wrote:

> I am using compat-wireless of 2010-01-07 and mac80211: fix netdev=20
> queues, mac80211: fix a few work bugs and mac80211: fix endian error
> by Johannes.

> ra    : 80198884 dev_queue_xmit+0x1b8/0x418

Could be the bug Lennert also found?

johannes

--=-SkoAC6IPoBuoo37SZWDl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLScDZAAoJEODzc/N7+QmaJbsQALMMvjRomUv+Ssbh7Gl0nDKR
DrKV/6QVf86n1Rw8f8YmKQfQ9edEIfMcCgj5M49pxaSXRc88+NAOWr5wVpCIx749
92nqk+jlIvgRXo+8HE7qfQ2U9u5XcAeCD4JjkwFF0IQEmjOvUwttkhtHXOk5OSvs
2/3cy3bROJGA+WgNj12CSm2mpP2DaZhUT0Nf3oWrd6Nc+8t4uXVWyHhZ19p+2b69
qzNiljrsbAcfv5WJ+4oBi/RUKf5EVkL/uctsy2g2A7VDoCG9CQsMTKVAcTXKQMdx
sEIFbw8ndc/ygizaxC+W3PlkKrptSyEaYOuVzonvk5S0W3eBRFkh5vYjcGJ7KmVE
VD5AeDDdiGEIZmi1lGWp7Iw+lBcShuzc0DmXTDf0OgAAe6VIzVflMDvUv15NIbw+
8ZQ1IPIUfSm6mCD5Jgo+/0x5N2v7rJ3gSb7ee8BzQtDmfAgxN65X/iaNICYpoFol
asljHMQltLIuiWbw7I60dpgpI1bz0sxO6/tutqYKRcNTRZbjj+Urd2ZHviGG3q2G
E6H+anwNkXRAMkajvuUB8sz+sjawU9VAHg0HP+ITKvTFD6FCAsMonkCxO69GmtMz
tOyGqE+OHrb2zNP0oFLeyqLDqFm2dtlYqNqSfW2/UAGKeQROz6QBZguhrYIuuREr
ApaVvLLmKpXPua0Vg8yu
=TKPO
-----END PGP SIGNATURE-----

--=-SkoAC6IPoBuoo37SZWDl--

