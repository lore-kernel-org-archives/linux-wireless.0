Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:13332 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752419AbeCRCcW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 22:32:22 -0400
Date: Sun, 18 Mar 2018 10:31:45 +0800
From: kbuild test robot <lkp@intel.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 04/12] brcmfmac: allocate struct brcmf_pub instance using
 wiphy_new()
Message-ID: <201803181015.DpFkb2Mm%fengguang.wu@intel.com> (sfid-20180318_033242_163335_A8BC5A95)
References: <1521195085-439-5-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521195085-439-5-git-send-email-arend.vanspriel@broadcom.com>
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

>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5144:21: sparse: symbol 'brcmf_cfg80211_ops' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
