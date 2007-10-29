Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from duky.chevillot.net ([213.41.185.64]:37922 "EHLO
	gaia.chevillot.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653AbXJ2Qar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 12:30:47 -0400
Date: Mon, 29 Oct 2007 17:30:45 +0100
From: Guillaume Chevillot <guillaume@chevillot.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Guillaume Chevillot <guillaume@chevillot.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	hostap <hostap@shmoo.com>, Chuck Tuffli <CTuffli@dspg.com>,
	Alexander Kotelnikov <sacha@myxomop.com>
Subject: Re: [FYI] hostapd state with mac80211 on linux
Message-ID: <20071029163045.GA6000@chevillot.net> (sfid-20071029_163120_837055_E9E84146)
References: <1193338400.4406.4.camel@johannes.berg> <20071029125541.GA4304@chevillot.net> <1193674172.5197.73.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
In-Reply-To: <1193674172.5197.73.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Which patches? They currently all apply against the version of linux-2.6
> I'm running. Or are you talking about hostapd?
No I'm talking of kernel patches. The 008 patch for example does not
fail to hunk automatically on git kernel source (tested on a friday, on
the main git kernel tree). It applies on 2.6.21-rc1 (I think not tested)
but not on downloaded from git kernel tree (the same probably with
2.6.21-rc1-git5)

So your patches are OK but won't be for the rc2 I presume.

Guillaume

--=20
Guillaume Chevillot

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJgq1PULMpKkMZuMRAktCAKDqDgPWAdO8zuzdBgz8PZ82hAFr5ACZAca3
jNRae0mf33PKl59ZqR29TCk=
=CxfC
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
