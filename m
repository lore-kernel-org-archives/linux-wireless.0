Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15990 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbcDAEQj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 00:16:39 -0400
Date: Fri, 1 Apr 2016 12:15:29 +0800
From: kbuild test robot <lkp@intel.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 10/10] mac80211: enable collecting station statistics
 per-CPU
Message-ID: <201604011239.szXTt5vQ%fengguang.wu@intel.com> (sfid-20160401_061642_571538_22175E32)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
In-Reply-To: <1459443731-4614-10-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Johannes,

[auto build test WARNING on v4.6-rc1]
[also build test WARNING on next-20160331]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Emmanuel-Grumbach/mac80211-allow-passing-transmitter-station-on-RX/20160401-010817
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
   include/net/mac80211.h:1094: warning: Enum value 'RX_FLAG_DUP_VALIDATED' not described in enum 'mac80211_rx_flags'
>> net/mac80211/sta_info.h:547: warning: No description found for parameter 'pcpu_rx_stats'
   net/mac80211/sta_info.h:547: warning: Excess struct/union/enum/typedef member 'beacon_loss_count' description in 'sta_info'
>> net/mac80211/sta_info.h:547: warning: No description found for parameter 'pcpu_rx_stats'
   net/mac80211/sta_info.h:547: warning: Excess struct/union/enum/typedef member 'beacon_loss_count' description in 'sta_info'
>> net/mac80211/sta_info.h:547: warning: No description found for parameter 'pcpu_rx_stats'
   net/mac80211/sta_info.h:547: warning: Excess struct/union/enum/typedef member 'beacon_loss_count' description in 'sta_info'
>> net/mac80211/sta_info.h:547: warning: No description found for parameter 'pcpu_rx_stats'
   net/mac80211/sta_info.h:547: warning: Excess struct/union/enum/typedef member 'beacon_loss_count' description in 'sta_info'
>> net/mac80211/sta_info.h:547: warning: No description found for parameter 'pcpu_rx_stats'
   net/mac80211/sta_info.h:547: warning: Excess struct/union/enum/typedef member 'beacon_loss_count' description in 'sta_info'

vim +/pcpu_rx_stats +547 net/mac80211/sta_info.h

e9f207f0f Jiri Benc         2007-05-05  531  		struct dentry *dir;
63044e9f5 Johannes Berg     2008-10-07  532  		bool add_has_run;
e9f207f0f Jiri Benc         2007-05-05  533  	} debugfs;
e9f207f0f Jiri Benc         2007-05-05  534  #endif
17741cdc2 Johannes Berg     2008-09-11  535  
0af83d3df Johannes Berg     2012-12-27  536  	enum ieee80211_sta_rx_bandwidth cur_max_bandwidth;
0af83d3df Johannes Berg     2012-12-27  537  
687da1322 Emmanuel Grumbach 2013-10-01  538  	enum ieee80211_smps_mode known_smps_mode;
2475b1cc0 Max Stepanov      2013-03-24  539  	const struct ieee80211_cipher_scheme *cipher_scheme;
687da1322 Emmanuel Grumbach 2013-10-01  540  
b6da911b3 Liad Kaufman      2014-11-19  541  	u8 reserved_tid;
b6da911b3 Liad Kaufman      2014-11-19  542  
0fabfaafe Arik Nemtsov      2015-06-10  543  	struct cfg80211_chan_def tdls_chandef;
0fabfaafe Arik Nemtsov      2015-06-10  544  
17741cdc2 Johannes Berg     2008-09-11  545  	/* keep last! */
17741cdc2 Johannes Berg     2008-09-11  546  	struct ieee80211_sta sta;
f0706e828 Jiri Benc         2007-05-05 @547  };
f0706e828 Jiri Benc         2007-05-05  548  
57cf8043a Javier Cardona    2011-05-13  549  static inline enum nl80211_plink_state sta_plink_state(struct sta_info *sta)
d6d1a5a70 Johannes Berg     2008-02-25  550  {
d6d1a5a70 Johannes Berg     2008-02-25  551  #ifdef CONFIG_MAC80211_MESH
433f5bc1c Johannes Berg     2015-06-17  552  	return sta->mesh->plink_state;
d6d1a5a70 Johannes Berg     2008-02-25  553  #endif
57cf8043a Javier Cardona    2011-05-13  554  	return NL80211_PLINK_LISTEN;
d6d1a5a70 Johannes Berg     2008-02-25  555  }

:::::: The code at line 547 was first introduced by commit
:::::: f0706e828e96d0fa4e80c0d25aa98523f6d589a0 [MAC80211]: Add mac80211 wireless stack.

:::::: TO: Jiri Benc <jbenc@suse.cz>
:::::: CC: David S. Miller <davem@davemloft.net>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--UlVJffcvxoiEqYs2
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
ucNj6czUTJfRhYzkhQD8B27A30suWQAA

--UlVJffcvxoiEqYs2--
