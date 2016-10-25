Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47118 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S965533AbcJYJis (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Oct 2016 05:38:48 -0400
Message-ID: <1477388323.17122.27.camel@coelho.fi> (sfid-20161025_113905_517022_58E7A04D)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Tue, 25 Oct 2016 12:38:43 +0300
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-WFX4fUz4b/Z1m4LolClv"
Mime-Version: 1.0
Subject: pull-request: iwlwifi 2016-10-25
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WFX4fUz4b/Z1m4LolClv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kalle,

Here are 7 patches intended for 4.9. =C2=A0They fix some small issues, as
described in the tag itself.  I sent them out for review on 2016-10-19,=20
and pushed to a pending branch.  Kbuildbot didn't find any issues.

Let me know if everything's fine (or not). :)

Luca.


The following changes since commit 1ea2643961b0d1b8d0e4a11af5aa69b0f92d0533=
:

  ath6kl: add Dell OEM SDIO I/O for the Venue 8 Pro (2016-10-13 14:16:33 +0=
300)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git t=
ags/iwlwifi-for-kalle-2016-10-25

for you to fetch changes up to 5a143db8c4a28dab6423cb6197e9f1389da375f2:

  iwlwifi: mvm: fix netdetect starting/stopping for unified images (2016-10=
-19 09:54:45 +0300)

----------------------------------------------------------------
* some fixes for suspend/resume with unified FW images;
* a fix for a false-positive lockdep report;
* a fix for multi-queue that caused an unnecessary 1 second latency;
* a fix for an ACPI parsing bug that caused a misleading error message;

----------------------------------------------------------------
Haim Dreyfuss (1):
      iwlwifi: mvm: comply with fw_restart mod param on suspend

Johannes Berg (1):
      iwlwifi: pcie: mark command queue lock with separate lockdep class

Luca Coelho (4):
      iwlwifi: mvm: use ssize_t for len in iwl_debugfs_mem_read()
      iwlwifi: mvm: fix d3_test with unified D0/D3 images
      iwlwifi: pcie: fix SPLC structure parsing
      iwlwifi: mvm: fix netdetect starting/stopping for unified images

Sara Sharon (1):
      iwlwifi: mvm: wake the wait queue when the RX sync counter is zero

 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 49 +++++++++++++++++++=
++++++++++++++++++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c  |  4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  3 +--
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c     | 33 +++++++++++++++++++=
++++++++------
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 79 +++++++++++++++++++=
++++++++++++++++++++++++++++-------------------------------
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  8 ++++++++
 9 files changed, 128 insertions(+), 53 deletions(-)
--=-WFX4fUz4b/Z1m4LolClv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCAAGBQJYDygjAAoJEKFHnKIaPMX6RUkP/30cc4FJdtSmIVtD+VZN7711
C3/cJHLlLvAuwwxLrSnVPKMOhOv9TtNinlHxGTWp/I871Xhm9W1qZVGtfK7zNOrT
tJGUwn/MA2alxGvMull1Cdfpa6nM35wCr8uce1L4tj2PbChaLjYNRzFO+3uG5hEO
tqOH9Ti8ZkoYlwnJmxS7Dpg6gQWRBKJ8zuVXXPqtGzZm9028zwC7lEjlM7nuVG6q
5UGDkxebcGbMJRfHQhDFXR1NkFePwm6bfxCkHB/rpMVIK50f7x82DwSjZBe7QTa6
+C99Oer3g3zLaGBfWSAyVcNYjPZYzZBQjd5Im2fv4V1e/+50GsmXp9goxPJoUrU+
c5fJfVWNr6LpVyPjgoCG9XZVGJqX4InJZicKGe67lPY2VNiySsaXmZKcn/nmeHVb
GTxsExtNEdr27trlSq8oxFFu7DZTa+TGQj0zgy2iVJl2cV1upBlxKwEddqBeQ6/x
53/TboSdfou7hgiWrLk3rzv9JZ8UbmOQNndRLXnCKmjD+WWiadhFJ3AaxKwgN6tr
t0TRBmlmGJFFfE1BAzDvbxFIFmdSFz/S4fOoQISoJ9Kb9yiHa+RY54GaNBtDotgW
3RtsX4FmOpOAqEQTCx87jToui2+axtLWdJNJ1aP50QPPMMdcES8aYpiTsEzwfvfB
osu08nUZWA/nESGvaVDj
=7IZy
-----END PGP SIGNATURE-----

--=-WFX4fUz4b/Z1m4LolClv--
