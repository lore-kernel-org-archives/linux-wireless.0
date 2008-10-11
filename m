Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59302 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbYJKWgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 18:36:23 -0400
Subject: Re: [PATCH] nl80211: export HT capabilities
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810111529l1cb14bd2g32e7382b054b0b1b@mail.gmail.com> (sfid-20081012_002955_469603_981115D3)
References: <1223547613.22490.41.camel@johannes.berg>
	 <20081009085747.GB11530@tesla> <1223630622.17594.0.camel@johannes.berg>
	 <20081010213610.GB20509@tuxdriver.com>
	 <1223675046.29811.0.camel@johannes.berg>
	 <43e72e890810111529l1cb14bd2g32e7382b054b0b1b@mail.gmail.com>
	 (sfid-20081012_002955_469603_981115D3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Aingz1fgNNbbHS4vCvgW"
Date: Sun, 12 Oct 2008 00:36:06 +0200
Message-Id: <1223764566.3581.0.camel@johannes.berg> (sfid-20081012_003629_520496_FDAB6CED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Aingz1fgNNbbHS4vCvgW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-10-11 at 18:29 -0400, Luis R. Rodriguez wrote:

> So you're going to #ifdef on the iw nl80211.h?

No. iw actually has a copy of the header file now.

> Can't we use something better and more obvious like defining an
> nl80211 version (as kernel version won't do us any good for bleeding
> edge wireless-testing users) or something like that?

Eh, no. Version numbers suck. Always test for features. Besides, this is
about compiling, not running.

johannes

--=-Aingz1fgNNbbHS4vCvgW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI8SpTAAoJEKVg1VMiehFYVPQP+wYwDaskQBEzWruKSr6b2aXA
MABF7PRu9tU0e4Qb12Np6m1DcORlIf1OCv5ZWRhqMmys0olrd4HuUZ7KJ6JcKilw
mQnRXj1YLEOjSKge4FvBSWX+hfASxfJI2xcPIavmdj/2XypmVJKewMi1nDPfs8I1
0N7FUAjXmuuq5wGdwdWU7ylfKsa0DDcx4cEwLTbRZLU70lTHs6jYps1NNdjvMFad
Q2zeWnhnrQWf8+hx9sTZKLjJ9Jai9U8FZ2Bif1xUhB7JXHLKgJEdUPOReQc+TRAG
UBLPqDr65YjbRCoS3KkU52BtFxo/k44AdAwosWL32o6BANJBr3uQwuQG65nYif4j
SNWRuz+fbbYAsaIkf1hLeTgLnCcXsfynENJPJbREmPr9sH1K+WdX+OHSGY4BzdmS
bEV3T92FLJXYYF9zNMpWcJiunIODTASPHWDfOsqaGOoqk2fwynzTuzIKRr/XBMkt
4HDYTyiaNu2778m0yEVEew7pRvRcJT7EqWWoMA93e4AkgJHGqX8B4EazhucAbi5e
tRm9NTB5RpQxT+tRAYzu5PDvgSJNYBZSa9i3kw1Zik2V6rVgfoO1XzqeYndd3+o2
qCyAivtlVsDiekJ1nVtmM8TQB43+PmqORsQjAp8O60VGPI61dh8O/N5muJjvKEH2
MImrF/TldkqJbDzDdjYh
=e9kd
-----END PGP SIGNATURE-----

--=-Aingz1fgNNbbHS4vCvgW--

