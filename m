Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:2791 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754379AbcKQRBV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 12:01:21 -0500
Date: Fri, 18 Nov 2016 00:32:17 +0800
From: kbuild test robot <lkp@intel.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: kbuild-all@01.org, Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 3/5] nl80211: add support for gscan
Message-ID: <201611180012.0UGsX6ul%fengguang.wu@intel.com> (sfid-20161117_180142_870632_90B685C0)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="WIyZ46R2i8wDzkSu"
In-Reply-To: <1479382792-13131-4-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Arend,

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on next-20161117]
[cannot apply to v4.9-rc5]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Arend-van-Spriel/nl80211-add-support-for-g-scan/20161117-194818
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce: make htmldocs; make DOCBOOKS='' pdfdocs

All warnings (new ones prefixed by >>):

   make[3]: warning: jobserver unavailable: using -j1.  Add '+' to parent make rule.
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'
>> include/net/cfg80211.h:2469: warning: bad line: 
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_hashed_networks'
   include/net/cfg80211.h:3493: warning: No description found for parameter 'max_epno_exact_networks'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks' description in 'wiphy_gscan_caps'
   include/net/cfg80211.h:3493: warning: Excess struct/union/enum/typedef member 'max_epno_networks_by_ssid' description in 'wiphy_gscan_caps'

vim +2469 include/net/cfg80211.h

  2453		const u8 *srf_bf;
  2454		u8 srf_bf_len;
  2455		u8 srf_bf_idx;
  2456		struct mac_address *srf_macs;
  2457		int srf_num_macs;
  2458		struct cfg80211_nan_func_filter *rx_filters;
  2459		struct cfg80211_nan_func_filter *tx_filters;
  2460		u8 num_tx_filters;
  2461		u8 num_rx_filters;
  2462		u8 instance_id;
  2463		u64 cookie;
  2464	};
  2465	
  2466	/**
  2467	 * struct cfg80211_gscan_channel - GScan channel parameters.
  2468	 *
> 2469	
  2470	 * @ch: specific channel.
  2471	 * @dwell_time: hint for dwell time in milliseconds.
  2472	 * @passive: indicates passive scan is requested.
  2473	 */
  2474	struct cfg80211_gscan_channel {
  2475	    struct ieee80211_channel *ch;
  2476	    int dwell_time;
  2477	    bool passive;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--WIyZ46R2i8wDzkSu
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--WIyZ46R2i8wDzkSu--
