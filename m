Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3FEHC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 03:02:29 -0400
Message-ID: <1370415743.8920.6.camel@jlt4.sipsolutions.net> (sfid-20130605_090232_992092_63BF392F)
Subject: pull-request: iwlwifi-fixes 2013-06-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 05 Jun 2013 09:02:23 +0200
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-tSysXdrvVlijEgW2ZdLE"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tSysXdrvVlijEgW2ZdLE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Here's another one ... I guess the fixes stream never ends, but on the
plus side they're getting smaller.

I picked up Nikolay's patch for the chain noise calibration bug that
seems to have been there forever, a fix from Emmanuel for setting TX
flags on BAR frames and a fix of my own to avoid printing
request_module() errors if the kernel isn't even modular.

Please pull.

Thanks,
johannes


The following changes since commit a87783699b23395c46bbeeb5d28f6db24897bf26=
:

  iwlwifi: dvm: fix zero LQ CMD sending avoidance (2013-05-27 11:33:57 +020=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 2edc6ec6330c7906f4dbd7f5da71be8989efc5a3:

  iwlwifi: mvm: correctly set the flags for BAR (2013-06-04 13:14:30 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: correctly set the flags for BAR

Johannes Berg (1):
      iwlwifi: don't print module loading error if not modular

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

 drivers/net/wireless/iwlwifi/dvm/rxon.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c  | 2 ++
 drivers/net/wireless/iwlwifi/mvm/tx.c   | 3 ++-
 3 files changed, 5 insertions(+), 2 deletions(-)


--=-tSysXdrvVlijEgW2ZdLE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRruJ/AAoJEDBSmw7B7bqrVJ4QAIHt3WLrslvhbz/T58em+XlA
CAQkUsncDnru3UtxqL3PdX8S4V5gy2X3ZIMyd0JSmCO7tKAGR3mP1lVm318yvf6W
hW6XxkP64ilnyianhqrok5B14lN0VSYayloljGLB/YqZsi/9Ewwzqkv2gy/QNRsT
MycKj2CoO0Qj+f6isOrUDxd+Op4zelGDdzgAcz7QcAZwkr3gsurdNZbnS41WlCCV
0n4gUtVw8qFCEPvVPHrC8As5Aq6EhkymJVR0ltXk9A7Y0JS9Cq8Z7Kj6JrHXM/0K
9LmRyIagibTwqsANayReiasPMw1P7zhBPAnEiHqgOCvW+mdlJU5VYu2VH7+mrx39
T0G5ynzN0iLeAtDbVm0tQBDQZR6Fv4O7b0znClq0iX+SKQkwdWyltwYo8mGK1qid
YcBQE4r+799L+YfJy0ETL64DVhVt5Qhhl02YEFvMD3fOp/bySyjsiD/54lh3U1kX
up868ZAkH5QRGZZ3y8rkQVIZ81AUcPsGcDgiB3XXnSCZH67Ulin9Y8/g9VxCwSkz
3WGxG6/yrR4RIt+prK9uP0MfZ0bK2H6CSOKOMBugXx3QZexmsPVl4otXFzFKli/A
cO5S5uJe30bGdluKFqHHg7u+b0oAXkmcJxnP9igmzamqVLsO/x2Pt0A1yACMSeLG
gfErrpdD1+pMFyC0zKIf
=c1PI
-----END PGP SIGNATURE-----

--=-tSysXdrvVlijEgW2ZdLE--

