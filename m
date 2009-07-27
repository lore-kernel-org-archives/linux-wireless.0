Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44771 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbZG0IzL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 04:55:11 -0400
Subject: wext net-next-2.6 work
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-q5+pIjxgfNSZng+/v9ex"
Date: Mon, 27 Jul 2009 10:55:14 +0200
Message-Id: <1248684914.19945.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-q5+pIjxgfNSZng+/v9ex
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

John,

I don't know how much trouble it is, but if it's not a problem I would
appreciate if you could cherry-pick a few patches from net-next-2.6 into
wireless-testing -- just in case somebody wants to test with 32-bit
userland on 64-bit.

The relevant patches are=20

commit b333b3d22822cf9b295990866798e9239c9dee72
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Jun 24 01:34:48 2009 +0000

    wireless extensions: make netns aware

commit 4f45b2cd4e78b5e49d7d41548345b879d3fdfeae
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Jun 24 01:34:49 2009 +0000

    wext: optimise, comment and fix event sending

commit 1dacc76d0014a034b8aca14237c127d7c19d7726
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Wed Jul 1 11:26:02 2009 +0000

    net/compat/wext: send different messages to compat tasks

in this order. I had to send them to net-next-2.6, as you probably
remember, because touching lots of other code in the third patch, but
semantically I think they should be part of wireless-testing since they
mostly affect wireless.

johannes

--=-q5+pIjxgfNSZng+/v9ex
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbWtqAAoJEODzc/N7+Qma2pEQAL55/iU4a3A3JJNX6Df7k6AV
LEloKGJeSqJcWPSY74yiqC08MB6s0ELPMbkRfDMkGVSO3T0LqwI9dfq4ppE1PQHS
ue+4t53EjEn5234PqPjsWIvI4JG3MILSqnvsQHiN8+Rhdv+BsVwjmaSoCpV2YoLB
v03zPG81+T9fv52cpd1xD7Pc+CIUzjBEoERPaum6eUPuuL8OCEuqx5HR181bt0QR
ong9EdgIcH33q5+693VT+9N1nmLtaheNkKbAbCcLTIuaV+rb8aIC4HIZ/6F7wnhE
k4mtuQNvuSuiW7LrM8IVEpW6BYdklTF5NkVpk6E6TOUz6rHxHlhkaTbp2lTX/CQm
jMMfbAeTOZsgIai4H6CpIFt4zqWlLu690c4TSllJJ53wQg3/pHdSrXTS7RRLByp6
casYJhL//dojExS8VvRgDQ4Iog3SL3x2VP9UkT870d2hj8dmxEB4i9DMuzak6D8L
mp6ZD3x7egHYe94+1roZL6EqXh4nYiu8ESsJbi5K6v3B9CTBx5nF+hTgtNKWFYDq
tSe+Etr/2Of7xUP9vvWV7/spsuC7qhgKLHlrk6Z4BQOGHQRNrdaJG29gM/KeLY5V
Yum5j5Nzw6Xi2uDjovNdlqX8+kNjzHixEVOrc2rNqyf1Y8f2mRHACdS4qMYcCB9x
wkb60tr1KKOCQZDXQV34
=hIvL
-----END PGP SIGNATURE-----

--=-q5+pIjxgfNSZng+/v9ex--

