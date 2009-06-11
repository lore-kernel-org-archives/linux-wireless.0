Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:47984 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949AbZFKJ30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 05:29:26 -0400
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id 2963B102241C7
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 11:29:28 +0200 (CEST)
Received: from [88.64.26.191] (helo=[192.168.1.10])
	by smtp07.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.110 #277)
	id 1MEgbA-0004fW-00
	for linux-wireless@vger.kernel.org; Thu, 11 Jun 2009 11:29:28 +0200
Message-ID: <4A30CE70.4050605@web.de>
Date: Thu, 11 Jun 2009 11:29:20 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compat-wireless: ridiculous build speed
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD2F4AB6670EB7EE5F40FB6CF"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD2F4AB6670EB7EE5F40FB6CF
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,

while watching compat-wireless-2009-06-11 doing baby-steps building all
its modules, I wonder what slows this down so horribly. No other
external module build package I know is that slow (I would say *at
least* one order of magnitude slower than normal). Is this really require=
d?

[ Hurray, it's finished! ]

Jan


--------------enigD2F4AB6670EB7EE5F40FB6CF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkowznYACgkQniDOoMHTA+mGrwCfYBfb0XBbKM//M/WgMoe3TDd1
VX0An2yQgJMK7oyEFYpxhPjUq9gEjE2u
=0ur2
-----END PGP SIGNATURE-----

--------------enigD2F4AB6670EB7EE5F40FB6CF--
