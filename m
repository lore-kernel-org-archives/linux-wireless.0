Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58688 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365AbZCYJbW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 05:31:22 -0400
Subject: Re: [PATCH v4 0/5] mac80211: beacon filtering
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <j@w1.fi>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <87iqly0ydm.fsf@litku.valot.fi> (sfid-20090325_100214_789683_0EF6DA0F)
References: <20090322195619.26460.48292.stgit@tikku>
	 <1237900276.4320.86.camel@johannes.local>  <87iqly0ydm.fsf@litku.valot.fi>
	 (sfid-20090325_100214_789683_0EF6DA0F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BoDqm900HotSIbbsF+9O"
Date: Wed, 25 Mar 2009 10:30:45 +0100
Message-Id: <1237973445.4320.135.camel@johannes.local> (sfid-20090325_103126_678770_05D8A95C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BoDqm900HotSIbbsF+9O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-03-25 at 11:01 +0200, Kalle Valo wrote:

> > This actually affects the entire stack, take for example the BSS load
> > element, which could potentially change frequently. Unless
> > wpa_supplicant would want to use it for roaming, we could ignore it.
> >
> > However, how do we know which elements the various pieces of the stack
> > need?
>=20
> I think we can just start with a fixed list and start improving that.
> Or did you think of creating the list dynamically?

It has to be dynamic, no? Much of the information in there would be
things wpa_supplicant is only interested in. If it was just the kernel
code -- yes, we could just have a static list somewhere -- but much of
the 11k things for instance are only useful for wpa_supplicant.

johannes

--=-BoDqm900HotSIbbsF+9O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyfnCAAoJEKVg1VMiehFYA9wQAIEM4BZLw7LvGzndmt+xLXU2
NYvphBWugYfwjgDt/fSSVmimKHNvRZtYZxkV3ttK34DmaYWJeF2s9j/QHvl3AfV0
dtNOxuLAp8PtYK0VeMLolx/X564EyriouhDCADnVEctsJnMq2Cy/lpq7T3jqeW7l
fR01TBPmPTaJrzC86I57MZO/wxTq2Fj3W17QjVIUoqAxbdcrGGA1lKYoaPY/NZzl
ibzRNxHQNvnsSABk8kTlm15YLJelWAMfGXpeAfWUAQ53pcQZ8PXSIppk2pS1ILWp
IvUF6dg3wuEkO8AL9snzU8eniht2HsTmKdblgsSDIhVnzb44hMmB2aqicRnBuTCI
6VjbEXs0UpFIgHuJk950J8vT0jWmKhcKj9U5tTa1gLa3jCWIgqPZhjmhcsb61GsO
CK0Wdeo1JVGt/fZHyt7HhH9h8dfBcWtMxSC3JzMX9R/NaXV69w2zHM6Re2B/7JL6
xoGfbtR+wCFoOpa2lBTNCfqx3beKVPLXC5AVDfl3BkBZBSEIEB46MJPHoO50eIDd
4EEb5aHc+KJSE95+jnD4Kg3wlsMXdVclymybueAxaTRPdVdkpqfahwKSkTE6bh8W
gpu/LqZQvE3XuryN3eZOjQJmaZTuQ5j0t7661mx1GQZp7ySxCRL3vDaf2vKCeJXl
I9qQMz68ZAoheSwmDn3v
=C2OP
-----END PGP SIGNATURE-----

--=-BoDqm900HotSIbbsF+9O--

