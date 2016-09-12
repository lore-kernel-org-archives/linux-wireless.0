Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:51997 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755984AbcILMFu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 08:05:50 -0400
Date: Mon, 12 Sep 2016 20:05:02 +0800
From: kbuild test robot <lkp@intel.com>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        prameela.j04cs@gmail.com, prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH 3/9] rsi: Added freeing of allocated buffers (sbands and
 dfsentry) Cleanup (spelling mistakes, code format corrections, empty lines
 after declaration)
Message-ID: <201609122009.NSihCWVh%fengguang.wu@intel.com> (sfid-20160912_140556_507745_CB852597)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e848b4549d9e919eb3a772e0d292db5eee39b43.1473669618.git.prameela.j04cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Prameela,

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.8-rc6 next-20160912]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
[Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
[Check https://git-scm.com/docs/git-format-patch for more information]

url:    https://github.com/0day-ci/linux/commits/Prameela-Rani-Garnepudi/rsi-cleanup-and-added-debug-prints-in-file-rsi_91x_core-c/20160912-184326
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/rsi/rsi_91x_mac80211.c:209:3-8: WARNING: NULL check before freeing functions like kfree, debugfs_remove, debugfs_remove_recursive or usb_free_urb is not needed. Maybe consider reorganizing relevant code to avoid passing NULL values.

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
