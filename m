Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbYETQF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 12:05:59 -0400
Subject: Re: iwlwifi injection bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <69e28c910805200839k7426833auf96faef99dc49d9b@mail.gmail.com> (sfid-20080520_173934_457642_EAACBD5D)
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
	 <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
	 <1ba2fa240805200641j4ccc1de4r5572e1321394a526@mail.gmail.com>
	 <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com>
	 <1211293631.6252.98.camel@johannes.berg>
	 <69e28c910805200758j72281d34kfaa244e9bbdd8451@mail.gmail.com>
	 <1211296710.6252.99.camel@johannes.berg>
	 <69e28c910805200839k7426833auf96faef99dc49d9b@mail.gmail.com>
	 (sfid-20080520_173934_457642_EAACBD5D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9Vsc+7bsma1m7UBhSY9M"
Date: Tue, 20 May 2008 18:04:59 +0200
Message-Id: <1211299499.6252.104.camel@johannes.berg> (sfid-20080520_180605_939696_58E1E3C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9Vsc+7bsma1m7UBhSY9M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> OK! I have also determined that my IWL_INVALID_STATION change is
> unnecessary, as injected packets do have a valid station ID (they are
> marked as broadcast by iwl*9*5_get_sta_id). The IWL_INVALID_STATION
> change was a hack I put in earlier, before finding the real problems
> in iwl*9*5_get_sta_id and iwl*9*5_mac_tx.

Now you only need to read Documentation/SubmittingPatches and not
linewrap your patches ;)

johannes

--=-9Vsc+7bsma1m7UBhSY9M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASDL2qaVg1VMiehFYAQKfeBAAvuOnaqrbwJmWx0Cuy7OH25eSvmU7NrM/
xBGK1sMtaY52jsicCsg1+u+ucbT1Qm3/+XyWVRs89NMm1eEg7MilmLLZKnIH5Tjm
SRYRHNU/xAU2c8+nFI2yWU+rGeHk3yFjgs92RSbF1PbjnMqjJtDZI2VdC79L1znw
l4yzhGlHZ8mkZlWlTxLfVeNbKDASaZIH5xCxqUfZdL3D05VQA7o9QFpmk8owAlBg
AIUiH6A0WrPOyztZkznHz2JvLCCcN5hqMJPciuTPUmE7gplKOe8Sq5e4JWcPWsf9
KoT0eajLXfTqsjbU1XmvYxIaCMgP+aMyegd+LhYLZ/7MZdYN8AWP83psHTSbSJf3
Tszqy7Tn7D8Va95kpXRSE8px3ElbjirwA5XInKEL6cVi6pzzioKHAvtgkakFgHER
n4dvgfolohom/XjjsIhFe4VyyIERtcRopPeMdpOK0kYAKmvVh11F4AVbw9jN856n
sWab4d0PMhmC64ssE1vHfQAJM6wp4O1M0svEN3514kPAMocvUt287NV5F4pV+08T
awnFkMw0A0FcyoIuGddKf5y8RfQ4XVX2/CLSSwti/hiO5MNn5y9NjAPZEUopa+m5
Mr8eztuBKAEc7yW+s5CkG84iWjNZRoCCoAbGSspEUydx6N2Vy3nIKXfSVp80gwLb
Wr8Z/TiDAK4=
=RNdP
-----END PGP SIGNATURE-----

--=-9Vsc+7bsma1m7UBhSY9M--

