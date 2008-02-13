Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYBMMTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 07:19:54 -0500
Subject: Re: [PATCH RFT/RFC] b43: Add QOS support
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
In-Reply-To: <200802131314.34930.mb@bu3sch.de> (sfid-20080213_121556_937322_839FCE08)
References: <200802122205.42799.mb@bu3sch.de>
	 <1202904473.8931.31.camel@johannes.berg>  <200802131314.34930.mb@bu3sch.de>
	 (sfid-20080213_121556_937322_839FCE08)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wiEI1MBVn+hYIE85F5L6"
Date: Wed, 13 Feb 2008 13:19:45 +0100
Message-Id: <1202905185.8931.41.camel@johannes.berg> (sfid-20080213_121958_535683_CB3A403A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wiEI1MBVn+hYIE85F5L6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-02-13 at 13:14 +0100, Michael Buesch wrote:
> On Wednesday 13 February 2008 13:07:53 Johannes Berg wrote:
> >=20
> > > +	if (queue >=3D ARRAY_SIZE(wl->qos_params)) {
> > > +		/* Queue not available or don't support setting
> > > +		 * params on this queue. Return success to not
> > > +		 * confuse mac80211. */
> > > +		return 0;
> > > +	}
> >=20
> > Is that really necessary? If so, I'll probably remove it when doing the
> > QoS rework, it shouldn't be, imho you should return an error if mac8021=
1
> > tries to configure a queue >=3D hw.queues.
>=20
> Yep, mac80211 walks the whole queue array without looking at hw->queues.
> I think this needs fixing in mac80211.

Ah. Yeah I already fixed that in my WIP QoS patch.

johannes

--=-wiEI1MBVn+hYIE85F5L6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7LgYKVg1VMiehFYAQJsIw/+KtBGGX+lzbRWCMu6GSI6/05dFpWdxwNV
8UsnSRLNBi1ZhAWnLyN1cDQvjZytAQyOfWk32Ecekc5mY/NiTBmXGxdBly17FlBO
QXVOrZraz0tHCQJBWBzd8I+evWJnmVtMykD899dFcHtLPTw+hE2y2t4kmFfJ55UJ
9zA1lheXzrVQHL+nqBr8FPlqCu4nuGQ2lvKQ64shfQ7mg/BeANu2+GhHDAj9BV7E
0uP+UteEtwUl/eApAPdZ8c2UvLMYPYuJ1vYH2t+On+bSn8UK/3cmSDpIy4S0/BFy
dK322QReN9sWK3XFbqTrM5nEASlVfWDymidBktNQmiH6+M0RpLz1uEAwpsWIjEqh
S9UR2cluqjpBmcbu48T7A9PFF4inVt576GCL+/IG76fbHH/IEw259GUXZzfXMfCq
3M0URnGcFA4Sy8CZJ8dtojErsQRe/y11QmXqDPiNRvxlwgWRmAQhZ+ypUT0bD98r
5sPQ21/q3VbGSc8QG0VmUR3lG9d78MHJT8++S/xLOZFGahorlsegChkNRICVQqS/
QPyiFuXDt23mMo270lMrnvCGkspj+2rPsywl4plgTZUZWFtDJdtCQHElH0uq+oK8
DyBzFv1lJTQhEg+yhfw6tu5jU9w76S2EgvxVwjC897GPPMnqNXrP5n0GyDyb+9R+
+wo7UzsBCF4=
=kZEB
-----END PGP SIGNATURE-----

--=-wiEI1MBVn+hYIE85F5L6--

