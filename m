Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37778 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751878AbdBCIlh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 03:41:37 -0500
Message-ID: <1486111291.26003.86.camel@coelho.fi> (sfid-20170203_094140_652766_58404640)
From: Luca Coelho <luca@coelho.fi>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Fri, 03 Feb 2017 10:41:31 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: pull-request: iwlwifi firmwares update 2017-02-03
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kyle,

We have updated some of our old firmware releases and also added a new
release, version 27, for the newer devices.  More details in the tag
description.

Please pull or let me know if there are any issues.

Cheers,
Luca.



The following changes since commit 6d3bc8886517d171068fd1263176b8b5c51df204:

  Fix permissions on ti-connectivity firmware from 05e9fe59 (2017-01-13 10:14:07 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2017-02-03

for you to fetch changes up to b689306274099710f9f85eaab584604ca11ee54a:

  iwlwifi: add -27 firmware for 3168, 7265D, 8000C and 8265 (2017-02-03 10:20:54 +0200)

----------------------------------------------------------------
* update -17 firmware binaries for iwlwifi devices 3260, 7260 and 7265
* update -22 firmware binaries for iwlwifi devices 7265D, 8000C and 8265
* add -27 firmware binaries for iwlwifi devices 3168, 7265D, 8000C and 8265

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update -22 firmware for 7265D and up

Luca Coelho (2):
      iwlwifi: update -17 firmware for 3260, 7260 and 7265
      iwlwifi: add -27 firmware for 3168, 7265D, 8000C and 8265

 WHENCE                 |  24 ++++++++++++++++++------
 iwlwifi-3160-17.ucode  | Bin 918268 -> 918268 bytes
 iwlwifi-3168-27.ucode  | Bin 0 -> 1032168 bytes
 iwlwifi-7260-17.ucode  | Bin 1049340 -> 1049340 bytes
 iwlwifi-7265-17.ucode  | Bin 1180412 -> 1180412 bytes
 iwlwifi-7265D-22.ucode | Bin 1028316 -> 1028376 bytes
 iwlwifi-7265D-27.ucode | Bin 0 -> 1032452 bytes
 iwlwifi-8000C-22.ucode | Bin 2120860 -> 2120860 bytes
 iwlwifi-8000C-27.ucode | Bin 0 -> 2227284 bytes
 iwlwifi-8265-22.ucode  | Bin 1811984 -> 1811984 bytes
 iwlwifi-8265-27.ucode  | Bin 0 -> 2234528 bytes
 11 files changed, 18 insertions(+), 6 deletions(-)
 create mode 100644 iwlwifi-3168-27.ucode
 create mode 100644 iwlwifi-7265D-27.ucode
 create mode 100644 iwlwifi-8000C-27.ucode
 create mode 100644 iwlwifi-8265-27.ucode
