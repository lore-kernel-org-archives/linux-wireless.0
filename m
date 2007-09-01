Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52181 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbXIAJPm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:15:42 -0400
Subject: Re: [PATCH 18/35] Only cancel correct timeouts for Auth and Assoc  replies
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070901043557.2498.6553.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
	 <20070901043557.2498.6553.stgit@dv.roinet.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rWgoFwroP/VGHk0EbXkr"
Date: Sat, 01 Sep 2007 11:17:08 +0200
Message-Id: <1188638228.7585.124.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rWgoFwroP/VGHk0EbXkr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-01 at 00:35 -0400, Pavel Roskin wrote:
> Don't cancel all delayed works indiscriminately.  In case of
> at76_rx_mgmt_auth(), cancel the timeout regardless of the status of the
> reply, as long as the reply is for us.

Out of curiosity, why are you cleaning up code that needs to be deleted
anyhow? The way I see it, the driver ought to be be ported to mac80211,
no? It seems to ship with an in-driver softmac.

johannes

--=-rWgoFwroP/VGHk0EbXkr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG2S4U/ETPhpq3jKURAm0iAKCjZqXq5XKJLCPVto2vSdsZl+Im9gCbByHH
5qqyUPvMt7EqdxxVMytrpVE=
=Cwpk
-----END PGP SIGNATURE-----

--=-rWgoFwroP/VGHk0EbXkr--

