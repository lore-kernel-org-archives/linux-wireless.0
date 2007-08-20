Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbXHTLYt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2007 07:24:49 -0400
Subject: Re: [PATCH] Add iwlwifi wireless drivers (resend)
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1187578610.5763.232.camel@debian.sh.intel.com>
References: <1187328536.5763.137.camel@debian.sh.intel.com>
	 <1187349981.23489.162.camel@johannes.berg>
	 <1187578610.5763.232.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qxNhsk/oQdCYBpdP267k"
Date: Mon, 20 Aug 2007 13:22:12 +0200
Message-Id: <1187608932.6090.87.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qxNhsk/oQdCYBpdP267k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-20 at 10:56 +0800, Zhu Yi wrote:
> On Fri, 2007-08-17 at 13:26 +0200, Johannes Berg wrote:
> > I was recently reviewing encryption stuff---can you comment on why you
> > don't allow disabling hardware keys? For proper operation you really
> > should allow that.=20
>=20
> I don't think there is any special reason, just haven't enabled it yet.
> We enable the hwcrypto and find it works good, then we switched to
> enable something else. For the end users, I think they'd always want to
> use hwcrypto if it is supported by the hardware. For developers, I'd
> agree it is useful. I'll add it to the TODO list.

I guess the relevant thing is that if an association is lost then the
key shouldn't be retained in the hardware because it should no longer be
used, yet you don't allow to disable that key.

johannes

--=-qxNhsk/oQdCYBpdP267k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGyXlk/ETPhpq3jKURAg3TAJ4kMHYyX+JIiMphuUh6/7FpguHuYwCfZixJ
g8K3D2UvOX19gFPMR2uw79I=
=OZ9d
-----END PGP SIGNATURE-----

--=-qxNhsk/oQdCYBpdP267k--

