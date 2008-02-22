Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441AbYBVQXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:23:51 -0500
Subject: Re: [PATCH 04/13 v2] o11s: added mesh.h, mesh function and data
	structures definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be7732.20588c0a.0360.ffff8f1c@mx.google.com> (sfid-20080222_071816_353396_9A4A9995)
References: <47be7732.20588c0a.0360.ffff8f1c@mx.google.com>
	 (sfid-20080222_071816_353396_9A4A9995)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3TO3NJIrUG8ms7Vu2bDP"
Date: Fri, 22 Feb 2008 17:23:44 +0100
Message-Id: <1203697425.7082.70.camel@johannes.berg> (sfid-20080222_162402_634111_0F5EFCF5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3TO3NJIrUG8ms7Vu2bDP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-02-21 at 20:08 -0800, Luis Carlos Cobo wrote:
>=20
> + *
> + * The combination of dst and dev is unique in the mesh path table. A re=
ference
> + * to the next_hop sta will be kept and in case this sta is removed, the
> + * mesh_path structure must be also removed or substitued in a rcu safe =
way
> + */

I don't think I fully understand that. The mesh path points to a sta
structure, so when that sta is removed, the corresponding mesh path must
also be deleted. I think I need to look closer at where that is done to
understand how it could be substituted.

johannes

--=-3TO3NJIrUG8ms7Vu2bDP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR773D6Vg1VMiehFYAQICLxAAlkUKwaoXBMYjJVLPc2Te1euT4hCjIsEa
vdxcvJVZJMBucfpe/woTF8pwXkhVvnJUByA0+20cYtJc9D4BpYq3t3FWli02lS5d
i+UO1J/6OqGMFyUGo/hRl+XwWwTGi4eeHRk8BoB0nG/j4W3139tFaOVyqPRM2oEj
Jh2U/GAX+pEaGeiISLqLy1YIRxhFV+Vqn5c70oqVCcY7S+pudVaMD2E8aegtyEew
ILlWqBFwnSPotUw9lIkFZzy4DFUUqz5Kav4OYc1dXosCa/flYY4y1eE6CiQ3+xZw
cCUiOxnHxhzfGFFPuuxKePQTMtAr6Ymrw3CJCTiNB+APiaTqVsn1s/lD35UuQIah
NuKxMLyfGWArLYAufr1D08XrgUUL3AqdCZ4qcVvpAFMPD01tgrVMaqUH+fPRwQuv
d0i0Rsr4U6gFdwpMNpmCvv53zy+pD/LyQBpWjMUvChFVkw/00dB0t/C03CmFTD6T
CNlUMwYaRfNXSMFxI5SJ4T0I/aV2xEHfHGAZp5o8MYcEHXS12SO5EyX5STvD4W6b
OZRXX5NtEASXzSeruX7KjCpA5NWnVtzo+8mBu9/JbYXstQIcFDZE+UrJMbIxAsVI
VLeT2j0EC4J00mKShl31QtKjloe8Do1oLuu5Lme90ux+9SetO8O4lSNuuh4wlxlV
c0fyovvQQY4=
=EYZs
-----END PGP SIGNATURE-----

--=-3TO3NJIrUG8ms7Vu2bDP--

