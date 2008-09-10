Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50001 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498AbYIKAAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 20:00:34 -0400
Subject: sta_info->fail_avg
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-H/ZuSkIzQXUEsLwir0PE"
Date: Thu, 11 Sep 2008 01:59:58 +0200
Message-Id: <1221091198.3804.55.camel@johannes.berg> (sfid-20080911_020052_308297_5283E89D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-H/ZuSkIzQXUEsLwir0PE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Luis,

Can you explain what you're using this for in the mesh code? I can't
figure it out, but I do know that neither ath9k's nor Intel's rate
control algorithms ever set it so it'll always be zero.

johannes

--=-H/ZuSkIzQXUEsLwir0PE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyF97AAoJEKVg1VMiehFYfxUP/A4aZKFI5zdQN8xdjz1MgN3O
IsUGjBSYWvkPZ3pq8p1mqDTJlTK/78V4m6MpM2ERgoV97uQ2bmuDrWqNQCCI1PRV
R+rG76SOH0v5mF8KFbnj7Lcg1yHJtCT6iSej9/0nuYys/h47Ss/WqiOUu727G7OP
5cGGpXVx3FRaVN02aqYX5JyD3pTeQ7aLKHISF6hUeOvLrNAyhSQITXUvwoGtFeMY
GJC0rIAHCL/8ACjs8kevj9NXaoEzQcFnYk/Cm0WDJNnOGJBPSNtTFY3wg4TyVDYS
24nScRA8oGy5myNz5057nUWzSl/puxpdgK51kawCI5Pvo8f7mx7QTOgL+BsInNje
X3UD0/SfoDzovBYxtKdzAkE7iCnNHuhQrf2MetoGaET83YN2sygwnC89Xy03E6Ln
XB0SluPnj66IlULf+8WgN8Qzz0tttsUItG/DaNCgZFe1sGfqDP61eq9P0PVEJKPw
BNFhjw2cklWJnIA8Jv8l5T0uLT9ztL9i0bNWq8ekt7ZNgpeonywKt+REhbuL1Cxl
YOs0ODeIUWtJVeJ04/ky0QX+PiMShNgQcKWeKLZXkBqIVJb8CRCNg9EqOM0jdlEJ
3SfvOD/3QWqCpCpQRv955VzuqDbsTxbchbm0NLJO8jdmA3T83W9q1QBYYcvNZnDf
Vt6PSUeBfRt17Ymxiqs3
=yuXg
-----END PGP SIGNATURE-----

--=-H/ZuSkIzQXUEsLwir0PE--

