Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55538 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbdGAD7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Jun 2017 23:59:40 -0400
Date: Sat, 1 Jul 2017 11:59:13 +0800
From: kbuild test robot <lkp@intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kbuild-all@01.org, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH v3 09/10] rtlwifi: use debugfs to debug.
Message-ID: <201707011153.OdPSd2wB%fengguang.wu@intel.com> (sfid-20170701_055945_485832_2E03A3C9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170628151225.22190-10-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ping-Ke,

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on next-20170630]
[cannot apply to v4.12-rc7]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Larry-Finger/Set-3-of-changes-related-to-updates-of-btcoexist/20170701-003321
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/realtek/rtlwifi/debug.c:398:11-27: WARNING opportunity for simple_open, see also structure on line 418

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
