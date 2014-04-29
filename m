Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758094AbaD2QLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2014 12:11:24 -0400
Message-ID: <1398787858.29719.3.camel@jlt4.sipsolutions.net> (sfid-20140429_181128_070467_4433A3A9)
Subject: pull-request: mac80211-next rfkill-gpio-cleanup
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Stephen Warren <swarren@nvidia.com>
Date: Tue, 29 Apr 2014 18:10:58 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-smRYFd/oNjTNvShjDFVw"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-smRYFd/oNjTNvShjDFVw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Something I forgot in my other pull request, but better if you pull it
separately anyway...

Here I just have Heikki's rfkill GPIO cleanups.

The ARM/tegra patch is OK with the maintainer (Stephen). Let me know of
any problems.

johannes



The following changes since commit cd6362befe4cc7bf589a5236d2a780af2d47bcc9=
:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next (2014-=
04-02 20:53:45 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git rfk=
ill-gpio-cleanups

for you to fetch changes up to 781d4e0fb73379e251d1ac1562fe9892da711760:

  net: rfkill: gpio: hard-code the gpio names (2014-04-11 09:29:22 +0200)

----------------------------------------------------------------
Heikki Krogerus (5):
      ARM: tegra: remove obsolete gpio entries
      net: rfkill: gpio: remove unused and obsolete platform parameters
      net: rfkill: gpio: add ACPI ID for GPS module on Lenovo Miix2
      net: rfkill: gpio: add ACPI IDs for a Broadcom bluetooth chip
      net: rfkill: gpio: hard-code the gpio names

 arch/arm/mach-tegra/board-paz00.c |  4 +---
 include/linux/rfkill-gpio.h       | 10 ----------
 net/rfkill/rfkill-gpio.c          | 40 +++++++++--------------------------=
----
 3 files changed, 10 insertions(+), 44 deletions(-)


--=-smRYFd/oNjTNvShjDFVw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJTX88SAAoJEDBSmw7B7bqrvB4QAKsFuy5XjR+aAqNe3BMtQBjq
AhLdEbF4PvMbESS0OXDww5TF0+SVuhhCgfOgqAHlTxb2ELZ08sXhIa05Byf3ruHq
8VeO/5muWnPI6IXkqS8DahIn7DYn65psYu+mLIDIvG5gTMiv519B5ly6ew/USzEz
XuG/u3mp40kTneUr5FzDtRc25pka+K6DWZsFYXR8Ds1WryG+5DqEFqn5sAPVCWYi
Sg66hV3AIwzjbV6B9gGaaYIPZ2yxHz6aE+ubBiHvxXIkhSmpqT4uVnxJd9k11wuP
GWgSm0KoIV8wfxlj+KlJijK/HqMM3VYQpeAX0fSNTF3gz/45+vwmG+D1vLBGIzPO
iXjt9rxxd3hFmwJxTddF1q+ys7I10O9yBE7tVJF5hcd41fATTah8wyiSbA4K19E4
M5y4L7a21vCLGJE4FH1IFam7JT3KnnMRgpDroz+HaI162igoXRYAOXh2r/LW+oVk
XQFOd2T/Rtd7LdSIOmIbH40TJqRmsxCDWnp4XwYkUPzCQwhVaGEaCvDZuLTCmwKF
ZbqIFOB0g1yMAr4ZVhrDYENmzJmo90otPVzUHO7/n3w0OUf0hWwHI7UPzJwJ23hE
1RiMdefPx7oNjCDbus89d4YcoOOijdU///S0ygaUkkAXjNBsCFXFcvGs074YGalg
QJNQeSScsT05QPusOvoz
=9DVQ
-----END PGP SIGNATURE-----

--=-smRYFd/oNjTNvShjDFVw--

