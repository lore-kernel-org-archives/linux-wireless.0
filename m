Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10143 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbbJGI71 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Oct 2015 04:59:27 -0400
From: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
	kbuild test robot <lkp@intel.com>
CC: Manikanta pubbisetty <c_mpubbi@qti.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"kbuild-all@01.org" <kbuild-all@01.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH 2/2] ath10k: set peer MFP flag in peer assoc command
Date: Wed, 7 Oct 2015 08:59:14 +0000
Message-ID: <65097485604c466b8ed93105627e5d14@aphydexm01f.ap.qualcomm.com> (sfid-20151007_105934_291187_8034C7F0)
References: <201510071317.0ndTjHKZ%fengguang.wu@intel.com>
 <87612j1427.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87612j1427.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

>> Hi Tamizh,
>>
>> [auto build test ERROR on next-20151006 -- if it's inappropriate base, please ignore]
>>
>> config: xtensa-allyesconfig (attached as .config)
>> reproduce:
> >        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>>         chmod +x ~/bin/make.cross
>>         # save the attached .config to linux build tree
>>         make.cross ARCH=xtensa 
>>
>> All errors (new ones prefixed by >>):
>>
>>    drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_peer_assoc_h_crypto':
>>>> drivers/net/wireless/ath/ath10k/mac.c:2014:9: error: 'struct ieee80211_sta' has no member named 'mfp'
>>      if (sta->mfp &&

>This is expected as the patch depends on not yet commited patch 'Revert
>"mac80211: remove exposing 'mfp' to drivers"'.

Yes, I have mention about the dependency in commit log notes. I have sent the required patch previous to this patch sets. 
-- 
Tamizh.
