Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:56762 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751039AbdEJU6p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 16:58:45 -0400
Message-ID: <1494449916.3094.66.camel@coelho.fi> (sfid-20170510_225849_572659_9925B0D2)
From: Luca Coelho <luca@coelho.fi>
To: Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Wed, 10 May 2017 23:58:36 +0300
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: pull-request: iwlwifi firmwares update 2017-05-10
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kyle,

The last time we pushed new -22 firmwares, we forgot to update the
relevant version for 3168 devices.  This pull-request contains only this
update.

Please pull or let me know if there are any issues.

Cheers,
Luca.


The following changes since commit ade8332383e228cbdcfc605b5e5ef3aa51211401:

  Merge branch 'master' of git://git.marvell.com/mwifiex-firmware (2017-04-22 11:25:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2017-05-10

for you to fetch changes up to ca89d62df8fbeb0b8131437dfd5b8098c85f8164:

  iwlwifi: update -22 firmware for 3168 (2017-05-10 23:43:18 +0300)

----------------------------------------------------------------
Update firmware for 3168

* update -22 firmware binaries for iwlwifi device 3168

----------------------------------------------------------------
Emmanuel Grumbach (1):
      iwlwifi: update -22 firmware for 3168

 WHENCE                |   2 +-
 iwlwifi-3168-22.ucode | Bin 1028032 -> 1028092 bytes
 2 files changed, 1 insertion(+), 1 deletion(-)
