Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbZEUT5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 15:57:04 -0400
Subject: Re: rfkill v9: fixes and thinkpad-acpi conversion
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
References: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KPPjEbWuzrmUiAlAunbP"
Date: Thu, 21 May 2009 21:57:02 +0200
Message-Id: <1242935822.4212.17.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KPPjEbWuzrmUiAlAunbP
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-21 at 00:04 -0300, Henrique de Moraes Holschuh wrote:

> The core might have some bugs left, too.  It seems to ignore set_sw_state
> changes, I can't see it reflected on rfkill/state, and it is _not_ becaus=
e
> it is trying to set it back to whatever it wanted properly (or I'd get
> calls to the set_block hook).  Maybe it is something in my thinkpad-acpi
> conversion, though.

Yeah, I just found a bug with the PREV bit handling. Fixed in the
version that's on my homepage now.

johannes

--=-KPPjEbWuzrmUiAlAunbP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKFbIJAAoJEODzc/N7+Qma2H4P/0ZUHxcW5i0w1XvSzYZdMUuT
RKCxTfr2424U3Wz7aAftK8qNTt/kGWA6pmaRXS7prXOyfr1pu/sZFvMHh+lLG/2P
TpPMbYpw+/RveOc04AyB+y+Eto8Ws1P/XehglAKvlqrDXFGVUsCmn1Uh9foaCx7n
Tefjhl+aR5GOrK8bQVn2YJFPHrMT/cU3lNqa/8GgsdGRN/CDAOgDmtNCotKTGjhp
GTvorrDtFGSlvrgri+EvwdftqUw4G07gkuNuAcjXmv3PlGeTW9frYsUKuLMy26+F
5YuzFofBUYpUSedgvv67byQtYj3uFRB0jlZkgiAOPg2r/p/AB/ILbwv5F4puPYlf
d4DuK14aVaSXtITNuApXjpOSzmMMbbuHOwUJBDC7Q6BAJVcUo75oE6aUScu+bjsP
LHAoNJl6S9Mj4QrLm70THgU/eAQVBwz435M+aFg8YETHDuHdT/6DARTBu6CU4s7a
j47zyyBJnkehRUeOjnO+UUHhcTcaAtQ6fgM6tPk/MrfQ3To3gvlXeCtCiOxkuT4l
QFMWeH8l9AyNCm8XBWYHizfjWewubc/h7HNKZBJIE+FKVnTteoRDFGGDZqK4wqha
Hz9mHj05DLnLu5Im1UrGO/r5bsnPl055DUy6TF8YC6dAZmvJTONn4HGjoSEKWbOR
QN1zCcc96N2LEmLgtyR3
=20Gq
-----END PGP SIGNATURE-----

--=-KPPjEbWuzrmUiAlAunbP--

