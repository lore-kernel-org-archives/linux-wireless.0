Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51531 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbXIMHKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 03:10:13 -0400
Subject: Re: [PATCH V4 wireless-dev#pending-upstream] Add iwlwifi wireless   drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189582835.24707.118.camel@debian.sh.intel.com>
References: <1189582835.24707.118.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/UcnwsS12oDv24MxS6bB"
Date: Wed, 12 Sep 2007 21:45:04 +0200
Message-Id: <1189626304.6161.55.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/UcnwsS12oDv24MxS6bB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-09-12 at 15:40 +0800, Zhu Yi wrote:

>  drivers/net/wireless/iwl-3945-rs.c  |  979 ++++
>  drivers/net/wireless/iwl-4965-rs.c  | 2118 ++++++++

Did you change those to subsys_initcall? I can't check right now
(offline), but it's required for proper operation when built-in, or you
need to rely on link order to have the rate control initialised earlier
than the drivers.

johannes

--=-/UcnwsS12oDv24MxS6bB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG6EHA/ETPhpq3jKURAn1rAJ9Co3Q4wUhoyE6wBd/8GmuyaXwUGgCfXsJq
QTya+VoY55cXWiYd7U1i5kM=
=kod1
-----END PGP SIGNATURE-----

--=-/UcnwsS12oDv24MxS6bB--

