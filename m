Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:26057 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752379AbeCRC42 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 22:56:28 -0400
Date: Sun, 18 Mar 2018 10:56:08 +0800
From: kbuild test robot <lkp@intel.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 07/12] brcmfmac: pass struct in brcmf_fw_get_firmwares()
Message-ID: <201803181057.WG55MQaM%fengguang.wu@intel.com> (sfid-20180318_035733_591190_A9AA8E7D)
References: <1521195085-439-8-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521195085-439-8-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20180309]
[cannot apply to v4.16-rc4 v4.16-rc3 v4.16-rc2 v4.16-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Arend-van-Spriel/brcmfmac-data-structure-and-firmware-loading-rework/20180318-065559
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c:591:6: sparse: symbol 'brcmf_fw_request_is_valid' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
