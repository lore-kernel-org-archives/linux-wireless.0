Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757237AbXEWKQn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 May 2007 06:16:43 -0400
Subject: RE: [PATCH V6] mac80211: Add support for SIOCGIWRATE ioctl to  provide rate information
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <569491.18256.qm@web51409.mail.re2.yahoo.com>
References: <569491.18256.qm@web51409.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o/OhXETZ9OCvZaJG6+DA"
Date: Wed, 23 May 2007 12:18:15 +0200
Message-Id: <1179915496.14317.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o/OhXETZ9OCvZaJG6+DA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Joerg,

it is recommended practice to never remove people from CC, that applies
to From: too, so you should have sent a copy of your mail directly to
Larry as well.

> what does SIOCGIWRATE do for IBSS networks? In this case you might
> have a different rate for every node in your network. Looking up just
> "sdata->u.sta.bssid" is insufficient because the BSSID of an IBSS
> network is not a real MAC address (after all, there is no AP).

Nothing. It returns -EOPNOTSUPP, read the code.

> I would very much like an official way to enumerate the current rates
> for all known stations in an IBSS network. This information would be
> useful for AdHoc routing: Currently most approaches use packet loss to
> weight different links. In this case a link might look better than it
> actually is, because rate control already lowered the current rate to
> a level where no packet loss occured whereas another link with higher
> data rate looks bad because it drops a packet now and than.
>=20
> Is there a way to get this information?

No. Feel free to come up with a spec and implement it for
cfg80211/nl80211

johannes

--=-o/OhXETZ9OCvZaJG6+DA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGVBTn/ETPhpq3jKURAh3pAKCg7x28IWcDhO6tRJEyddUk2MKd4gCfXPTG
9tEj3CMeC+gdjUDRJqE6xs4=
=yfp6
-----END PGP SIGNATURE-----

--=-o/OhXETZ9OCvZaJG6+DA--

