Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56255 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbD3L6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 07:58:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH 0/7] wil6210 patches
References: <1430307906-28393-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<87y4la1gdm.fsf@kamboji.qca.qualcomm.com>
	<2058417.XHv0o6uz9r@lx-wigig-72>
Date: Thu, 30 Apr 2015 14:58:11 +0300
In-Reply-To: <2058417.XHv0o6uz9r@lx-wigig-72> (Vladimir Kondratiev's message
	of "Thu, 30 Apr 2015 11:59:44 +0300")
Message-ID: <87618d25gs.fsf@kamboji.qca.qualcomm.com> (sfid-20150430_135821_965130_C1EA4782)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> On Thursday, April 30, 2015 05:47:49 AM Kalle Valo wrote:
>> I see some warnings and errors:
>> 
>> drivers/net/wireless/ath/wil6210/pmc.c:94:228: warning: format '%ld' expects argument of type 'long int', but argument 6 has type 'unsigned int' [-Wformat]
>> drivers/net/wireless/ath/wil6210/pmc.c:94:228: warning: format '%ld' expects argument of type 'long int', but argument 8 has type 'unsigned int' [-Wformat]
>> drivers/net/wireless/ath/wil6210/pmc.c:94:448: warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'unsigned int' [-Wformat]
>> drivers/net/wireless/ath/wil6210/pmc.c:94:448: warning: format '%ld' expects argument of type 'long int', but argument 7 has type 'unsigned int' [-Wformat]
>> 
>> [...]
>> 
>> Kernel: arch/x86/boot/bzImage is ready  (#923)
>>   Building modules, stage 2.
>>   MODPOST 45 modules
>> ERROR: "__divdi3" [drivers/net/wireless/ath/wil6210/wil6210.ko] undefined!
>> 
>
> Ops, sorry. I forgot there are still 32-bit platforms here...
> Following is patch v2, it cleanly compiles on 32-bit x86

Please resend the whole series, less problems that way.

-- 
Kalle Valo
