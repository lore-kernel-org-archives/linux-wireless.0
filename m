Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZCHTDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Mar 2009 15:03:08 -0400
Subject: Re: [PATCH] mac80211: Fix WMM ACM parsing and AC downgrade
	operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090308175914.GA18800@jm.kir.nu>
References: <20090305152346.GA30029@jm.kir.nu>
	 <1236515287.4205.11.camel@johannes.local>
	 <20090308141703.GA10782@jm.kir.nu>
	 <1236522333.4205.37.camel@johannes.local>
	 <20090308175914.GA18800@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-v84LPxhdMcVECjR9GIOb"
Date: Sun, 08 Mar 2009 20:02:59 +0100
Message-Id: <1236538979.4205.63.camel@johannes.local> (sfid-20090308_200313_943887_2D164260)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-v84LPxhdMcVECjR9GIOb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-03-08 at 19:59 +0200, Jouni Malinen wrote:

> > Sorry, I meant correct. Why is it not correct? wme_downgrade_ac doesn't
> > modify the skb when it returns an error.
>=20
> Ah, okay, that's a more sensible comment and I can even try to provide a
> more useful reply after having understood your point ;-).=20

[snip]

Ok, yes, that makes a lot more sense now that I see your comments and
the code, and your fix does seem correct to me now after having
understood it :)

johannes

--=-v84LPxhdMcVECjR9GIOb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtBZgAAoJEKVg1VMiehFYaMcQAJt7GrXnvWn9gAeKEMXxpEmx
LGDBCbmwaTYazNzwMeb+19Vb6/uEUGpbM71Obxt5ni/kssaVQTKuO+FzUQXSyWiT
5SrwPQ7isQ79iP2eNgRZF5e/MYVmbcoXlM8Wm8iAd9T39VIT07C3cAe+ijJLhOiX
mWfRdViTE21IsoYBbRb3GCkNsS0pj3XHd2z8Ns21PkzBnj8PPFeSiNeIfS8LexSk
pRpu1wf9HnvrWi3up18SmCzUTk4cqy5ZyymT9Osp77FXRp5YPFWkzhDJaV2pigyd
jkbCw34dh6pcaNf/v53qxgrKlFikNKrtAA8NOHe9YzyqlWGkHvMNByj00sJEyhRC
IQD4f1HpoADtdVc46mqwZfgBynQwepZzj5bd2Zt/RtomO4c57tUwt8+EErCfG+oP
r/WpZxad1ZBYNJGPR7hOcA7Au1m8LPXMkFynjJ3Rid2UkWL+bBTMikSYnzOXY919
u1ha5iD4Aus9Bqg8XvijZ8Av/UicWglL5FBuK615wv4K5ACHvgUylyo2KnZP7ESE
IHNQxrKM+4fMApUzDUbRn1L8XniIot86CjQkqOkqQTm+Z9KrTqV4R01ePojP6P2m
SsBiwcD1wsNv73bx3c4gCXj6PzCpPiIsGks9tJsIdAVlD7H90fb5LPnktu/ZeGIW
Dt9TgL4LFjT7YRhvTGtp
=Z9de
-----END PGP SIGNATURE-----

--=-v84LPxhdMcVECjR9GIOb--

