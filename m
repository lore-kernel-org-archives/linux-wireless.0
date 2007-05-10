Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbXEJRRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 13:17:12 -0400
Subject: Re: support for bridging ethernet and 802.11
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jkm@devicescape.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070510171213.GD24712@devicescape.com>
References: <CCA1D7C0-D44A-450D-A76E-DAE792E0CB37@kernel.crashing.org>
	 <1178816781.3806.31.camel@johannes.berg>
	 <20070510171213.GD24712@devicescape.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nKaMrXWUmLmwEwt2cFx0"
Date: Thu, 10 May 2007 19:19:35 +0200
Message-Id: <1178817575.3806.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nKaMrXWUmLmwEwt2cFx0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-10 at 10:12 -0700, Jouni Malinen wrote:

> IEEE 802.11 allows only the own MAC address to be used as the source
> address (addr2) when operating as a non-AP STA in BSS (client in Managed
> mode). In other words, layer 2 bridging does not work properly. AP mode
> and WDS links can be used for bridging without problems, but this will
> of course require the driver to support these.

Ah forgot about that, I had only thought about AP/wired bridging. How
would the prism driver actually do bridging in STA mode though?

johannes

--=-nKaMrXWUmLmwEwt2cFx0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGQ1Qn/ETPhpq3jKURArwUAKCfY8Q+izvfWWc4tskc55j2fD1kMACgmEHd
AqI1LFxfFKq4a0LhZKfiEy8=
=R2cc
-----END PGP SIGNATURE-----

--=-nKaMrXWUmLmwEwt2cFx0--

