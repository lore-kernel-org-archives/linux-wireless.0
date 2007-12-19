Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40763 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbXLSPuh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:50:37 -0500
Subject: Re: [PATCH] iwlwifi: proper monitor support
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1198052938-25637-1-git-send-email-yi.zhu@intel.com>
References: <1198052938-25637-1-git-send-email-yi.zhu@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ef44O+3ich1EI2r0EEih"
Date: Wed, 19 Dec 2007 16:50:04 +0100
Message-Id: <1198079405.4747.13.camel@johannes.berg> (sfid-20071219_155040_223486_EE76F94E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ef44O+3ich1EI2r0EEih
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2007-12-19 at 16:28 +0800, Zhu Yi wrote:
> This patch changes the iwlwifi driver to properly support
> monitor interfaces after the filter flags change.
>=20
> The patch is originally created by Johannes Berg for iwl4965. I fixed som=
e
> of the comments and created a similar patch for iwl3945.

Looks good, thanks.


> +	/*
> +	 * We won't receive HT frames in monitor mode. For legacy frames, we do=
 	 * have enough headroom here.
> +	 */

You lost a newline there. Also, I don't think that is true. With
mac80211's virtual interfaces, you can have monitor interfaces while
operating regularly as a sta mode interface.

johannes

--=-ef44O+3ich1EI2r0EEih
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2k9rKVg1VMiehFYAQL3UhAAqL9RXS2+KlBi9PNv6oo7GpXG19k61tdu
4KTncoCiq/L5EKqoTv1XpSPz3C3R84C7ytxibgSzovIxyDgyhX8EF94kGJeBrNr5
9n1iUNkb6TwHBnNWU54yf4jUpmezAV7cOVqh0pl+RSFFuZLFDXFkh7pG+ydlbc5Z
lYI5l9fJ3QkPA1Fsmi0vVNwKIqFoUUhr+30OVcMxYamg48TQmQYPZfx3XCvHN5xv
zwfzc/17nhjYHXToBINxEPTFuaVI4mp+Zw0uC3kBOedP1fP14hTdIkcpjU3SSpim
bvCFFUXX0mf2K4KWyrbUoQKlcVnDhKmQBej8PLYSLPIbMfMKm2iXbJHoozKxdDQ6
ezXtVJs+Dgz1qxYfGUJVoHyegN8QcOt2T3PQVI/RTdhx0qo6cUB/0XRyLRPVQjoX
75f2eKwDslbXqj3MrWPsaPuB1evlitF9UXDA6OHUKZXE4aFluY4uUwePahuIwaSo
Stsv6gj4UKvLw2PG8AhEz/0leC4w8MI47C4hojjzUNpiHTGLWUPzCw8JOCToHyZi
HewRTLxA9eTffR1EB1ZVAXwDDA46qiUXXxybInqbidSO+R816nbZ/+0s0LrvKePw
Xzd+5i9oztYqIMK9lkN6Vs7d/hP1ZbsfCRbFqd4OVyi5DBtwY5WZtZehbtG0n91D
i/MlcAp22q0=
=QGIN
-----END PGP SIGNATURE-----

--=-ef44O+3ich1EI2r0EEih--

