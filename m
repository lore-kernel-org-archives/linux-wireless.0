Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54845 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaBYQZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 11:25:43 -0500
Message-ID: <1393345524.4170.19.camel@jlt4.sipsolutions.net> (sfid-20140225_172546_051409_FC568A1E)
Subject: pull-request: mac80211 2014-02-25
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 25 Feb 2014 17:25:24 +0100
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-ikVgUmlLXe2hYq7zdmKA"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ikVgUmlLXe2hYq7zdmKA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

John,

Two more fixes ...

There's one fix from Janusz for a regulatory issue, and one fix from
myself for an issue with 80 MHz connections when the regulatory database
wasn't updated, which leads to not being able to connect at all, clearly
a problem.

Let me know if there's any problem.

johannes

The following changes since commit e3685e03b40f5ec7926d9a75bf63467fc4071df9=
:

  mac80211: fix station wakeup powersave race (2014-02-20 11:54:09 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 092008abeed1e4168c08826262695ea67657e1aa:

  cfg80211: regulatory: reset regdomain in case of error (2014-02-25 16:27:=
04 +0100)

----------------------------------------------------------------
Janusz Dziedzic (1):
      cfg80211: regulatory: reset regdomain in case of error

Johannes Berg (1):
      mac80211: don't validate unchanged AP bandwidth while tracking

 net/mac80211/mlme.c | 22 ++++++++++++++++++++++
 net/wireless/reg.c  | 10 +++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)


--=-ikVgUmlLXe2hYq7zdmKA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTDMP0AAoJEDBSmw7B7bqro5QQALkIX6FSGcZLTZMzcMnmiXA9
98Wm1uzYe+2qgs0mj6DCiFQW3qhBqUH5FHkY3K37kK70kE1xz9l0mmeqEFB9swrS
oDzWJ/hTedmVnD2r/GEgpxCym+mbYdqnT+iKl6gZvtJICYBHb973BamZGAx4TZ57
Gr5UZpy7zSktSV0p3TAWefXG1zW4kkearH7EsgQpM9SoYAaKHuhaFuxZ26OBeesm
6hpWYKzo2nF35fOin1oVpqWgybRDBQaW9pepGu9QrqZkrUNxNseOxUpF7T1S/sVC
gSYsykmLM8QQo2Apk41p0aqvNGT4Y3Q2IfBnWzaUpTAtc7lbjeMr196RuAN2JISd
tv++KXw8WKL+sr3NMiRtG6/HQ+csdH9STBjPhsbmIB68rBMAyJYV75mMoJY0GMZF
Iu6NCAmkR/hQlR00/c674su52G+s/m5ztX3a2vX/i0Gr0dU7ifiik6xZUqYVluUz
xx1la9+Vjqe3JuUekDf3WSFHv+iJ0PqcKIA/ITXKUexCleHB14D9E2n7iDwWlafO
b/tSP8ZSiaeJTqNNooAQJ2S2xIBRxxmyd+/wIO8lvK7UG30SrHttGwf4H47deWHW
GUZBR9pkDsDrwby5rrHkd/90E8KtX5FXNUideef4XQm0FLRa9U6sgJez6udgFi+X
aHzfC8fPgR/wbGcY5y7x
=W+lp
-----END PGP SIGNATURE-----

--=-ikVgUmlLXe2hYq7zdmKA--

