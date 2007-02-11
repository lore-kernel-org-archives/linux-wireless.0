Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59815 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932695AbXBKNWE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Feb 2007 08:22:04 -0500
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
From: Johannes Berg <johannes@sipsolutions.net>
To: "Hesse, Christian" <mail@earthworm.de>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, netdev@vger.kernel.org
In-Reply-To: <200702101424.00156.mail@earthworm.de>
References: <45CCE3CA.4050904@linux.intel.com>
	 <200702101424.00156.mail@earthworm.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-06LbLQ20kGESY9B6O7wV"
Date: Sun, 11 Feb 2007 14:19:30 +0100
Message-Id: <1171199971.5032.3.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-06LbLQ20kGESY9B6O7wV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-02-10 at 14:23 +0100, Hesse, Christian wrote:

> The driver generates two network devices. The second one is for promiciou=
s=20
> mode? Is there any chance to disable the interface?

The second one is the so-called "master" interface which is used for QoS
stuff. We're working on hiding it until a better solution for QoS
evolves (which has been a plan for a while.)

johannes

--=-06LbLQ20kGESY9B6O7wV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBFzxfi/ETPhpq3jKURAhMhAKCAZLu/eox9t3uL2GH/zgyzhBOMOACgiVQ8
L7tRUxa47dfqobyUfishKk0=
=lVPK
-----END PGP SIGNATURE-----

--=-06LbLQ20kGESY9B6O7wV--

