Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:36718 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764817AbXKPLxY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 06:53:24 -0500
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org, hiertz <hiertz@ieee.org>
In-Reply-To: <473516ee.26d7720a.3f57.ffff8233@mx.google.com> (sfid-20071110_022658_985099_309C7497)
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>
	 (sfid-20071110_022658_985099_309C7497)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tGQy7isYhPVWCU0vCeqT"
Date: Fri, 16 Nov 2007 01:13:12 +0100
Message-Id: <1195171992.8147.81.camel@johannes.berg> (sfid-20071116_115339_976424_EF11BF8B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tGQy7isYhPVWCU0vCeqT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-09 at 17:22 -0800, Luis Carlos Cobo wrote:
> This commit introduces mesh interface support for the mac80211 stack. It
> provides support for pre-802.11s frame format, static unicast forwarding,=
 mesh
> beaconing, mesh statistics through debugfs.

Btw. I just reviewed draft 1.0 (currently have no access to later ones)
and it talks a lot about probe responses but never when to send them. Is
this clarified later and should it be implemented here? Or is that part
of the "mesh AP" stuff that is removed?

johannes

--=-tGQy7isYhPVWCU0vCeqT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzzgl6Vg1VMiehFYAQLesBAAn4hjirNMhWCul3WQaWiAYJ4xLTvEY3P6
BTINSCEb0JYeCyCz+rdBMipm3Vd/ZiX0dWPI7lhn/41JbSIB0DzlyAkrG5U3Zw5J
b1cAR0bcsyK06UJ6N+D9Jn/r2Jy/snjRKdTp296EcrohnwMCwGq4kwmtZpwZtES3
zf5oTQpdKqt35G23nQOfjNBg1FgBEbOaNOt99SmTFRoyRvXR/DZY6J71SQ/ELSLW
7UE33sl/HvxB2UABvvytHI6nWBTXGOvp792dcPb24pzqLgotvOoO4GYgUCG6xro5
evjCi3RSQXaQuVXXTJd3l5/2ZADnrFvKUaSM/kE65GdgOJusNafPpMrqv4ik1Rdi
OXnsd+9KwlyJRvLfhrrQplwmVyVwHFCXCdcA+WZPUuV7IxSeQjuuKMgx1rhGIYZA
EwXyT5TJJmNLMAidiwZRffzX7dVzcX0HGOg2ohqKWAW4LEIooMA+FLHqQZyvIuN2
oM9PwXVEN9I/9SU49cBLH2OZbHTb2w8WNntn1pGxowC223r1j3Vjb1UnxXQHBFYu
9EQdvfbaDdGwS54gBwUFvnobOL0wPkNVxDoHzgdmNukmeqQ18dLExOaH67cjbW/V
2/0zj4oli9lpMz6q7OrthMWGpuCeGvQLxcIMqlYJWh/Joq5cbBRXtwcIIYe8IT0b
I1pkHHq79Fo=
=I8lJ
-----END PGP SIGNATURE-----

--=-tGQy7isYhPVWCU0vCeqT--

