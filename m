Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:1815 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588AbcBCDh7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 22:37:59 -0500
Date: Wed, 3 Feb 2016 11:40:03 +0800
From: kbuild test robot <lkp@intel.com>
To: Byeoungwook Kim <quddnr145@gmail.com>
Cc: kbuild-all@01.org, Larry.Finger@lwfinger.net, kvalo@codeaurora.org,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] rtlwifi: Fix improve function 'rtl_addr_delay()'
 in core.c
Message-ID: <201602031156.zcw9MfRN%fengguang.wu@intel.com> (sfid-20160203_043822_616964_FD6F6C0D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160203021510.GA13725@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Byeoungwook,

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.5-rc2 next-20160202]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Byeoungwook-Kim/rtlwifi-Fix-improve-function-rtl_addr_delay-in-core-c/20160203-101854
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master


coccinelle warnings: (new ones prefixed by >>)

>> drivers/net/wireless/realtek/rtlwifi/core.c:59:2-3: Unneeded semicolon

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
