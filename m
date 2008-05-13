Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbYEMIjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 04:39:11 -0400
Subject: Re: [RFT/C 2/7] mac80211: clean up skb reallocation code
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080512.020904.187999229.davem@davemloft.net>
References: <20080510221845.340428000@sipsolutions.net>
	 <20080510221906.261962000@sipsolutions.net>
	 <20080512.020904.187999229.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SB7/XFvzJcr7YsduE74v"
Date: Tue, 13 May 2008 10:39:01 +0200
Message-Id: <1210667941.3646.37.camel@johannes.berg> (sfid-20080513_103915_148345_A7BCE8F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SB7/XFvzJcr7YsduE74v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-05-12 at 02:09 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Sun, 11 May 2008 00:18:47 +0200
>=20
> In patch one, you changed the call site of this new
> ieee80211_skb_resize() to properly use skb_header_cloned().  But
> skb_cloned snuck back into the statistics code in this patch:

Oops, thanks! Seeing that you've applied your patch to change it I'll
have to respin this anyway and will fix it then.

johannes

--=-SB7/XFvzJcr7YsduE74v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASClTpKVg1VMiehFYAQKGrg/+IIvMuvauQnzJA5HONjNtSClUOrs1zUIu
N4XwinW4BnrysIKwwUet+9/KX8PCxZ9DWizI06sLjwM2zPpqfiaMk2UtpoxFv2Lm
p2luEUc0UPLDQwkXx+lItPkPKUjmY9tR5Fq+0aU6RCAgvuXTxl603cbffGN4TE/G
sH7vgbRlSFIj3k6VIBGPNo92lNslQY3m+KCFvQIcEp7+xf3zZyxELGjMqdRYSqvh
2cBYUtGg128fn2tFDatxj1cpdOI3ms3rg9FJw5yGn6DTzTCZHa3NvQi6ctHtC9Ff
DrgxPiBbXF0VipvdEXSe+Icm+8NGE/pkRkdLIm/TaJjptYyyOclyhcWNUUQXTzNN
Ke8RIPOdBJNNLRMYBRKgqPSMysMttrez8xdto38eTYav3WZZOJJkEHUDv0EsE9DC
bfyyvI8rhsWp1h1bFLXAnC6VGfD1Z0aSoXyXZEBX8o+NnfcSmW1h3CXmOSzfS1jN
doYa2sRfgNI9jzJMj0cvvAiOx3BZqfdgBf5dnVklKnPvkoQxWqobTp1jrOaSpXy5
kXpl9vKdMiiZZkBGV1kMJSz+bBW4e11+8XRKO/1eiemryUhstnNwuqgSVe7KlbMT
pd0xc/vBVMj14Hlj8hC31WuCcelhAJj8m4eIbqOqiYkblafTg8taO5OKfxDDH7xc
Zxn0iBQ4hNw=
=7dsb
-----END PGP SIGNATURE-----

--=-SB7/XFvzJcr7YsduE74v--

