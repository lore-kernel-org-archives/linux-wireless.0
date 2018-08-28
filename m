Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:39603 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727176AbeH1SqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 14:46:21 -0400
Date: Tue, 28 Aug 2018 22:53:27 +0800
From: kbuild test robot <lkp@intel.com>
To: Govind Singh <govinds@codeaurora.org>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: Re: [PATCH 2/2] ath10k: Enable pktlog for WCN3990 target
Message-ID: <201808282240.fECpwB7y%fengguang.wu@intel.com> (sfid-20180828_165422_914121_D9E7A2BD)
References: <20180828043642.14890-3-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180828043642.14890-3-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Govind,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ath6kl/ath-next]
[also build test WARNING on v4.19-rc1 next-20180828]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Govind-Singh/ath10k-Enable-pktlog-for-WCN3990-chipset/20180828-154302
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/net/wireless/ath/ath10k/htc.c:498:25: sparse: expression using sizeof(void)
   drivers/net/wireless/ath/ath10k/htc.c:657:25: sparse: expression using sizeof(void)
>> drivers/net/wireless/ath/ath10k/htc.c:875:6: sparse: symbol 'ath10k_htc_pktlog_svc_supported' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
