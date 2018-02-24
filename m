Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:1411 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751131AbeBXO7N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Feb 2018 09:59:13 -0500
Date: Sat, 24 Feb 2018 22:58:42 +0800
From: kbuild test robot <lkp@intel.com>
To: s.gottschall@dd-wrt.com
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org, ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>
Subject: Re: [PATCH v9] ath10k: add LED and GPIO controlling support for
 various chipsets
Message-ID: <201802242215.SCy6eWvP%fengguang.wu@intel.com> (sfid-20180224_155918_123024_C45D17A3)
References: <20180222111534.31047-1-s.gottschall@dd-wrt.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180222111534.31047-1-s.gottschall@dd-wrt.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sebastian,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.16-rc2 next-20180223]
[cannot apply to ath6kl/ath-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/s-gottschall-dd-wrt-com/ath10k-add-LED-and-GPIO-controlling-support-for-various-chipsets/20180224-185406
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath10k/gpio.c:84:5: sparse: symbol 'ath10k_register_gpio_chip' was not declared. Should it be

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
