Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2725 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbbKYK7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2015 05:59:33 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Peter Oh <poh@codeaurora.org>
CC: kbuild test robot <lkp@intel.com>, Peter Oh <poh@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <kbuild-all@01.org>,
	<ath10k@lists.infradead.org>
Subject: Re: [PATCH 1/3] ath10k: update WMI 10.x service map
References: <201511250520.vewzfdmy%fengguang.wu@intel.com>
	<56550D40.3090603@codeaurora.org>
Date: Wed, 25 Nov 2015 12:59:11 +0200
In-Reply-To: <56550D40.3090603@codeaurora.org> (Peter Oh's message of "Tue, 24
	Nov 2015 17:22:08 -0800")
Message-ID: <87wpt6ny4g.fsf@kamboji.qca.qualcomm.com> (sfid-20151125_115938_719791_5C945E1F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fixing quotes)

Peter Oh <poh@codeaurora.org> writes:

>>     In file included from include/linux/bitops.h:36:0,
>>                      from include/linux/kernel.h:10,
>>                      from include/asm-generic/bug.h:13,
>>                      from arch/m68k/include/asm/bug.h:28,
>>                      from include/linux/bug.h:4,
>>                      from include/net/mac80211.h:18,
>>                      from drivers/net/wireless/ath/ath10k/mac.h:21,
>>                      from drivers/net/wireless/ath/ath10k/mac.c:18:
>>     drivers/net/wireless/ath/ath10k/wmi.h: In function 'wmi_10x_svc_map':
>>     drivers/net/wireless/ath/ath10k/wmi.h:457:9: error: 'WMI_SERVICE_MESH'
>> undeclared (first use in this function)
>>              WMI_SERVICE_MESH, len);
>>              ^
>>     arch/m68k/include/asm/bitops.h:63:50: note: in definition of macro
>> 'set_bit'
>>      #define set_bit(nr, vaddr) (__builtin_constant_p(nr) ? \
>>                                                       ^
>>>> drivers/net/wireless/ath/ath10k/wmi.h:398:4: note: in expansion of
>> macro '__set_bit'
>>         __set_bit(y, out); \
>>         ^
>
> I believe the robot report is false.
> Am I right?

I think these are false, at least I didn't notice anything when I
applied these to ath.git pending branch.

-- 
Kalle Valo
