Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23979 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISYQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 14:24:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/6] ath10k: remove target soc ps code
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	<1407402212-29809-3-git-send-email-michal.kazior@tieto.com>
	<87ha1lttgh.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 9 Aug 2014 21:24:09 +0300
In-Reply-To: <87ha1lttgh.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Sat, 09 Aug 2014 21:21:18 +0300")
Message-ID: <87d2c9ttbq.fsf@kamboji.qca.qualcomm.com> (sfid-20140809_202419_766083_03058D80)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

>> @@ -1915,7 +1870,6 @@ static int ath10k_pci_warm_reset(struct ath10k *ar)
>>  
>>  	ath10k_dbg(ATH10K_DBG_BOOT, "boot warm reset complete\n");
>>  
>> -	ath10k_do_pci_sleep(ar);
>>  	return ret;
>>  }
>
> For some reason I don't get all kbuild emails, and I don't know if you
> got it either, but smatch found a style error here:
>
>>> drivers/net/wireless/ath/ath10k/pci.c:1797:5-8: Unneeded variable: "ret". Return "0" on line 1873

Forgot the link to the mail:

https://lists.01.org/pipermail/kbuild/2014-August/001684.html

-- 
Kalle Valo
