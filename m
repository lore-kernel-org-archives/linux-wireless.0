Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933648AbXDBQwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 12:52:46 -0400
Subject: Re: [PATCH 2.6] WE-22 : prevent information leak on 64 bit
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070323003116.GC2712@bougret.hpl.hp.com>
References: <20070323003116.GC2712@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vi/IJ/Tn2OuIVJYPU12I"
Date: Mon, 02 Apr 2007 12:06:50 +0200
Message-Id: <1175508410.23438.75.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vi/IJ/Tn2OuIVJYPU12I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> 	Johannes Berg discovered that kernel space was leaking to
> userspace on 64 bit platform. He made a first patch to fix that. This
> is an improved version of his patch.
> 	This was tested on 2.6.21-rc4. Would you mind pushing that
> upstream ?

Just FYI. This patch applies with rejects in net/core/rtnetlink.c and
net/core/wireless.c to wireless-dev. The changes in those two files can
be ignored completely since they affect only the removed
wext-over-netlink interface.

johannes

--=-vi/IJ/Tn2OuIVJYPU12I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGENW6/ETPhpq3jKURAsECAJ0SOQQdMQtp67rYw8OmeyOyBP75gwCdGXCb
Nhh0m13CIPHZmMcUqARyix0=
=+4jc
-----END PGP SIGNATURE-----

--=-vi/IJ/Tn2OuIVJYPU12I--

