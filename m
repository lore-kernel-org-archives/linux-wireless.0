Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40819 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbbBLODi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 09:03:38 -0500
Message-ID: <54DCB1BD.8090500@qti.qualcomm.com> (sfid-20150212_150349_254625_36DE6D5D)
Date: Thu, 12 Feb 2015 19:29:25 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix interrupt storm
References: <1423717162-7788-1-git-send-email-vthiagar@qti.qualcomm.com> <CA+BoTQmFhuK5vt8UnDu7CkH2=vUqGY8WkkXEgwoSb-NUoEYH-w@mail.gmail.com> <54DC517B.80402@qti.qualcomm.com>
In-Reply-To: <54DC517B.80402@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>>
>> Moreover I'm pretty sure this patch breaks STA 4addr bridging. I'm
>> worried it also breaks other stuff (e.g  some IBSS usecases or even
>> some AP usecases) but I don't have time to check this now.
>
> Can you please elaborate on this one?. I can review if we can for these
> cases as well before disabling promiscuous mode.

Instead of making the fix specific to some interface type (AP), it will be
good to understand the issue with STA and IBSS if we disable promiscuous mode.
As you know, it will be uglier if the fix has to be interface specific.

Vasanth
