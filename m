Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57830 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbXH0Ks2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2007 06:48:28 -0400
Subject: Re: [RFC 09/11] mac80211, iwlwifi: remove atheros turbo modes
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1188175678.13078.124.camel@debian.sh.intel.com>
References: <20070823164500.998912000@sipsolutions.net>
	 <20070823164524.799041000@sipsolutions.net>
	 <1187942429.13078.104.camel@debian.sh.intel.com>
	 <1187950192.24933.7.camel@johannes.berg>
	 <1188175678.13078.124.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1nlV8UU4Qz+usAfnXYJt"
Date: Mon, 27 Aug 2007 12:49:36 +0200
Message-Id: <1188211776.6756.13.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1nlV8UU4Qz+usAfnXYJt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-27 at 08:47 +0800, Zhu Yi wrote:

> We used to "borrow" the TURBO mode to distinguish between normal G mode
> and 11N G mode (same for A and 11N A). We are now switching to different
> approach (add ht_info to mac80211 for 11N), so it is not needed any
> more. I'll submit a new patch to reflesh the change together with some
> other changes we made for the driver during this period.

Great, thanks.

johannes

--=-1nlV8UU4Qz+usAfnXYJt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0qxA/ETPhpq3jKURAqWgAJ9COUG/6if5VY6ObDShzV62JVDmmwCgryNN
TY2ImB4wDZG6VOmcwGOGXuo=
=6JQ6
-----END PGP SIGNATURE-----

--=-1nlV8UU4Qz+usAfnXYJt--

