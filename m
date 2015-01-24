Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:49569 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbbAXGjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2015 01:39:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Hong Xu <hong@topbug.net>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-wireless@vger.kernel.org
Subject: Re: [wireless-drivers-next:master 119/130] drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
References: <201501240432.liRbf02o%fengguang.wu@intel.com>
	<87lhkskjen.fsf@home.hong.me>
Date: Sat, 24 Jan 2015 08:39:12 +0200
In-Reply-To: <87lhkskjen.fsf@home.hong.me> (Hong Xu's message of "Fri, 23 Jan
	2015 18:21:52 -0800")
Message-ID: <8761bwk7hr.fsf@kamboji.qca.qualcomm.com> (sfid-20150124_074142_877959_6430CEEC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Adding linux-wireless)

Hong Xu <hong@topbug.net> writes:

> kbuild test robot <fengguang.wu@intel.com> writes:
>
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git master
>> head:   c5ed1df781cb544d4e4d189bb5b6ec7336d8888c
>> commit: 3a939a671225909c19b09bfcb6e4761109e913d9 [119/130] ath9k_htc: Add a module parameter to disable blink
>> config: xtensa-allyesconfig (attached as .config)
>> reproduce:
>>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>>   chmod +x ~/bin/make.cross
>>   git checkout 3a939a671225909c19b09bfcb6e4761109e913d9
>>   # save the attached .config to linux build tree
>>   make.cross ARCH=xtensa 
>>
>> All error/warnings:
>>
>>>> drivers/net/wireless/ath/ath9k/ath9k_htc.o:(.data+0x47c): multiple definition of `led_blink'
>>    drivers/net/wireless/ath/ath9k/ath9k.o:(.bss+0x20): first defined here
>>
>
> This should not be a problem if the driver is built as a module. If you
> consider this is a problem we can simply change the variable name.

This is a problem, please send a fix which I can apply to
wireless-drivers-next.

-- 
Kalle Valo
