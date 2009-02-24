Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58265 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZBXGc0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 01:32:26 -0500
Subject: Re: pull request: wireless-next-2.6 2009-02-23
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <20090223192659.GB3553@tuxdriver.com> (sfid-20090223_203027_265294_231D2366)
References: <20090223192659.GB3553@tuxdriver.com>
	 (sfid-20090223_203027_265294_231D2366)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vpFpMKN3DZUuZOMiaCd/"
Date: Mon, 23 Feb 2009 22:31:53 -0800
Message-Id: <1235457113.4455.89.camel@johannes.local> (sfid-20090224_073230_009099_24738113)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vpFpMKN3DZUuZOMiaCd/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-23 at 14:26 -0500, John W. Linville wrote:

> Johannes Berg (10):
>       mac80211: disallow moving netns
>       mac80211: fix aggregation for hardware with ampdu queues
>       mac80211: split IBSS/managed code
>       genetlink: introduce pre/post methods

Hold off on this please, the genetlink patch here introduced a problem
with locking and I'm going to rework/fix that.

johannes

--=-vpFpMKN3DZUuZOMiaCd/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo5RXAAoJEKVg1VMiehFYmlkQALYaKEsjnHkCbd0yaDVVIHd/
v/YLEwLICJssImgY5GvB/RASOZc7mI7jpxVWywXLuRTtkGrv4+NJWdQwIeHnx5c8
LGgPWPBPRmvGLKg9j1E73Pg87mSCaAWOSzEFfqVkZzUxN/RRJCsjSBYcpa8eUxMo
+OfxUbKalZSw7cXHrz+rb+bFwacUV8Ng6t2nfnfsW7VTGr5DVfGPoewrwSMUDUhu
W2gIwqa+GAL/SFXSjy8+exCUD6DEqJw53JlQQUnvKTemekSfY0KJpzUDK9YYsA4x
VuMoM+Ut3+BlMp13ZgAyHABg2TJ5TXjSPAEr32taiRazg3MPwTMr2b2Sy4ZdsNiI
mn6qL0puQVzqZUAuDzksEMHNJ6OjEllb+S8RSfez3UbdDqIBS4YDKmQtf87KBvn2
lwGZBgXuNztBXijXEvUdkbHvfcYyAXZEK3VFVDJn7YBYRYQF2EmV0cMpV7QYothw
DB1UE3mkNypGsrr9mCbALi3JEjljC6CfXGfDt37qZRkymYxSg6uhJaZrHtpXoWbv
j/FxbovX3syzgBR10scrIvgbPYvyAJ8Cf4Wr1yNal/GXG5LZ8s6x1UIeqHcYvFwI
oTi8YKBnuo+FTEZyDmzIikCY7V3dmWpL0N3joz68pZ73THC22No55a5QhcTQ5J7G
yswhwInHjtFaOVi1RwJZ
=yL27
-----END PGP SIGNATURE-----

--=-vpFpMKN3DZUuZOMiaCd/--

