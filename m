Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbXFHTMG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 15:12:06 -0400
Subject: Re: [PATCH 6/6] mac80211: Fix one more sparse error
From: Johannes Berg <johannes@sipsolutions.net>
To: yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070608170430.GA17289@mail.intel.com>
References: <20070608170430.GA17289@mail.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HHWHXXExeoUuDTHShNKS"
Date: Fri, 08 Jun 2007 21:12:19 +0200
Message-Id: <1181329939.6533.79.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HHWHXXExeoUuDTHShNKS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-09 at 01:04 +0800, Zhu Yi wrote:
> Fix one more sparse error and comment variable for debugfs_rename TODO.

> @@ -734,7 +734,9 @@ static int netdev_notify(struct notifier_block * nb,
>  			 void *ndev)
>  {
>  	struct net_device *dev =3D ndev;
> +	/* TODO
>  	char buf[10+IFNAMSIZ];
> +	*/

Heh, I actually left that intentionally, but yeah, I guess it's fine.

johannes

--=-HHWHXXExeoUuDTHShNKS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaaoT/ETPhpq3jKURAjkWAKCpvGEVmAqS6SqVkw751YhZyQZ19wCdEwHr
s0+nKGxAZ8RQR4aV26gmci0=
=JDgt
-----END PGP SIGNATURE-----

--=-HHWHXXExeoUuDTHShNKS--

