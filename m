Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58633 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965511AbXCATHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 14:07:51 -0500
Subject: Re: [PATCH] mac80211: move PHY things to debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1172775866.3381.7.camel@johannes.berg>
References: <1172774065.3381.3.camel@johannes.berg>
	 <45E72174.9060104@warmcat.com>  <1172775866.3381.7.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DQQosq90CIXwBCNQnKwQ"
Date: Thu, 01 Mar 2007 20:07:29 +0100
Message-Id: <1172776049.3381.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DQQosq90CIXwBCNQnKwQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-01 at 20:04 +0100, Johannes Berg wrote:

> When Greg fixes sysfs, the real way would be to follow the symlink

Oh and of course if you don't want to use sysfs then you can always use
nl80211.

johannes

--=-DQQosq90CIXwBCNQnKwQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5yRw/ETPhpq3jKURAp+eAJ9Wd3Jj1s+HHg+KsOCHynAwyQh6CACfZ2kN
+FSW41L4v5FxySiJg97TK/w=
=VqLj
-----END PGP SIGNATURE-----

--=-DQQosq90CIXwBCNQnKwQ--

