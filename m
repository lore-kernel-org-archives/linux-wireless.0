Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59474 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYLGRoj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 12:44:39 -0500
Subject: Re: [RFT] mac80211: fix HT channel selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Mats Johannesson <spamcan1@abrasax.se>,
	Tomas Winkler <tomasw@gmail.com>, Jouni.Malinen@Atheros.com
In-Reply-To: <18747.65000.953959.335010@localhost.localdomain> (sfid-20081207_174848_905245_0B2F84FD)
References: <1228667447.22164.46.camel@johannes.berg>
	 <18747.65000.953959.335010@localhost.localdomain>
	 (sfid-20081207_174848_905245_0B2F84FD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RVJLiHB/Om/POJzJDQsF"
Date: Sun, 07 Dec 2008 18:44:36 +0100
Message-Id: <1228671876.22164.53.camel@johannes.berg> (sfid-20081207_184444_806853_EC4B6D24)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-RVJLiHB/Om/POJzJDQsF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-07 at 22:16 +0530, Sujith wrote:

> The check for AP mode should be removed.

Good point.

>  The patch below applies on top of your
> patch and should handle the new changes properly.

Yeah, looks appropriate. Since you probably can never change channel w/o
changing HT, we could probably remove _CHANGED_HT completely.

> But I'll test it tomorrow by switching like crazy among ht20/ht40/legacy,
> in both STA and AP mode. :)

I won't really have the possibility (nor time) to test it at all, if it
works (or you can fix it) feel free to just send it to John with those
fixes below rolled in.

johannes

--=-RVJLiHB/Om/POJzJDQsF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPAt/AAoJEKVg1VMiehFY4csP/A7gvxf6IWUDRMz35lYNr+y9
K80IAz1eClUg8mNEpiJQ06aQLXwCy1HgaCAESi3Dfg00b0z/kR730dIJIeEkFEBC
GxHlabKFHgcRnOSg4Ec9AgcSwqu77ZwliJTXX1b8KAG8tJ4Al4+pW7TYB+8NX2Sk
JIVpczG+xg95IzaZs6ozb5Ew75FoK1AphyZ9MZFHOwfcaN900QJUd2nIQoxeAsyI
KXnz6ekO6pi30j3TSDGV6Cdyqdosm1cban8u2T9VkAM1iI6dwvzx8LPapfIePRtw
F+8uKbN0EYTWu5uip+Z/dvTU81+hRQ6z2cvw7KVlt6n2IeKbYbc9+oRLyqXhQLN9
5ZURNXrthy+xVahII5UKKAzBN5hq8mPbPCLMYugQyBb22FP5iMpfjJGh2SNljqOS
+p3CQGhMnFKwYInb5XAicjUABeWJGKafhprI4NVs3cJqYOjd9oJbYVgghZHKTKvJ
GAPXAz/+0bx0hcZ+RemAFf21S4KLDbhQu/64Y6+Squi0N/4mYFl1mOUWEibDu6qD
Id+mxJMPhAy/wzUAR08yLHgT3S7Tw6PlmwaztdbNZV9ApHgbDPlA3fYMHZtr7RLp
KlRAhySA2A49XTSaODNmRGP4GGmwzzd9g7WWBxJsyNenEc7OzsmcsOCUo125FAvt
3P4zHb54U4jz8JKfS5KW
=eC+v
-----END PGP SIGNATURE-----

--=-RVJLiHB/Om/POJzJDQsF--

