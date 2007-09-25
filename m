Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbXIYVT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 17:19:26 -0400
Subject: Re: Kernel BUG when using ad-hoc mode in rt2x00
From: Johannes Berg <johannes@sipsolutions.net>
To: Adam Baker <linux@baker-net.org.uk>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net, jbenc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1190754547.18521.326.camel@johannes.berg>
References: <200708082324.17186.linux@baker-net.org.uk>
	 <200708162243.05809.linux@baker-net.org.uk>
	 <1187345617.23489.143.camel@johannes.berg>
	 <200708202121.35543.linux@baker-net.org.uk>
	 <1187692485.4288.11.camel@johannes.berg>
	 <1190754547.18521.326.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-352ZSrWGs4zj16ZGSjET"
Date: Tue, 25 Sep 2007 23:20:33 +0200
Message-Id: <1190755233.18521.328.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-352ZSrWGs4zj16ZGSjET
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-09-25 at 23:09 +0200, Johannes Berg wrote:
> On Tue, 2007-08-21 at 12:34 +0200, Johannes Berg wrote:
>=20
> > At that point, sdata->bss should point to the master device, which
> > apparently hasn't been initialised yet. The device initialisation code
> > is pretty black magic to me, Jiri/Michael?
>=20
> No reply. Can you try this patch?

Ah, no, there's a bug in this. Try this:
http://johannes.sipsolutions.net/patches/kernel/all/2007-09-25-21%3a19/005-=
mac80211-fix-register-netdevice-error-return-oops.patch

johannes

--=-352ZSrWGs4zj16ZGSjET
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG+Xuh/ETPhpq3jKURAlmBAKChydRy/ED8yejVRjjpf0LrNHlMvwCdEen2
hSuQnUdlDS7YVcg82Gvi4C8=
=6vHc
-----END PGP SIGNATURE-----

--=-352ZSrWGs4zj16ZGSjET--

