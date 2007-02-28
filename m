Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbXB1PjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:39:23 -0500
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702281634.47330.IvDoorn@gmail.com>
References: <200702281507.13004.IvDoorn@gmail.com>
	 <200702281612.51383.IvDoorn@gmail.com>
	 <1172676338.5015.20.camel@johannes.berg>
	 <200702281634.47330.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aTraTIQt/PJYJxXHSxQ/"
Date: Wed, 28 Feb 2007 16:39:00 +0100
Message-Id: <1172677140.5015.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aTraTIQt/PJYJxXHSxQ/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 16:34 +0100, Ivo van Doorn wrote:

> Nope, in my test it will show up in the menu. The help text has no influe=
nce.
> When the help text is not specified, selecting help on that entry will di=
splay
> "There is no help available for this kernel option." followed by the regu=
lar
> dependency information for that option.

I think that's only true if other things depend on it as opposed to
selecting it. I know that cfg80211 used to not show up in Kconfig (and
that was intentional)

Let me try this.

johannes

--=-aTraTIQt/PJYJxXHSxQ/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5aIU/ETPhpq3jKURAknYAJ9KgrGQ08DdGS3dNqVGZE3e6EEu2QCfUR+7
rZ3DGRCfV54ezxIxwuUKz84=
=kqn8
-----END PGP SIGNATURE-----

--=-aTraTIQt/PJYJxXHSxQ/--

