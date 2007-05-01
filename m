Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47062 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031219AbXEAN0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 09:26:15 -0400
Subject: Re: d80211: How does TX flow control work?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jiri Benc <jbenc@suse.cz>, Ivo Van Doorn <ivdoorn@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <46373B94.4080307@web.de>
References: <459A5945.80909@web.de>
	 <20070103185203.2754e059@griffin.suse.cz>	<459BF179.6000906@web.de>
	 <20070103191853.4f440b8b@griffin.suse.cz>	<459BFB05.9040608@web.de>
	 <45A03825.9080807@web.de>	<45A2A728.1070404@web.de>
	 <1175029130.5151.6.camel@johannes.berg>	<460B7CAA.4020604@web.de>
	 <4637195E.5050907@web.de> <20070501124733.47c45dd0@logostar.upir.cz>
	 <46371B71.2090508@web.de> <1178017466.3483.20.camel@johannes.berg>
	 <46373B94.4080307@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AoiBU+l+tVIcs8ERd75d"
Date: Tue, 01 May 2007 15:26:48 +0200
Message-Id: <1178026008.4157.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AoiBU+l+tVIcs8ERd75d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-05-01 at 15:07 +0200, Jan Kiszka wrote:
> Johannes Berg wrote:
> > On Tue, 2007-05-01 at 12:50 +0200, Jan Kiszka wrote:
> >=20
> >> Could you point me to the patch(es) in question? I only have 2MBit/s
> >> downlink, so that downloading only the patch would speed things up her=
e.
> >=20
> > http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-dev.git;a=
=3Dcommit;h=3D00a908826e778b39a802013729f7826c2d575360
> >=20
>=20
> Nope, doesn't help. And I wonder how this piece should do so: It just
> performs a sanity check on ifconfig up, right? But the "tc qdisc del"
> runs here _after_ wlan0 got configured.

I never managed to reproduce that part anyway. I hadn't tried removing
the qdisc when the device is down, but when it's up I never managed
to... odd

johannes

--=-AoiBU+l+tVIcs8ERd75d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGN0AW/ETPhpq3jKURAlqiAKC14GgAAi/rCq9H74CGPXJFSSddDwCdGvUR
t9mVK1djxrqQSX2aaoi4KE0=
=RuUi
-----END PGP SIGNATURE-----

--=-AoiBU+l+tVIcs8ERd75d--

