Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42477 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbXBWLZY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 06:25:24 -0500
Subject: Re: [PATCH] create net/wireless/Kconfig and make nl80211 optional
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45DDF22D.9000003@linux.intel.com>
References: <45DDF22D.9000003@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Q+8xmOlo5gzwDPwNWXGL"
Date: Fri, 23 Feb 2007 12:25:14 +0100
Message-Id: <1172229914.3870.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q+8xmOlo5gzwDPwNWXGL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-22 at 11:42 -0800, James Ketrenos wrote:
> Move the wireless Kconfig options into their own wireless/Kconfig and
> add a CONFIG_NL80211 configuration option to allow nl80211 support to be
> optionally included (default =3Dy)

Ack, but we'll need to modify core.h to stub out nl80211_init() and
nl80211_exit() in case nl80211 isn't compiled in. The reason this worked
for you is that I forgot to hook up nl80211 completely ;)

Do you want me to take care of that?`

Thanks,
johannes


--=-Q+8xmOlo5gzwDPwNWXGL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF3s8a/ETPhpq3jKURAvzrAKCu+/G/FVLOYOFJGHn2iETRg5rQZACgkaea
+fm0aBxLcKkF14hx/4QHikg=
=gxqE
-----END PGP SIGNATURE-----

--=-Q+8xmOlo5gzwDPwNWXGL--

