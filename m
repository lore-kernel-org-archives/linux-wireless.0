Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbXI2Ls3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Sep 2007 07:48:29 -0400
Subject: Re: Kernelspace --> Userspace MLME move and related items
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
References: <43e72e890709281725n6a8ffe0bq487f32796a7e1cf2@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TOiAONaRRvwpu+b9RFo2"
Date: Sat, 29 Sep 2007 13:49:41 +0200
Message-Id: <1191066581.22960.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TOiAONaRRvwpu+b9RFo2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-28 at 20:25 -0400, Luis R. Rodriguez wrote:

> What really puzzles me right now is the communication path between
> userspace and the userspace MLME, and even if this communication
> should exist. I've edited some draft stuff about this and
> communication paths. I'd like to ask those of you working on this to
> please help fix and update it.
>=20
> For now I've stashed here:
>=20
> http://linuxwireless.org/en/developers/todo_list#userspacemlme

Ok I looked at this and wasn't really happy with your terminology and
the diagrams, fixed that up. As for userspace tools (nm, iw) -> umlme
communication I've included three alternatives. I personally very much
favour alternative one, will detail that in a separate mail.

> Other items which we should consider:
>=20
> * Should umlme be optional or is this desired mandatory down the road?

It'll be mandatory for anything that we don't currently do in the
kernel, which will probably include
 * 802.11r (fast roaming)
 * 802.11s (mesh networking) (not entirely sure what management stuff
   this includes)
 * 802.11w (encrypted management)
 * DLS features of 802.11e
 * ... more I'm not thinking of right now

> * How long should we wait to swich to a umlme?

Not at all as soon as we can?

johannes

--=-TOiAONaRRvwpu+b9RFo2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARv471KVg1VMiehFYAQLg1g/9EmID8mXTii7x4U2My7/31L6bujWmqHzv
Pw5K0mfqTAI8VhZJaV4975RzYJY+q8NAtXKT724GXDRHdwE9p0e7yZ7VTtjUnUGL
G/BM1Ry6G3GMioMrAa4IiS5csy2D87n9LeBNY7y8i249g60T1k5tE+vUnYX+Bart
g1qeOcaw1NdrQDbv8R5gBYj26bX3YTdFHhYxOGphH+sdC7cYNU0cKR9Ptej7LkUg
QrU7B9/jiQp2Nrsk8R14GqSif4Xwc3IwBbuyKYuSsHMEwd0gD2MgChgCC+yhFtMf
jN6W48wLIsKfkoCb1g1OAGSXdxRk3X4ZdSTFUyzTO1KZCKN2BYJlAAq/VhB/eOte
Cr3bxSVwIHe57Q3IAxApsCkdA/N/LSIw6RU2dVzQSCoOy7Z/derKimmSWIql9dmD
F4Hgb3AllmOWgCkHkNXFdCdof08GXmCMzhfIr49gpN5eBMMfDAqFHBxatwDqAOSD
S9Zwll0VHNrIc5bhsWIjB+Q836nxAP4ATwa1QlsswMlmpYC+GNzDaAIgzcFffVmz
ze3Hgwjg0NcJOmnkzd7+lpgFnHNXbrmgw5NfYLFUjWHlZH/gPYzJlH1j0QbapBL3
IvX6afMoTgsczZ12LqNXJdVbr4aIVzvSs+6QfTrYAqi8Sj8r/GlAKGM3qH7txvAh
0Ya/tBM048w=
=Bjkv
-----END PGP SIGNATURE-----

--=-TOiAONaRRvwpu+b9RFo2--

