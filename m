Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:52781 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752560AbdBAWTt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 17:19:49 -0500
Date: Wed, 1 Feb 2017 23:19:45 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        Ping-Ke Shih <pkshih@realtek.com>, kbuild-all@01.org
Subject: Re: [PATCH 05/11 V2] rtlwifi: btcoexist: Change logging in
 halbtc8192e2ant.c (fwd)
Message-ID: <alpine.DEB.2.20.1702012318350.2021@hadrien> (sfid-20170201_231952_466657_10668059)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Indeed, there are the four cases where the then and else branches are the
same.  Is it generated code?

julia

---------- Forwarded message ----------
Date: Thu, 2 Feb 2017 06:10:01 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 05/11 V2] rtlwifi: btcoexist: Change logging in
    halbtc8192e2ant.c

In-Reply-To: <20170120212716.29887-6-Larry.Finger@lwfinger.net>

Hi Larry,

[auto build test WARNING on wireless-drivers-next/master]
[also build test WARNING on v4.10-rc6 next-20170201]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Larry-Finger/rtlwifi-Various-updates/20170202-045716
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
:::::: branch date: 72 minutes ago
:::::: commit date: 73 minutes ago

>> drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c:2186:11-13: WARNING: possible condition with no effect (if == else)
   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c:2208:11-13: WARNING: possible condition with no effect (if == else)
   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c:2232:11-13: WARNING: possible condition with no effect (if == else)
   drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c:2254:11-13: WARNING: possible condition with no effect (if == else)

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 2e5b0b84cf4c19a9b761ecbfbcbec52ac35f39da
vim +2186 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c

2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2170  	if (!coex_dm->auto_tdma_adjust) {
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2171  		coex_dm->auto_tdma_adjust = true;
2e5b0b84 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8192e2ant.c Larry Finger 2017-02-01  2172  		RT_TRACE(rtlpriv, COMP_BT_COEXIST, DBG_LOUD,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2173  			 "[BTCoex], first run TdmaDurationAdjust()!!\n");
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2174  		if (sco_hid) {
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2175  			if (tx_pause) {
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2176  				if (max_interval == 1) {
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2177  					halbtc8192e2ant_ps_tdma(btcoexist,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2178  								NORMAL_EXEC,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2179  								true, 13);
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2180  					coex_dm->tdma_adj_type = 13;
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2181  				} else if (max_interval == 2) {
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2182  					halbtc8192e2ant_ps_tdma(btcoexist,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2183  								NORMAL_EXEC,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2184  								true, 14);
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2185  					coex_dm->tdma_adj_type = 14;
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04 @2186  				} else if (max_interval == 3) {
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2187  					halbtc8192e2ant_ps_tdma(btcoexist,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2188  								NORMAL_EXEC,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2189  								true, 15);
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2190  					coex_dm->tdma_adj_type = 15;
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2191  				} else {
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2192  					halbtc8192e2ant_ps_tdma(btcoexist,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2193  								NORMAL_EXEC,
2187e9a2 drivers/net/wireless/rtlwifi/btcoexist/halbtc8192e2ant.c         Larry Finger 2014-09-04  2194  								true, 15);

:::::: The code at line 2186 was first introduced by commit
:::::: 2187e9a2ce575ee85a1ce31fa2ecbc0f580c105f rtlwifi: btcoexist: Modify driver for V062814 Realtek driver

:::::: TO: Larry Finger <Larry.Finger@lwfinger.net>
:::::: CC: John W. Linville <linville@tuxdriver.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
