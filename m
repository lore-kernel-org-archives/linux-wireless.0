Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42676 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbbJLJAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2015 05:00:05 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] brcmfmac: expose device memory to devcoredump subsystem
References: <201510090203.zZSsJ7qb%fengguang.wu@intel.com>
Date: Mon, 12 Oct 2015 11:59:55 +0300
In-Reply-To: <201510090203.zZSsJ7qb%fengguang.wu@intel.com> (kbuild test
	robot's message of "Fri, 9 Oct 2015 02:59:31 +0800")
Message-ID: <87wpuspilw.fsf@kamboji.qca.qualcomm.com> (sfid-20151012_110009_546889_3D8B2553)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:

> Hi Arend,
>
> [auto build test ERROR on next-20151008 -- if it's inappropriate base, please ignore]
>
> config: x86_64-randconfig-x011-201540 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
>
> All errors (new ones prefixed by >>):
>
>    drivers/net/wireless/brcm80211/brcmfmac/debug.c:58:6: error: redefinition of 'brcmf_debugfs_init'
>     void brcmf_debugfs_init(void)
>          ^
>    In file included from drivers/net/wireless/brcm80211/brcmfmac/bus.h:20:0,
>                     from drivers/net/wireless/brcm80211/brcmfmac/debug.c:24:
>    drivers/net/wireless/brcm80211/brcmfmac/debug.h:118:20: note: previous definition of 'brcmf_debugfs_init' was here
>     static inline void brcmf_debugfs_init(void)
>                        ^

Arend, are the kbuild errors valid? I would guess they are as
wireless-drivers-next should be in linux-next.

-- 
Kalle Valo
