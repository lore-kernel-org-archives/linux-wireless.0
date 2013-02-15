Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:64669 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3BOOBB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 09:01:01 -0500
Message-ID: <511E3F87.6030403@qca.qualcomm.com> (sfid-20130215_150104_906835_0A378FED)
Date: Fri, 15 Feb 2013 19:30:39 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Ryan Hsu <ryanhsu@qca.qualcomm.com>
Subject: Re: [PATCH 5/6] ath6kl: Fix a debugfs crash for USB devices
References: <1360834689-11187-1-git-send-email-mohammed@qca.qualcomm.com> <871uchamyh.fsf@kamboji.qca.qualcomm.com> <511E1B7A.60505@qca.qualcomm.com> <87k3q9950n.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k3q9950n.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2013 05:13 PM, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:
>
>>>> +	if (ar->hif_type != ATH6KL_HIF_TYPE_SDIO)
>>>> +		return -EINVAL;
>>>
>>> Actually I think it would be better not to even create the debugfs when
>>> using sdio.
>
> Oops, meant of course s/debugfs/debugfs file/. There seems to be packet
> loss between my brains and fingers...

yeah I think its USB and debugfs file :)

>
>> agreed, but looks bit ugly right ? thoughts.
>
> Sorry, but I don't understand how not creating the debugfs file for usb
> would be ugly? But this isn't that important, if you want we can do it
> like you propose as well.
>

I will cook up a new patch, please see if that's fine :)

-- 
thanks,
shafi
