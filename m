Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758634AbYDKMQx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Apr 2008 08:16:53 -0400
Subject: RE: iwlwifi integer overflow warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: Meelis Roos <mroos@linux.ee>, linux-wireless@vger.kernel.org,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <D936D925018D154694D8A362EEB0892004289DB4@orsmsx416.amr.corp.intel.com>
References: <Pine.SOC.4.64.0804101121160.13294@math.ut.ee>
	 <D936D925018D154694D8A362EEB0892004289DB4@orsmsx416.amr.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UhVfTv7A8+dNb8Ez/wFt"
Date: Fri, 11 Apr 2008 14:16:44 +0200
Message-Id: <1207916204.13354.63.camel@johannes.berg> (sfid-20080411_131729_423981_9B3B25E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UhVfTv7A8+dNb8Ez/wFt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > drivers/net/wireless/iwlwifi/iwl3945-base.c: In function
> > 'iwl3945_enqueue_hcmd':
> > drivers/net/wireless/iwlwifi/iwl3945-base.c:719: warning: integer
> > overflow in expression drivers/net/wireless/iwlwifi/iwl-3945.c: In
> > function 'iwl3945_add_radiotap':
> > drivers/net/wireless/iwlwifi/iwl-3945.c:326: warning: integer
> > overflow in expression drivers/net/wireless/iwlwifi/iwl4965-base.c:
> > In function 'iwl4965_enqueue_hcmd':
> > drivers/net/wireless/iwlwifi/iwl4965-base.c:723: warning: integer
> > overflow in expression drivers/net/wireless/iwlwifi/iwl-4965.c: In
> > function 'iwl4965_add_radiotap':
> > drivers/net/wireless/iwlwifi/iwl-4965.c:3617: warning: integer
> > overflow in expression  =20
> >=20
>=20
> (adding Johannes and John)
>=20
> These problems have been fixed by Johannes with his patch "iwlwifi:fix
> some warnings". If this is an issue in 2.6.25 then that kernel may take
> this patch to address the problem.

That patch never was applied though and Tomas had reservations. I didn't
have time to look at it again.

johannes

--=-UhVfTv7A8+dNb8Ez/wFt
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/9WqqVg1VMiehFYAQLunQ//bjQ7rXTt5WFcYonvdwkhSB2xRa9I1GXD
0IZ78wMQ3Vt4CsAUVr8MI6MmWV9XJ/dgj/a2VKShdtZCOcIkGJN9dXNsuSvyE5g2
VyhHWJ6iWyC23GNsL69UjIhCdPuve0ypLxYuJPxMt2EfkPLdCWLR67fMc7O0YtIW
cxciHb9Y0JS2ahsHFwUqFRwu1FrZM/aj8RE9X++xtUsEhakFpwVk/ewbmw0qu6V1
fgZYMhGxkV5bJpGtCQ14jKZHJhdrA36oRp2HialY1uuZotugHTsRSf/2EFDXyYj3
gVlp9WuEEMCzwGpWNgDm4EDtaQh1lfoaZJScYvs8EKWlUcuqpdPkatyx+bjmjll1
kU/4J5vXyzA6spyIyZYx1ub3w0rtZrzSELXXpvgtSd4qz2ByiPnYyv1g0ijtKRAc
oMIjlcuKjFZzeLUrs92FYAhspy50iBxF3U7np81J3BnJJHsQ5hHfwpmObuL9dYBV
tzA8s2DUQTww36rxCZqxZ4v+LlfHXaXSPFLcbW/vUK/U3UURizi9AudFVbXfjubZ
3K0hh/4/EtkydUO90waXMi5ouKzVdi3/CBcuaBqb3mc7M3QbbMWpTSPU1l4NDbLj
x3my0/UBmQ/jLO1cBu0Rv22mOlG+NERaa/KIzZ+d8AitLYP3KGojmXrchBw9UDJk
StGsxqLVZCA=
=i2zx
-----END PGP SIGNATURE-----

--=-UhVfTv7A8+dNb8Ez/wFt--

