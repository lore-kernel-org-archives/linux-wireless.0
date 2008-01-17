Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40658 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbYARMgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 07:36:10 -0500
Subject: Re: [FYI] hostapd status
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Bas Hulsken <bhulsken@zonnet.nl>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890801170952q23ff6550s7214bee32a2860f7@mail.gmail.com> (sfid-20080117_175254_072993_FD6A6603)
References: <1200520735.8007.20.camel@johannes.berg>
	 <43e72e890801170952q23ff6550s7214bee32a2860f7@mail.gmail.com>
	 (sfid-20080117_175254_072993_FD6A6603)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-peCg4hKgJCzljpnJYZOX"
Date: Fri, 18 Jan 2008 00:18:39 +0100
Message-Id: <1200611920.8007.73.camel@johannes.berg> (sfid-20080118_123618_954923_B971EE40)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-peCg4hKgJCzljpnJYZOX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Well we need regulatory daemon of some sort for non-AP hosts. I was
> considering throwing this as part of wpa_supplicant/hostapd code. I
> guess we'll see.

That'd be doable, but sort of leaves people who don't want to use
wpa_supplicant out. I guess it's only a matter of time though until we
require use of a supplicant daemon (userspace mlme and all that...) so I
guess it doesn't matter whether we start requiring it now or later...

> > I hope Luis will work on the last two items, and I personally want to
> > handle only the first two items. All others on the list are up for
> > grabs.
>=20
> ACK -- I will.

Thanks!

johannes

--=-peCg4hKgJCzljpnJYZOX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4/iT6Vg1VMiehFYAQJVDRAAkXzbzm8UnlALr2N3JdnIKqCYs1sN8dUW
cjlx3fnlM50fewN3dCECWAqA4H0EMSPK3NPEL7EIVANDM1oflJTHQRMnbwmk9lri
Vpe6SO5bP/HAKueoWeEJy71BkeK1HKyyVCi6MbYeOLJVHNmw4c2TNhEd4FAa6mbb
UEU2olvxxBYlGN/o83RNcH79EOGa+haf7SUSM7mv1oodRTTM/yS72JV32BYqeqDH
qdpyXA+LMdPAZfI3c3vfB21qLhOFguj27FOUmE9vsQBniAqV60vgJs5fE7EDfz1e
+EKPsXjEJV+H91OZjportTJbHvldI0/XfMcBB+j5euFF9dsArWasmj14iJVhGEYb
1gIUrUw65VLUKrS52C4V77XMAa5how0YzpoT/baXMjt9182ALXTQR4moS4rUzf4G
XOEouyOROKW3N0oFO/UwN0CkYn5bqHt9lFYZWZnNEjfd48iQ4+P7hYtUrL9mRWIz
6QPpET2WfYqsWZdFkj56EO2hX+TFAYShB9TvgZgFgqq1+LkcVxoG/cnN8IBF2kZV
vrzFUPT5pp0Dj9OJW2YKwgxquX+/Wd5xLl/npByby8RC85wr6IQSjsvucGrTCUjS
O9xK7jWBUbIuN+y8ovZNN/KxmT4Ow2yDv/SxBaJMPSvIZaHPape7iBCD8fjBS1rD
o/oJ/cP7O2E=
=zLkB
-----END PGP SIGNATURE-----

--=-peCg4hKgJCzljpnJYZOX--

