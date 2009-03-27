Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbZC0Nkp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 09:40:45 -0400
Subject: rfkill get_state
From: Johannes Berg <johannes@sipsolutions.net>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Matthew Garrett <mjg@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-GPCCFoLx0Ddx1aYuzeB6"
Date: Fri, 27 Mar 2009 14:40:10 +0100
Message-Id: <1238161210.4452.8.camel@johannes.local> (sfid-20090327_144049_089494_74C98225)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-GPCCFoLx0Ddx1aYuzeB6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

When you implement get_state but don't do force_state, how does
get_state ever get called?

It seems to me it'll only get called=20
 * when you read sysfs
 * on resume
 * on epo

How do we ever react to a button press then to make a uevent?

johannes

--=-GPCCFoLx0Ddx1aYuzeB6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJzNc4AAoJEKVg1VMiehFYu4MQAKXTMSpl5hEpT1MLn2nifY5k
qCylOtQ9LKYBYa/GiVI3CMhVgFLfbwvMKTejsRNKACkQlX3PPgAScd42LYpbhCqQ
BRSlB8VoO9I3teFwKSN2MnLAw76Kn+OI6NzjtS30OjpErSwp+CX1cy4+aSv4tIwp
GzIvLul5I6Zrd3gv03gkpluovzhqvJiS0ohc0hVDqTomFi2EiP3rUOi7pfjzj00h
RPNCBMERl0NAulZOyS1UdcNwU9OrY4bljcEUWIM3tT45ritaRDFkYMCuRue0vmn8
6vSpMgAKpEocJMo28deFlBspUfFVuE62mo7YioFD7e+P6aCVRqXN8arZAbhCU4hQ
AHsTigcHLmh79bMgk/dPDfazHbHadMktNnEGZwwt7CaabdZDjuCjluKZp2l1ZsPv
MTBMnO4oJLH7WuHw9wkRC3clEusBIR9FnJQ71YVylCBz26rSdM4L3T/3Riu+5rDB
hG0NZLn5oaiPzC++NXvfmp0EhATCMxFCFmDM0WlmsYNgJCytadxEBzoV9WSMDavS
HFf7iHTHlXNBVjmiQor2CoG4p3H5YNvlbpEa0j/eZh0kFRpqGD1a/NJD4BD6vlVV
kJRb57pR4vyxG5zA7YuvP8lBpJ04jYooBsNRDa8s0bbnchRrszcsVQvRL0Xw/nLT
1HWF47r76aTV3brlIR28
=Nzlz
-----END PGP SIGNATURE-----

--=-GPCCFoLx0Ddx1aYuzeB6--

