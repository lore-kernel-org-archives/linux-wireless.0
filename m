Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39852 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbYKCHf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:35:26 -0500
Subject: Re: wireless-testing commit
	eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	tim.gardner@canonical.com, mick@madwifi.org,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com> (sfid-20081103_083019_853551_F6ECC8A9)
References: <4908B754.1050400@tpi.com>
	 <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com>
	 <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com>
	 <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
	 <20081102184146.GA6065@hash.localnet>
	 <43e72e890811021249x6047b38do5d7ead10fe4098e7@mail.gmail.com>
	 <1225696692.3619.18.camel@johannes.berg>
	 <43e72e890811022329g510a280wfd033538ee9b8c17@mail.gmail.com>
	 (sfid-20081103_083019_853551_F6ECC8A9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IKzh8eFWUCb96AdncNq7"
Date: Mon, 03 Nov 2008 08:34:46 +0100
Message-Id: <1225697686.3619.25.camel@johannes.berg> (sfid-20081103_083530_729415_B247DBC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-IKzh8eFWUCb96AdncNq7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-11-02 at 23:29 -0800, Luis R. Rodriguez wrote:

> >> Not sure I agree with the WARN_ON() if the driver's mac80211 config()
> >> callback fails. In our case when we tune to a different channel we
> >> have to clear any DMA operations first and then we reset the chip.
> >> Reseting the chip can fail for whatever strange hw issue cases. The
> >> patch fixes the complaint but is the complaint sane?
> >
> > What's mac80211 to do when it fails?
>=20
> How about a shiny new nl80211 event?

And wtf would userspace do?

johannes

--=-IKzh8eFWUCb96AdncNq7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDqmSAAoJEKVg1VMiehFYFmUP/i6JxZMjr74u6DhT4gppjdjH
593cC1lBs4SLC7fnZw/+F3j6NofpRVe92+Jypjr3uvohjf8FVDRK2a/8oJxtCA+8
2izDb0QHWBq7reu2PLaZMbps5G+1Vh/9fBG+NVIsP59byZFtmGDpxAQLwbEykyD0
HnflQZzXLtKmYU2UhRdpVADAf85KGW+nxghJuwJKRMjJPYa9Nnf8KxJY6EBkdIlA
v11gV0Bf/hVLCZ0nsTtfDUF6JJTv1VI9yRUcIZvGsag1LcdJqQKrBOzEBOkk48vs
eYYuGTWB6h+3OqvLZUsNoMaIw8LPhAe0yKnGzbU77YB2NmsdEn+BZ8SlGvr9RHj3
fgbgwljmm0lIBYnYQKdTLe+CB5c5s5Vj1ybqWSjunwUg/s6x5HiWHvIBuJAiompK
bR1vQRvBIoGLPnQlIyJjzm2h0kDNwGprtWbjUY2cX/WC2OmaX9+1j/lbYQ5+UQmo
fZQUhuxAx38Co0pY/fd6LfMlbwJWMkIN7cIPVPcJWJbhtIiOaXxrv5T0Dq0hXKuJ
uf9UBRiu1hM2z7NR6zoc3T/1dzvXFtmwyWwjAyahDQfZjtKU2eM/k/uxVt/HxV3x
/oE39RUT29ZDbP0gLb5MDXj0LBr78lsL0F/4RQ/Q5TEc+VrbRe0xkGukbHuU7AWh
1EZBEPu1Lhr0ozRjimf/
=deR8
-----END PGP SIGNATURE-----

--=-IKzh8eFWUCb96AdncNq7--

