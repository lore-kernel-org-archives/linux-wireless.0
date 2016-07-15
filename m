Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33917 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbcGOHVc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 03:21:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, David Miller <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2016-07-13
References: <201607151143.oxJDgbga%fengguang.wu@intel.com>
Date: Fri, 15 Jul 2016 10:21:23 +0300
In-Reply-To: <201607151143.oxJDgbga%fengguang.wu@intel.com> (kbuild test
	robot's message of "Fri, 15 Jul 2016 11:09:52 +0800")
Message-ID: <87furbxt70.fsf@kamboji.qca.qualcomm.com> (sfid-20160715_092136_277918_58D04B1C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi,
>
> [auto build test ERROR on wireless-drivers-next/master]
> [cannot apply to v4.7-rc7 next-20160714]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Kalle-Valo/pull-request-wireless-drivers-next-2016-07-13/20160714-023750
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
> config: sparc64-allmodconfig (attached as .config)
> compiler: sparc64-linux-gnu-gcc (Debian 5.3.1-8) 5.3.1 20160205
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=sparc64 
>
> All error/warnings (new ones prefixed by >>):
>
>    drivers/net/wireless/marvell/mwifiex/scan.c: In function 'mwifiex_cancel_scan':
>>> drivers/net/wireless/marvell/mwifiex/scan.c:2024:12: error: variable 'info' has initializer but incomplete type
>         struct cfg80211_scan_info info = {

The diff was just an example to help Dave fix few conflicts in my pull
request, it was not meant to be applied directly.

-- 
Kalle Valo
