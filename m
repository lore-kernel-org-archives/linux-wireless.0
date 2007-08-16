Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758779AbXHPPBI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 11:01:08 -0400
Subject: Re: [PATCH] nl80211: remove VLAN type
From: Johannes Berg <johannes@sipsolutions.net>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1187169518.3960.0.camel@johannes.berg>
References: <1187169518.3960.0.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ePkXdZFPogBeQNKPZl89"
Date: Thu, 16 Aug 2007 17:03:45 +0200
Message-Id: <1187276625.23489.18.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ePkXdZFPogBeQNKPZl89
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 11:18 +0200, Johannes Berg wrote:
> There is no point in trying to handle source MAC address based VLANs in
> the wireless stack, something like "smacvlan" modeled after macvlan
> should be sufficient.

Whoops. I only forgot the use with encryption. Please consider this
patch withdrawn, at least until I see clearer through that crypto issue.

johannes

--=-ePkXdZFPogBeQNKPZl89
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGxGdR/ETPhpq3jKURAoDOAKCKgkzeYX2pR4TFnZ4unHN1tnPbegCfbpT7
XHnXpUetncpeoGCX+XZIwIo=
=ylzQ
-----END PGP SIGNATURE-----

--=-ePkXdZFPogBeQNKPZl89--

