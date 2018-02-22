Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40774 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752439AbeBVG2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Feb 2018 01:28:46 -0500
Date: Thu, 22 Feb 2018 14:28:29 +0800
From: kbuild test robot <lkp@intel.com>
To: mkenna@codeaurora.org
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
Subject: Re: [PATCH] ath10k: debugfs support to get final TPC stats for 10.4
 variants
Message-ID: <201802221335.IYmLJSh2%fengguang.wu@intel.com> (sfid-20180222_072850_675644_D3B4AF02)
References: <1519220139-10423-1-git-send-email-mkenna@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1519220139-10423-1-git-send-email-mkenna@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maharaja,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ath6kl/ath-next]
[also build test WARNING on v4.16-rc2 next-20180221]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/mkenna-codeaurora-org/ath10k-debugfs-support-to-get-final-TPC-stats-for-10-4-variants/20180222-110854
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath10k/wmi.c:4322:6: sparse: symbol 'ath10k_wmi_tpc_config_get_rate_code' was not declared. Should it be
>> drivers/net/wireless/ath/ath10k/wmi.c:4660:6: sparse: symbol 'ath10k_wmi_event_tpc_final_table' was not declared. Should it be
   drivers/net/wireless/ath/ath10k/wmi.c:738:10: sparse: Initializer entry defined twice
   drivers/net/wireless/ath/ath10k/wmi.c:744:10: also defined here

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
