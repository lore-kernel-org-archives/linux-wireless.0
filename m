Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39178 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbXJ2IGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 04:06:08 -0400
Subject: Re: [PATCH] iwlwifi: select proper rate control algorithm
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1193625602.3069.489.camel@debian.sh.intel.com>
References: <1193579616.5197.13.camel@johannes.berg>
	 <1193625602.3069.489.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hWRoeo5XwgPxRBOdCHbx"
Date: Mon, 29 Oct 2007 09:07:21 +0100
Message-Id: <1193645241.5197.27.camel@johannes.berg> (sfid-20071029_080618_460263_E36C0AAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hWRoeo5XwgPxRBOdCHbx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > +       hw->rate_control_algorithm =3D "iwl-3945-rs";
> > +
>=20
> Which mac80211.h has this field added? wireless-2.6 doesn't seem to have
> this support yet.

Right, I sent a patch a few minutes before this one that adds it.

johannes

--=-hWRoeo5XwgPxRBOdCHbx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyWUuKVg1VMiehFYAQKQvQ//T0Hgs4cUg2vNXemmAjPlkwtAQ3mAkrzy
lk4YewZA2mWNVSCNUhMbt2XTfcHsGpu0/TDcN6Bkx393eakDTTcuMG860s4UgjgB
1e6CPATrtXrqYN7LOVVLGK2MjaBRLvD8/wwXXScWMowRlpWHRSXvBY+V6e6aVHgW
L9y/lojUUuaBQxiz4ACxxdwqpKASTqUa9WGuYDFDq8gVgELOpghkIcxcNE/lbQ3f
OZ/M7t4PkLjUyE1kLTYZyg6EEAadEBpS6QS0nIM6Oa2ILOZvQZsJNyCPqtt6ClEq
7pYxNZns2jmYPAHvsQe3ASWwGTI3e/6BjhdPosWcfV2pVDK/ckavJpFl97lT+/Lz
PsZeyAY+06InZlC3JUn2SNjKv9KFCjbkmSCyBIuOp2eg6gRGJFdiJYQv2pEsw7oT
bNZ/K6S35I0lrWnZGiAVYG+kkuSGn6ylKgFqi+9+JOOywOywxWPGoIxRpW2kp2F1
gWULCrz9RhiTj6CHNRfDUXgur7LhPB1jOOpsbQvLXw3P8v/co317JU1PWdzrKr2/
HmPfeAw+y6oVgIaxZFrBANOHE14rfPeUTryMPyKmXP3lZgFVPLip2Dhw0aF+j8sn
Y8oPejLxL1g02CtBmLH56NmQaajOBrg14B1bDFt3bm154AC+gKEzK0YZ6QGsgRgu
dpqF+ZslBm4=
=CqLY
-----END PGP SIGNATURE-----

--=-hWRoeo5XwgPxRBOdCHbx--

