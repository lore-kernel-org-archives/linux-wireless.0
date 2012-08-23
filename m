Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49413 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030430Ab2HWNxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2012 09:53:03 -0400
Message-ID: <1345729977.4534.2.camel@jlt3.sipsolutions.net> (sfid-20120823_155318_685101_B16D4949)
Subject: pull-request: mac80211 2012-08-23
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 23 Aug 2012 15:52:57 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kFFFzPvco3DVBC9GxmoE"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kFFFzPvco3DVBC9GxmoE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Please pull to get a mesh fix from Thomas, addressing an issue with mesh
forwarding in mesh gate scenarios.

Thanks,
johannes
--------------------
The following changes since commit 899852af60c212bfe9a2fb71d4d9082d2622df5c=
:

  cfg80211: Clear "beacon_found" on regulatory restore (2012-08-02 15:34:22=
 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john

for you to fetch changes up to 27f011243a6e4e8b81078df1d83608dae31e3d38:

  mac80211: fix DS to MBSS address translation (2012-08-22 09:45:05 +0200)

----------------------------------------------------------------
Thomas Pedersen (1):
      mac80211: fix DS to MBSS address translation

 net/mac80211/tx.c |   38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)


--=-kFFFzPvco3DVBC9GxmoE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJQNjW5AAoJEDBSmw7B7bqr58oP/jqrmSlb4fF9dUzu7TZx1KKk
wVS/unrW0rPw7HikQYcLtiq93MNJmkg7z6b5c5ZwfwKOPW12vVbYAZ8vLb0PsK9+
SAMMLPbsKRZ2Xd9MlRb9aeX9a1vJXwKfIzHfkd8qwj/oC9zJr/B8Q4lVLvPcKSD/
VViQBxhzNqASN9I3TRCy/gaFDtF3ljsdS8SCAc7y8XVARvtEGsVWA3q/yU9TU+30
IMbWEuVZC9k+NoPL14qyfp7ojYeA/0mshOxYimY4vY5qojzfwqBrl/tZshuQlWbY
+79JZKfAjbQkDfK1ilO46uJbjnPMlGeDaPma60agWhBovMw0FrImRMjt07Y5gJt4
kpMCLhm/Q7KP9uIuZNecJ0x40dCZcrUeNfQCO+8znwKn+dKO8lDTuaqZUf0q044d
WergqXaGdfIXT7OcaltaqoPWAu1QG+4XVkPFBiWtArPw/BcsF6zdy+CZdLr6YcYY
J5BjH2WFdgTi9GFTBg6ONxtXj22MGMKNqmoFtbCeMpgKvKQf5r7/OrWLNeIEbU31
9imGtlmAvuJnVBYIA1LOEDG5M+ruj4NgC9v/svhKmdyCJPt4gq3zv6+qAJv52apY
PdVfW1QVh8YJRX+ZoMgWZzX1enauE1xNehDlag13W9sBcsc8Oo1Y+VzO4vN8aNwa
KLO0E3BahwtT8gVS8KFF
=z3OS
-----END PGP SIGNATURE-----

--=-kFFFzPvco3DVBC9GxmoE--

