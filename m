Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbYDPOHW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2008 10:07:22 -0400
Subject: Re: mac80211 hardware encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <200804151717.54920.IvDoorn@gmail.com> (sfid-20080415_161442_807626_6BB3493B)
References: <200804051931.58895.IvDoorn@gmail.com>
	 <200804142307.48550.IvDoorn@gmail.com>
	 <1208255742.3502.5.camel@johannes.berg>
	 <200804151717.54920.IvDoorn@gmail.com>
	 (sfid-20080415_161442_807626_6BB3493B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-z+lex4rEQuYLZTE5umqN"
Date: Wed, 16 Apr 2008 15:57:24 +0200
Message-Id: <1208354244.11676.31.camel@johannes.berg> (sfid-20080416_150727_330132_DA046179)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-z+lex4rEQuYLZTE5umqN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'll create a patch that changes it to the key_conf pointer then,
> that sounds like the safest option to allow changes to key_conf later.

Ok.

> Note that this change (either adding the key_conf pointer or the hw_key_i=
dx to u16)
> will cause ieee80211_tx_control to exceed the 48 bytes. So that will make=
 it
> harder to move it into the skb->cb array later.

Yeah, well, tough luck, unless we can convince netdev to increase cb[]
on 64-bit platforms.

johannes

--=-z+lex4rEQuYLZTE5umqN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASAYFwqVg1VMiehFYAQLFvQ//SBysAzdZ0rGoUmyIdjzSNbzKoiLXcZot
uNEemwnephWj9OoKJd88xRqufZ4xnvfRlDIQ5A3QBM9Y0bN0BgFJ+pEBwXi1jPd4
ICUnpB0UAmnA9g1PTvE/jUR6rFjjlqFSScFhI754Oiyi48bwa7gb3oU8HewpCtxF
e6YYL/NXPthM2qVQoHJ70iFT2JZ4deA9UttG7j05Qcyrmlr7V8IH348GAnxfh3eZ
BFE5cmp6Ic3xBjR3Q2p2O+ZEFX7qXfcJXQw9HWdX8Aq9TxJkB/P93Vh3jJ44IL6A
AK7Snk9L7KvNHSDWzRHOxptiGt/ncOQsx9vpF561Lx/8KnP1vDU0sUrmyCKtCCN0
6iLR1ADn0bspDu8DSWU/3EsyHPQbaTFfa8iYZiRNalk831+5wew4WPPyIIiooFSQ
O4jOKyE1VBXrvuAe61MMkDW3yVJiq+oMiPzzP82l5EKeeJYWNXihIGGqMzS1SAKP
cnsN6O6OSfm6jjfBk6tgXjEcG85wKYcd+/5CCy1XpBiz/uXP7Dv71SWXLSmB2yfX
3iZ5WQi9v+Sknb8Uc8fgFxu70+pw9migsLYzIVpTb7CYYjGlsM4J0Prhy/c9Ks/9
RsSCkz5N8BLQh7nnvmZ416fUyGOxDqW63T1UWjxdbLbZkJe/8Wav9O1OAG85yGVs
Aa/RFwRLxcQ=
=AYJK
-----END PGP SIGNATURE-----

--=-z+lex4rEQuYLZTE5umqN--

