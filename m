Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35086 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031348AbXDZRIl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 13:08:41 -0400
Subject: Re: [PATCH 9/9] net_device: dont include wext bits if not required
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070426165304.GC22576@bougret.hpl.hp.com>
References: <20070424180732.371620000@sipsolutions.net>
	 <20070424180850.595757000@sipsolutions.net>
	 <20070426165304.GC22576@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U72GqYfHBC4TXp6xbtIo"
Date: Thu, 26 Apr 2007 19:08:10 +0200
Message-Id: <1177607290.6814.101.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-U72GqYfHBC4TXp6xbtIo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-26 at 09:53 -0700, Jean Tourrilhes wrote:

> 	I personally would not do that. Having conditional fields in
> "struct net_device" is very bad, it's a sure way to crash on modules
> in some cases. If I remember well, Jeff Garzik has been fighting those
> over the years.

I'm fine with posting a patch the other way around (i.e. removing the
conditional from wireless-dev) just wanted to float this. It originally
made much more sense anyway when I had wanted to do cfg80211/wext
compatibility in a different way. Now it looks like it'll just depend on
wext.

johannes

--=-U72GqYfHBC4TXp6xbtIo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMNx6/ETPhpq3jKURAvp0AJ9ScKHYVZdjZNLUz+bntJJg9BT/FwCeO/OD
cHyjpDeXarVTzfX2WS/mY7c=
=0UFp
-----END PGP SIGNATURE-----

--=-U72GqYfHBC4TXp6xbtIo--

