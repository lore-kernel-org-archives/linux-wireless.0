Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022AbYIIIwp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 04:52:45 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com> (sfid-20080909_104625_349198_14BEFBEC)
References: <1220883730.31304.60.camel@johannes.berg>
	 <48C5868B.8060103@w1.fi> <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 (sfid-20080909_104625_349198_14BEFBEC)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-V5RfvtFO/+g0rDViIJVH"
Date: Tue, 09 Sep 2008 10:52:38 +0200
Message-Id: <1220950358.31304.112.camel@johannes.berg> (sfid-20080909_105303_929764_CA1A67C5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-V5RfvtFO/+g0rDViIJVH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 11:46 +0300, Tomas Winkler wrote:

> Meaning that other management frames are forward to user space while
> BA action frames
> are treated inside mac80211.

Can you point out where? I don't see it.


> > Also, I'm not talking about the AP triggering the aggregation session,
> > this is entirely done with the rate scaling right now, but about an
> > associated STA wanting to start an aggregation session. Aren't
> > aggregation sessions always triggered by whoever wants to send? So if a
> > STA notices it has lots of upload going on it could want to trigger a B=
A
> > session, which is something we don't currently support afaict.
>=20
> In iwl-agn-rs.c There is not difference if the peer is STA or AP. So
> we support this already.

Not sure what this has to do with the Intel RS algorithm?

johannes

--=-V5RfvtFO/+g0rDViIJVH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxjlTAAoJEKVg1VMiehFY6fYP/3d0+8JM4D1NazGnSUYmkMZE
AAqeNKFWaJhFEwpVXhX/R/Upf/Pbz/IE6nvO85sre10rAipleogCdLnmerfKhjsM
l1vb6F0hkXxgczbnlbaX7DhpU2sN5A19zyAYzXq30mAROMJ+xgo2MptTWH22hM3I
sCi4mqTF+RBPBeWy98lOvYKjXTrKiLVO4hapwzfSSfCwYqTkfgMZXD6Wz7uhAGi6
GrN24uZ/XeeB1n6vrN8nKthf3RFooNQS4bS4+R4mx67RS2P6yccmmwESAEo2Ue8D
r1Bye2BOSFlLdiDHCa5tf/gAsLOv4vwqfdf8B3LsZylcYkb7CYfSef+c8FA3JGrL
3hGmYNeVjd7mGJj61UbwetRNZavdt3gv2t/kTilwsU9BYGe9N5rnHfzHc0eLqfPC
LSQ05j0c8sCr7Ihuz0c6sAup5FZMznCT4hpdmSFYCV9eCunAb+pQplN0XI9bnerH
sYmHK0nuOHn51kJWwZ+EE0TmqlplfjqrO76OEIyKkSXAySdJ8YbzMbysVjDhWc0F
K42KFCeU+cWZ9LcudeTCXkvgvQUpn6lsBIDYrvBJTQ8Eo6uaXYWD+6IJiLge9O/v
h+Btq600bIx4ZeQbojt7izCMsitq+hyM3lcpoqZpAaU0/eGM88LWHa8V+WkSKlFQ
4KXkatRG3YHhxxOG8YLB
=j6W/
-----END PGP SIGNATURE-----

--=-V5RfvtFO/+g0rDViIJVH--

