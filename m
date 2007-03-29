Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbXC2L1b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:27:31 -0400
Subject: Re: [PATCH 3/4] mac80211: Monitor mode radiotap injection docs
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <460BA0A1.7080106@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.575903961@warmcat.com>
	 <1174500950.3944.15.camel@johannes.berg>  <460BA0A1.7080106@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Fk0K38LYhpXjvyO16CDJ"
Date: Thu, 29 Mar 2007 13:26:14 +0200
Message-Id: <1175167574.8807.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Fk0K38LYhpXjvyO16CDJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-29 at 12:18 +0100, Andy Green wrote:

> Well, the actual injection action is happening in mac80211.  I think=20
> you're looking at it as a cfg80211 wext-replacing type thing and I am=20
> looking at it as completely generic mac80211 packet injection from=20
> userspace.

Yeah. Don't worry about it. We can move it later and define it for
cfg80211 when we introduce the userspace mlme stuff.

> > Drop all that, it's generic radiotap description. Put it into another
> > file if you want.
>=20
> This kind of description makes documentation useful to the reader, who=20
> may never have heard of radiotap (it is not very visible in Google right=20
> now in a useful way).

Maybe just stick it into a radiotap file and refer to that? I'm just a
bit worried that it'll get outdated because somebody looking for
radiotap stuff won't find it here when updating. Not sure it can even
get outdated though.

> It's ~380 lines.  It also knows how to conjure up management interfaces.=20
>   I can chop it down and put it in here if you feel it is important.

It's probably easy enough to write from the docs so probably not really
necessary. I think when I wrote this I was offline so couldn't actually
check out the demo program ;)

> I appreciate the comments, but I am 100% sure that some correct=20
> documentation that may be over-chatty is better than no documentation at=20
> all.  After hesitating and starting to change it I left it as it is, if=20
> you still feel these things are important comment in that direction=20
> again on the new patch and I will grit my teeth and change it.

No, don't take me too seriously. I appreciate documentation I may not
agree with in all points much more than the lack thereof :)

johannes

--=-Fk0K38LYhpXjvyO16CDJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGC6JW/ETPhpq3jKURAuQoAJ9jzRDESbdu73X3ehJfXm5XPTzk1ACfRb4A
l0ykh7Vs0whEpnTNW2h5hkA=
=agcv
-----END PGP SIGNATURE-----

--=-Fk0K38LYhpXjvyO16CDJ--

