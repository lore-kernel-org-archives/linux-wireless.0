Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:38150 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbbEINkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:40:07 -0400
From: "Machani, Yaniv" <yanivma@ti.com>
To: "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: wl18xx : firmware pull request
Date: Sat, 9 May 2015 13:40:00 +0000
Message-ID: <AE1C82FB3D0EC64DB1F752C81CBD1101265F62A7@DFRE01.ent.ti.com> (sfid-20150509_154011_701514_704AE3C8)
Content-Type: text/plain; charset="windows-1255"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Please see below pull request,

- Firmware file was updated (8.9.0.0.39), includes bug fixes and improvements.
- Configuration binary removed, it is no longer fits all releases.
  Moreover it should be configured per HW platform.
  More information can found in here :
  http://processors.wiki.ti.com/index.php/Open_Source_Wireless_Connectivity_wlconf

Regards,
Yaniv

The following changes since commit 8e181320b11de501046cf75c8c30915cd09a1e39:
  Daniel Drake (1):
        linux-firmware: Add Realtek Bluetooth HCD firmware

are available in the git repository at:

  git@git.ti.com:wilink8-wlan/linux-firmware.git for-upstream

for you to fetch changes up to 4b1bff7e08c53807eb298cc94df69111239ef6f5
Yaniv Machani (1):
      wl18xx: update firmware file, remove conf file

 ti-connectivity/wl18xx-conf.bin |  Bin 1221 -> 0 bytes
 ti-connectivity/wl18xx-fw-4.bin |  Bin 681704 -> 724716 bytes
 2 files changed, 0 insertions(+), 0 deletions(-)
 delete mode 100644 ti-connectivity/wl18xx-conf.bin


