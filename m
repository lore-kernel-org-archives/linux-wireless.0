Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp158.dfw.emailsrvr.com ([67.192.241.158]:41768 "EHLO
	smtp158.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbbBQVlu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2015 16:41:50 -0500
Received: from smtp12.relay.dfw1a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp12.relay.dfw1a.emailsrvr.com (SMTP Server) with ESMTP id 35DF0801E8
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 16:32:23 -0500 (EST)
Received: by smtp12.relay.dfw1a.emailsrvr.com (Authenticated sender: mark-AT-truenorth.nu) with ESMTPSA id 13F37801D0
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2015 16:32:22 -0500 (EST)
From: Mark Gannon <mark@truenorth.nu>
To: linux-wireless@vger.kernel.org
Subject: Proper Method for Accessing Radiotap Functionality
Date: Tue, 17 Feb 2015 16:32:18 -0500
Message-ID: <1700680.ayfkHzEjcQ@scooby> (sfid-20150217_224153_884141_AC51063A)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart3508505.EG4O2BztXh"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart3508505.EG4O2BztXh
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"


Since I'm new to this domain, let me start by thanking you for your pat=
ience.

I've noticed that libpcap based  packet injection software (packetspamm=
er and=20
reaver) are transmitting packets twice with different radiotap headers =
between=20
the original and the duplicate on my box (ath9k).  In order to troubles=
hoot,=20
I'd like to improve control over the  radiotap headers.   Packetspammer=
=20
includes its own version of the relevant files (e.g ieee80211_radiotap.=
h) and=20
reaver does the least possible.  While the relevant header files are in=
cluded=20
with the kernel, they aren't in the linux-headers package on Gentoo or=20=

included anywhere under /usr/include.   I do have nl80211.h file that w=
ill let=20
me query settings, but doesn't understand anything about radiotap. =20

What is the proper way to include querying and generating radiotap head=
ers?

Thanks in advance for your help.

Regards,

Mark Gannon

=2D-=20
You have to accept whatever comes, and the only important thing is that=
 you=20
meet it with the best you have to give.=20

=09=E2=80=94 Eleanor Roosevelt
--nextPart3508505.EG4O2BztXh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlTjs2YACgkQcDtGkR4u3fZfXgCgg9CXz3NnnMxW1qou9nyq8cHg
NbcAn1kLDuP7fnFCIllMPwNmTLnnOqLb
=VDJo
-----END PGP SIGNATURE-----

--nextPart3508505.EG4O2BztXh--

