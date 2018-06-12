Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:9886 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932750AbeFLOul (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Jun 2018 10:50:41 -0400
Date: Tue, 12 Jun 2018 22:50:37 +0800
From: kbuild test robot <lkp@intel.com>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Niklas Cassel <niklas.cassel@linaro.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: allow ATH10K_SNOC with COMPILE_TEST
Message-ID: <201806122228.8vAQXcD6%fengguang.wu@intel.com> (sfid-20180612_165253_799321_B7DFAC0D)
References: <20180612113907.15043-2-niklas.cassel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180612113907.15043-2-niklas.cassel@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Niklas,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on ath6kl/ath-next]
[also build test WARNING on next-20180612]
[cannot apply to v4.17]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Niklas-Cassel/ath10k-do-not-mix-spaces-and-tabs-in-Kconfig/20180612-194241
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git ath-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath10k/snoc.c:823:5: sparse: symbol 'ath10k_snoc_get_ce_id_from_irq' was not declared. Should it be static?
>> drivers/net/wireless/ath/ath10k/snoc.c:871:6: sparse: symbol 'ath10k_snoc_init_napi' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
