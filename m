Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41778 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3FLMRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 08:17:38 -0400
Message-ID: <1371039449.8601.16.camel@jlt4.sipsolutions.net> (sfid-20130612_141741_244619_41B0C145)
Subject: Re: pull-request: iwlwifi-fixes 2013-06-05
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 12 Jun 2013 14:17:29 +0200
In-Reply-To: <1370415743.8920.6.camel@jlt4.sipsolutions.net> (sfid-20130605_090232_992092_63BF392F)
References: <1370415743.8920.6.camel@jlt4.sipsolutions.net>
	 (sfid-20130605_090232_992092_63BF392F)
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-aWJB4pxYNjJSlqC6dt1A"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aWJB4pxYNjJSlqC6dt1A
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Amending this ...


I picked up Nikolay's patch for the chain noise calibration bug that
seems to have been there forever, a fix from Emmanuel for setting TX
flags on BAR frames and a fix of my own to avoid printing
request_module() errors if the kernel isn't even modular. We also have
our own version of Stanislaw's fix for rate control.

johannes

The following changes since commit a87783699b23395c46bbeeb5d28f6db24897bf26=
:

  iwlwifi: dvm: fix zero LQ CMD sending avoidance (2013-05-27 11:33:57 +020=
0)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git f=
or-john

for you to fetch changes up to 622ebe994f6866b8d46ee5d3bcc329ed65d3722d:

  iwlwifi: fix rate control regression (2013-06-12 14:13:39 +0200)

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: mvm: correctly set the flags for BAR

Johannes Berg (1):
      iwlwifi: don't print module loading error if not modular

Moshe Benji (1):
      iwlwifi: fix rate control regression

Nikolay Martynov (1):
      iwlwifi: dvm: fix chain noise calibration

 drivers/net/wireless/iwlwifi/dvm/rs.c   | 2 +-
 drivers/net/wireless/iwlwifi/dvm/rxon.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-drv.c  | 2 ++
 drivers/net/wireless/iwlwifi/mvm/rs.c   | 1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c   | 3 ++-
 5 files changed, 7 insertions(+), 3 deletions(-)


--=-aWJB4pxYNjJSlqC6dt1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJRuGbZAAoJEDBSmw7B7bqrT2oQAKmVfP/uMzp2GhbOhGOatOw5
KHWFWS01Os1wwSAACNs3OPXc78wUXys9YioAdO5ULlqVxRDQLU+9A7opV84ibCwv
8S56ScWihvGiE50MHfaihKDjZDUGvw6MlUZOMe0FpBcqevZcxej9272iahxWcVM3
ZRs8xUYWW1xGa8i2x8dDWvv8xqQen0olN5EjKyGc8GKofmyrkG+aBJtCPp/PD11R
YP/Hcx12d8hqPU2wXmr+ok6lil4DFbHL2shLB6nxoYoQk7+83teqvLm9ARRlaQDB
UIGv9ZehP9t99EZdw2zYqIgn441IxINVAcmZOZ0rJBdqHJryx536TG1tx7tUfK+y
SU9RU5ADCQ5ua8vDesFSzcEvU0Mgpga419Zk21GlLh0KnyL2hupdiqEOxwcUv2VK
gCjSBOi2vVmhbgZ6UrPyn+l5EbPbKKrtrXiT5mgLf+M71k9E3X10XLodN5pbpAN2
iY1Ckivf430YmT+lmrK7cDh1h5J1BzExFyVQWSdu8Jq2I2hVJcXOUwKP0tGWcSMO
Qiiz8fzg14Twb15+85f3mAay4JN7CA5+MRGPoz8d7qRDRYX6a7PzkpsNvRBwhq0Y
63vBwe3KAaiiifMYv6vx/Aq2mlNG9/HE98elFC0a+AgqjvAA0X2qBUQdhlS5HIGI
KIAhxn4LPTAm2UpQ57gQ
=4JlT
-----END PGP SIGNATURE-----

--=-aWJB4pxYNjJSlqC6dt1A--

