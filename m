Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40855 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbYHEL4u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 07:56:50 -0400
Subject: iwl5000 oopses with Linus's tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OhPtDUU8aVSek4fbN3pE"
Date: Tue, 05 Aug 2008 13:56:04 +0200
Message-Id: <1217937364.3603.37.camel@johannes.berg> (sfid-20080805_135654_962503_852A6EC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OhPtDUU8aVSek4fbN3pE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Regardless of whether it is enabled or not, this shouldn't happen:

[  373.387834] iwl4965: uCode did not respond OK.
[  373.387959] iwl4965: Error wrong command queue 0 command id 0x1
[  373.388032] ------------[ cut here ]------------
[  373.388058] kernel BUG at drivers/net/wireless/iwlwifi/iwl-tx.c:1163!
[  373.388102] Oops: Exception in kernel mode, sig: 5 [#1]

This is kernel 2.6.27-rc1-00504-g2b12a4c-dirty

johannes

--=-OhPtDUU8aVSek4fbN3pE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImD/QAAoJEKVg1VMiehFYQGAP/2OTKPbdxIPu9VBQ11cIwRuL
Sx7U42BUE6ijL4CiNCUgZo6vg6khBsbhS6+hqiq3NlmKdR1iuMHdSqNArbpXjSCm
EM2HomyshgVkm4SMvFT6mn6VjI+KHzFYi+fssLsabe2N+vr6NNThhFI2C1HBCFfN
bPIMN/SVCDzeuPCTIbwqvjxuS4Mdg0Iz8EIj/AAepSq2gek1QYXmvjqdu3qA1VzJ
bLGA7DtZUEBr5jiEjemoHyn/WBSzja8Rih7d0jizlJ4IHUD05/4qe7TLvIT2JXb8
hd15wgG4P9QhO6bDxL6idRTNUPd5GG6PG4/gr9QgTwsTMrwfrmoIMfjs9t7tmH9L
O3Rs1+BnJn835BBmzlw5GUKvrllY909vHmmnBIEnl71vSYxuYdqkzGB6tdZz1rDy
R4DxiHlvg0RFZ74qMS++TZ1GIXYjSEFKP1XkO23UvsQjqYOmY6+qGan0p4akutPv
egahB4fPCHh9PE89A17fBDcX5XJXeLu5ojmllcme9JQt5EjwMvt0vKpJcvqUWJ9i
rx9FsRg92R/1JQSRp3XFPJMnpybVqN6g1qgnKTRLsH+OMuFZ6QXx6T3zf0fFFpvs
uQmeyfs7Zx/WXVYv/rEk5IyU02bMuUS9X3BRAAhyXxySOggXSPsGguBSKKDi1mXq
L9/6yveLOVrA33g1TY80
=nWRx
-----END PGP SIGNATURE-----

--=-OhPtDUU8aVSek4fbN3pE--

