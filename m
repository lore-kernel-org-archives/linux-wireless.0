Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab3GZImj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:42:39 -0400
Message-ID: <1374828153.8248.19.camel@jlt4.sipsolutions.net> (sfid-20130726_104244_712203_82B735B9)
Subject: pull-request: mac80211 2013-07-26
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 26 Jul 2013 10:42:33 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-SrXCxjnrFaUsiUcbOv80"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SrXCxjnrFaUsiUcbOv80
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

And another one for mac80211 - that's all for now then :-)

I only have three fixes this time, a fix for a suspend regression, a
patch correcting the initiator in regulatory code and one fix for mesh
station powersave.

Let me know if there's any problem.

johannes


The following changes since commit 5c9fc93bc9bc417418fc1b6366833ae6a07b804d=
:

  mac80211/minstrel: fix NULL pointer dereference issue (2013-07-16 17:48:1=
4 +0300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 23df0b731954502a9391e739b92927cee4360343:

  regulatory: use correct regulatory initiator on wiphy register (2013-07-2=
5 09:52:46 +0200)

----------------------------------------------------------------
Arik Nemtsov (1):
      regulatory: use correct regulatory initiator on wiphy register

Chun-Yeow Yeoh (1):
      mac80211: prevent the buffering or frame transmission to non-assoc me=
sh STA

Stanislaw Gruszka (1):
      mac80211: fix monitor interface suspend crash regression

 net/mac80211/mesh_ps.c | 4 ++++
 net/mac80211/pm.c      | 7 +++++--
 net/wireless/reg.c     | 5 ++++-
 3 files changed, 13 insertions(+), 3 deletions(-)


--=-SrXCxjnrFaUsiUcbOv80
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJR8jZ5AAoJEDBSmw7B7bqrncAQAIej6+VfHP00RJbE+7Uu8uCr
fKRKlTLLG0mOpiiX8/HPuFafidmU2sDtqL8szBT6VkEMrZOipVdvIYlcKt/VN0LE
jt3Wcm/2CB2Vnzq6K3WtPM7kGcOKtvyEAnTEa04n7NR8iQ1gWtMXL/h0bkYhSlnO
zVQoUMkVMJ7tqalcHb66NSN4P9nB07pmBWcfzrHJ/WiuNA7y4qtpJjNq2jOi7QQN
e69w0MgZryv9JZ1ulaT76T9NPHLIkoVrnGuSLrNAcKp8pVXED1WEfhDwTqQlR5fk
sYkxTx1yoFEe+6IjRCAUWTzFVMjbQ7LwwjJoteFjZgQJX2LQoOkFHXWLxfseODxE
P54yYYcK/xugbc9mdh8h/vGSZ7buG4+IeZd7jPpJmZUN4JxQYGYkGuONKShLiK2C
ZOvHAvW76SPhoYaFPsU5ugsvfZsVEo/E6iFLIBha8bvex4DPppn9X1cl81jQWUTa
Pl8LnyGb/TDS9JjZKhu3pS/kz0g9XUfCugNNsbh7t5hMBqzJqvHz1yvU5Fhd0H0k
+3hAJOr0m/618BhKWdIM2gJnmBY8kJv+7sKK80+GvK+r4sqmC8l25kemiIc/IuJw
LWAbJZsyvK6gmdVNtLOHBOGlJ+fBnR2lKBCZzxJoa7DtF1ZcNZP3cYjjT0ueiqbp
Fn298SsVK1sLtMKxLYep
=ZUzC
-----END PGP SIGNATURE-----

--=-SrXCxjnrFaUsiUcbOv80--

