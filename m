Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYFJNMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 09:12:01 -0400
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <20080610123007.GB1571@tuxdriver.com>
References: <20080610105058.GA6961@jm.kir.nu>
	 <1213096575.3668.6.camel@johannes.berg>
	 <20080610123007.GB1571@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AIY6pNykq+ra3LScBNkO"
Date: Tue, 10 Jun 2008 15:11:09 +0200
Message-Id: <1213103469.3668.13.camel@johannes.berg> (sfid-20080610_151208_700604_5E6F70EA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AIY6pNykq+ra3LScBNkO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > One thing that I'd like to add is a having a "global" monitor interface
> > that is registered by the hwsim module and not mac80211 and shows all
> > frames, regardless of channel etc.
>=20
> That sounds like a great idea.  A mechanism for injecting frames from
> an external source might be useful as well...?

Using the same interface maybe? We can work on it.

> Jouni this looks great.  Let's get this into the kernel.

I wonder where to stick it. net/mac80211/virtual-hw.c? Or
drivers/net/wireless/mac80211-virt.c? Heh. Not that it matters :)

johannes

--=-AIY6pNykq+ra3LScBNkO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITn1pAAoJEKVg1VMiehFYeJMP/ReDe7EkFujovNNFOMVwq2Pg
nqWwEp5m5cguxvBpiN1yQ+fpSBsdJLWB7tRUffjAX1d/bug8SsIzkbnfTUdgU4dB
Ns1nwDZBVEvZSZJE3iJm3uyRG1vhwjbD4NecUJAnIO4qgoRALqb1+1lBamaOgFoG
Dh6Jflnbnh3/TsbTpUllIu/QG4pCphrd60//PKV32l/S05kxYI9NYtMmO9xE4eJ4
Uzn88Dfo1ZJSA1uiaSgcRAgxHAT2Bsi2nyzwfRrSvKkwHJFt/Qwnmr6//8zNw190
Ol96hqKT5OF3JG6no+c0qIsbWpNj2aFl/1YAhdNpAaJg54J+n9FcAqCLBpyY5U2P
nAr0RRhRqwhCRZ63hmVRXlthJDq4gBRlhdwJ/QsNGV61FNqTRkjvKMqQ+bXmwHlG
tao+80D4B40Ups9fykKoHa3+9ocG6xKikCxOrQB7blusmWdrrTIrd0O/TDbo7cjl
+kwgqRUi7Hsg5044Fe0ODWMPVRf/KRil4DQ3kCA/0IYGpc9rqHK1rD2J94faDwAo
Rx1tbVanjLustMWoLVntv5QycqVW+YlNL7oe2gigP7Y/PFqaYjmnf1ZuPVOfNVL8
dUUKjmqBr90wNPWK8wC4Rx356yIDy3cAUJBK1ylYiVbJ2b4+zoRt8//eM3HOcYN+
GYKx7m6p2GHjjZtoHwMq
=IwJt
-----END PGP SIGNATURE-----

--=-AIY6pNykq+ra3LScBNkO--

