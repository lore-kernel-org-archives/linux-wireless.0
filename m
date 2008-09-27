Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35077 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYI0JUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2008 05:20:35 -0400
Subject: Re: wireless-testing modpost failure
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <1222504695.3798.38.camel@johannes.berg> (sfid-20080927_103825_094353_5CEDFB62)
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
	 <1222457416.3798.25.camel@johannes.berg>
	 <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com>
	 (sfid-20080926_222513_164399_16E42BBE)  <1222504695.3798.38.camel@johannes.berg>
	 (sfid-20080927_103825_094353_5CEDFB62)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LYRxf+JmqDozIZ/CgjNV"
Date: Sat, 27 Sep 2008 11:20:25 +0200
Message-Id: <1222507225.3798.45.camel@johannes.berg> (sfid-20080927_112048_579902_916A1495)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LYRxf+JmqDozIZ/CgjNV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-09-27 at 10:38 +0200, Johannes Berg wrote:

> > >> >   Building modules, stage 2.
> > >> >   MODPOST 216 modules
> > >> > ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
> > >> > ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!
> > >
> > > Davide, can you tell me what file/line it fails in?
> > >
> >=20
> > How can I tell you that?
>=20
> Good question. I was thinking the linker would complain at some earlier
> point too, but I'll just try to reproduce it myself.

Ok... I can't reproduce it. Can you turn off CONFIG_MAC80211_NOINLINE
and see if that helps?

johannes

--=-LYRxf+JmqDozIZ/CgjNV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI3frUAAoJEKVg1VMiehFY8x4QAJ3lfAOChPi3fNlMhIbTb3B1
MuE+bYOzoBtKNSHNPDfct9wvlOYECkFnteqBTlVfsnQ5mEJd7iXaaIYXm/gALBc0
xYXL8tK5RKJSCescrpoGNx11u/r/ktDK64yzG3r1nOitCDs3FmVWsZILIayiBPzV
mPjYayCb4EmCK2WZqVLxBi8GLEEmDhtitizIu/lQ7Jqph3Pto5W3YzhtvFWkoPJV
t+wGq7AR6dYQGQYMkoMM8/aEjSQH24wmpwOxY4iMFO/T30RbD1om6Tbol2q3ZI8Q
0N/3YDAHS5E1+GmgJxYcER7jO7nVXH5ulMgZFaJcT7hAFqcuEg8+NFGxfwSpXTXf
zKUxXQWxJsVDOqhUimLpy373nxSXxw9ZGTcW4WDafes9LbjYu+YeHj3kUzcmGCOe
r9TmjrnF80nHpk8/iPWe3fuOVd3TY056iF69TKbLQaPXVODm1Xqfp1u6jHLvbYvn
3XmQCyIIllU7DS+BaVis3crVwlfcdGejpaHEzH9k5Y09HQUtuF7z52cZzzHtduBN
mTyhVS5no3JbCp7arFaVM4StKj76Nszzkr41JKbvUgszhsbTs+gkmVSSTMKRRAkB
8qYlLo0vz1ld6lPEKk3CtNYkH5hN5dIiaVVgujsFrOJfgTfxKFm8t/oD9NeoIb3m
Y7iY9wIZWcOsHQyyeLBG
=DQf5
-----END PGP SIGNATURE-----

--=-LYRxf+JmqDozIZ/CgjNV--

