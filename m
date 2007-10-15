Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbXJOIcR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 04:32:17 -0400
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <56412.80.169.182.16.1192431887.squirrel@www.dactylis.com>
References: <fdqhn4$qab$1@sea.gmane.org>
	 <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
	 <1192094159.4770.21.camel@johannes.berg>
	 <200710112005.56101.IvDoorn@gmail.com>
	 <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com>
	 <1192216713.4770.58.camel@johannes.berg>
	 <1192217047.4770.61.camel@johannes.berg>
	 <56412.80.169.182.16.1192431887.squirrel@www.dactylis.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dinnaYsMD6jck704Fsdw"
Date: Mon, 15 Oct 2007 10:32:37 +0200
Message-Id: <1192437157.3349.7.camel@johannes.berg> (sfid-20071015_093220_295358_C399B236)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dinnaYsMD6jck704Fsdw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-10-15 at 09:04 +0200, Marcus Better wrote:
> Johannes Berg wrote:
> > Michael Wu just pointed out the error in my previous patch. I missed th=
e
> > outer loop, we need to break from it as well.
>=20
> The new patch doesn't seem to solve the problem either. I get the same
> association failure as before.

Can you add back your printk patch and check what type 'channel' was and
maybe print channel->channel?

johannes

--=-dinnaYsMD6jck704Fsdw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxMlpKVg1VMiehFYAQKDOA//dqDwOZbKH/2+lQd3ct2YPpVwZIU5/ktn
WXRit2Y1+cYdB/HmSWsBHSeApyf9GZ3VscKYP2x8E+WOdy7owf4nPyWlM6XsoXKC
EDgXF6gpeB/FBsPUNAn9mHPWgp2IY7hz7t7ZxYGa/9B5Gn7Z7D6fIIgcgWp5NQpB
zAT+f6kWcX4qqkw9LUgsAnB4seB52LXl2TCkKs3QuNIeSOsPFIj5Th+C2TOIN9sx
c53Kl0jz6gH0gLWD1+WdmvmNF5yE0aT21aKQelrUOqWMQGrm4zFrGaLwtn4L46W7
QEsPMB6Kq9SlcWxWqL/pDtQlPyujARhwCfrdEUsyehX+0moLgq3yL1SGvhz0ps0h
hz8pKdawd27XpDE+VcmFuMtjXE1uaotD1hFUauwILrVdEVR3hCoCbobyjx51cb5f
Gr9Hp++MzjATzR4yhCRrVWWtfLDvi+ukbJhloRFFDMNNUAvG9uciZEXTmdKhjYZ0
KR12SU7q5BFeLeNf9QRjt3Du5EzKX25ysNcRLbEHGvsqokkqh6W6XiBBapazerij
JlHb6usjAifNipQ/dEyUmAFbyLG3c100KvMIWouFT/xfKV5viN5HindZHDPTOxgV
Tna0u8fyZPmU3DcJgFwZ+luoFohn5lRTuWxgwXz7rNNraDBeHsyxrJfQ6MTh+X/F
vLmOgisPzzA=
=tbZD
-----END PGP SIGNATURE-----

--=-dinnaYsMD6jck704Fsdw--

