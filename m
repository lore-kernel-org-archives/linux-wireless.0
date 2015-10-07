Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:25691 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbJGIW0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 04:22:26 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: kbuild test robot <lkp@intel.com>
CC: <c_traja@qti.qualcomm.com>,
	Manikanta pubbisetty <c_mpubbi@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	<kbuild-all@01.org>, <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] ath10k: set peer MFP flag in peer assoc command
References: <201510071317.0ndTjHKZ%fengguang.wu@intel.com>
Date: Wed, 7 Oct 2015 11:22:08 +0300
In-Reply-To: <201510071317.0ndTjHKZ%fengguang.wu@intel.com> (kbuild test
	robot's message of "Wed, 7 Oct 2015 13:34:39 +0800")
Message-ID: <87612j1427.fsf@kamboji.qca.qualcomm.com> (sfid-20151007_102238_107062_1207D05A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi Tamizh,
>
> [auto build test ERROR on next-20151006 -- if it's inappropriate base, please ignore]
>
> config: xtensa-allyesconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=xtensa 
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_peer_assoc_h_crypto':
>>> drivers/net/wireless/ath/ath10k/mac.c:2014:9: error: 'struct ieee80211_sta' has no member named 'mfp'
>      if (sta->mfp &&

This is expected as the patch depends on not yet commited patch 'Revert
"mac80211: remove exposing 'mfp' to drivers"'.

-- 
Kalle Valo
