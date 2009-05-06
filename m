Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbZEFIWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 04:22:49 -0400
Subject: Re: oops during stress test - today's wl
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>
In-Reply-To: <43e72e890905052319r7c6b0932gf00822dd29536587@mail.gmail.com>
References: <43e72e890905042005vb96f57aid70c476e38685dfe@mail.gmail.com>
	 <1241509306.25337.4.camel@johannes.local>
	 <43e72e890905051227n11b128bap4d250e66294a29ce@mail.gmail.com>
	 <43e72e890905051829k5df86692m34209f871e384127@mail.gmail.com>
	 <20090506060646.GF18158@vasanth-laptop>
	 <43e72e890905052319r7c6b0932gf00822dd29536587@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-QUmHCvpXrd7hahNzUgQ6"
Date: Wed, 06 May 2009 10:22:16 +0200
Message-Id: <1241598136.4969.5.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QUmHCvpXrd7hahNzUgQ6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-05-05 at 23:19 -0700, Luis R. Rodriguez wrote:

> > This is protected by rcu_read_lock()?
>=20
> I was under the impression this would protect against deletion of the
> sta but not modification of its parts but I am not too sure.

That's true. There's a possibility that mac80211 hands you multiple
frames at the _same_ time, on different CPUs, due to multiqueue.

johannes

--=-QUmHCvpXrd7hahNzUgQ6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJKAUi0AAoJEKVg1VMiehFYirgP/16klwDb9DALywd5wdz1aD7j
3Xcl7DtPTDK06eW+Y74KYXnV34Fw6N8/rnMedXL3PcS9FcjiFyGyR3Kw1F3OoPAx
NKiUeFEuKp9r+tez08cW9GrbEw6S8XEoILC2dBX4unoVex5mWlW1ackIyLNLR3r5
W2U2tmf1FxFjPoWvI/2dUA3WyQjQFzZ8NyrTLB5VU9EtCWzXwFzAK2TRI+6w6xrm
OvtUAYJzxTi38l4l44fRqnQsdwunwgz3A3Xjn4pEVltc5UBtzHm6/6A/TiAHq1wF
Hd04l1aJg4lX3FLWJ1UEbUop70yoTdV5CLC9VUO7zskuIEDSIX+oY/ep6sIRHi1J
FsvztO0jQYwkcTwFlAjV/FtsVQCgZoCONpSCvRt7gZ2o8cpDSOSCBZkfbg61aKRz
j+wbyXGgyilVlgXXg/j5IRBlMtRQx6hIuW7ie5xSGEJToClmnYMDTIe06tvVN7Hz
Ht0UYEoxoM+/9UQrIJ3d5NdqQAxGKwAcdgyvwaCxwz38515qPc4FgSexky1Z6OOE
ahFxvJA9mZeHV9QBKHJOU4Hdo4Nd/ZAzv1zIWGuKOKC0v9ncLwKZfUMRW0xqwV2e
0tWGmM8yW4mnzFLB35yT7zs9sjw7x68xDborQt2isnQsm3Vn2yO+76qosZ6S20To
qdcHBEQyyLmfcLHbgTyf
=ddbx
-----END PGP SIGNATURE-----

--=-QUmHCvpXrd7hahNzUgQ6--

