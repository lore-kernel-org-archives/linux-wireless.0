Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab0AWM7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 07:59:43 -0500
Subject: Re: Starting hostapd causes kernel panic
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Markus Baier <markus_baier@web.de>, linux-wireless@vger.kernel.org,
	kalle.valo@iki.fi
In-Reply-To: <1264197963.9056.0.camel@mj>
References: <loom.20100122T205326-794@post.gmane.org>
	 <1264193623.2593.17.camel@johannes.local> <1264196526.3040.3.camel@mj>
	 <3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>
	 <1264197963.9056.0.camel@mj>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f/Ai4cD4+2TACbGfIcCA"
Date: Sat, 23 Jan 2010 13:59:36 +0100
Message-ID: <1264251576.2593.30.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-f/Ai4cD4+2TACbGfIcCA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-01-22 at 17:06 -0500, Pavel Roskin wrote:
> On Fri, 2010-01-22 at 22:53 +0100, Johannes Berg wrote:
> > > I assume it's another case where tx->key should be checked for being
> > > NULL.  In fact, it's set to NULL on the preceding line!
> >=20
> > or an else inserted.
>=20
> Whatever you prefer.  Either way, the panic is fixed now!

Great, and sorry about that! I'll send a patch to insert the else too.

johannes

--=-f/Ai4cD4+2TACbGfIcCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLWvK1AAoJEODzc/N7+QmauVcP/3OHHcuiPY7qA2lmgdayqGbH
m/trmHsPmVS5/0XFxTr5qyWrdJjzzH9buJuf/v4X7TrUZLsk9zww8dUyhBEwgrCE
WPR6x//rXhVUmakdHcgOCe4r3cv4bRzOkcnpWAWAiCIYevT2f/FrLBmue/cJE2Oi
c/C4GljRIziz3VkfPDmKUyIFhhBHnyKkb3RUI7BImNM7v16a0ieyWcDWIedlgQn/
XmzVDKv0hYQRhO/8fvU0RnASnVppdJm8Gh3KqIFszXOUc+yDqOTlGY3cWrcynHZ8
UJzjxffGjz7LMKTPBJn5Upp8ZtBmg4fqANzArjRTHz75qT9lR3vc40GNObKuNd9w
4k+8TJHctzpU0QRoQfDdkvXqgMDL/keN7x+RSaFZB0ymPLMvrg5W+ThjtrbSk951
MJMAJaMNxm1VqDIjQyEhPZCfxkbDSQN/NkmCBkPQ+LAfbVpggVg0jk15nQrz6jbr
R6h7Dfpbrphp5SyuB0qRMWf6AAFg5DYj1hEh4eFF/YjzMKvIaYsnwBI1IgZRozor
odAroDx0T9LAYN+XaMjywZFTlJLI34hnFGo7+Rd/H3C47oJV8PDCQhmprEITO2Qy
+0R/S1zQNLjAileklGAm4npEQ8aX80Scx5xhqjoEzyk0irQBu6ROz93b6sBbgOci
YWBPcHk6DRVN1O7eicOq
=rxan
-----END PGP SIGNATURE-----

--=-f/Ai4cD4+2TACbGfIcCA--

