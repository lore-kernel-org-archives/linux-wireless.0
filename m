Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53041 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbZCXIVe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 04:21:34 -0400
Subject: Re: Lockdep complaint between drv->mtx and cfg80211_mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090324004716.GA22925@tesla>
References: <20090324004716.GA22925@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3O/QCTO7QXygdva8YJr4"
Date: Tue, 24 Mar 2009 09:21:28 +0100
Message-Id: <1237882888.6278.2.camel@johannes.local> (sfid-20090324_092137_909024_39E4F970)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3O/QCTO7QXygdva8YJr4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-23 at 17:47 -0700, Luis R. Rodriguez wrote:
> What I had done was load mac80211_hwsim with the module parameters regtes=
t=3D4 radios=3D2.
> Then I spawn hostapd for wlan0, bring up wlan1, trigger a scan using iw, =
and then
> I rename wlan1.

No need to do anything that complicated, the rename alone triggers it :)

I'm testing a patch, will send after that.

johannes

--=-3O/QCTO7QXygdva8YJr4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyJgFAAoJEKVg1VMiehFYMzkP/0J/3Lv2n7RTxO//EpEaNCco
PZpwoxZEEMRH6JdFBFRQK3TB1BdauLm3sssRDyRnNyVnhm/wzCXnCdwChwEWXB1g
kY5Mj5rIdMXKtvKpKghtnn8LsibityVLHFNx/bCtORCTS65MabeSeooJWQBAPsgs
hbY6MCHVjbhZlJ7L6VDEA5/ewC0ugxIc6rNlQf1teOGVxI+8PFZK7gBniqmpFwMF
S7aLIJFD3CS2fAWMituYp9Br7tledqO/Cl68/FCaHTXDyztgHTcLz8YkegclqphZ
D0Sf2Tmmc5E4djvorMLmcs5baWxbvpyxW7h9JC04ePsHc4554ymFFqrfw19jzwHp
WLTFz44HuXKVa7OJ1nPaXrbOcHRr6PZ11j1Cyg9RgcNv+D7Kz37v5sWoR3k0jK1x
N3YmYvnLblw8UqjOgYIsMhpDOYq3xmuP1KYjK/FCAG4ipCwAnlGBsOoJ/u+n5VKh
/9JC6TBWNqD7cJWyGP2avYibKpF3SsKX+NJn8BYpRTlIr83cJSNr3I7IUirN8RjC
QFMjO2gr/tzM37GwobSMrGTN7Uy+kS0RFaqejsrhTwv2xfg8JWoO+wdtyZFxj6DW
IQj2XIMpm2hK5yWxuZ8BGKyXl0rb11QGKcESK2k9MPx/vFW7Cu8oDTLR9RY7v2Tr
71dbLPwXcq0qFvVsVfe0
=y+t9
-----END PGP SIGNATURE-----

--=-3O/QCTO7QXygdva8YJr4--

