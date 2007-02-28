Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXB1QQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:16:42 -0500
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281507.13953.IvDoorn@gmail.com>
References: <200702281507.13953.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-o6e/Xrr7YhyhTf0jva9q"
Date: Wed, 28 Feb 2007 17:16:20 +0100
Message-Id: <1172679380.5015.32.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o6e/Xrr7YhyhTf0jva9q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 15:07 +0100, Ivo van Doorn wrote:

> +#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2, 6, 19)
> +	file->private_data =3D inode->i_private;
> +#else
> +	file->private_data =3D inode->u.generic_ip;
> +#endif

Bzzt.

johannes

--=-o6e/Xrr7YhyhTf0jva9q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5arT/ETPhpq3jKURAt0RAKCq36Pp2IvHPrcWkxsUqUILJk8h+gCfVgtl
amSH6saha5E1wVglj2aoqY8=
=cn0G
-----END PGP SIGNATURE-----

--=-o6e/Xrr7YhyhTf0jva9q--

