Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56820 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753586AbbJVBDb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 21:03:31 -0400
Date: Thu, 22 Oct 2015 08:58:58 +0800
From: kbuild test robot <lkp@intel.com>
To: greearb@candelatech.com
Cc: kbuild-all@01.org, linux-wireless@vger.kernel.org,
	ath6kl@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 2/2] ath6k: implement ethtool stats.
Message-ID: <201510220815.XZd9VwIK%fengguang.wu@intel.com> (sfid-20151022_030335_660861_A870A5DA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1445471597-26091-2-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

[auto build test WARNING on net/master -- if it's inappropriate base, please suggest rules for selecting the more suitable base]

url:    https://github.com/0day-ci/linux/commits/greearb-candelatech-com/ath6k-break-stats-gathering-code-into-separate-method/20151022-075558
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/net/wireless/ath/ath6kl/cfg80211.c:3750:26: sparse: symbol 'ath6k_ethtool_ops' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
