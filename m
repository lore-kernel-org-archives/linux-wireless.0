Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:41696 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab2JVFbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 01:31:34 -0400
Cc: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Message-ID: <5084D8C0.80708@qca.qualcomm.com> (sfid-20121022_073137_116923_21BA30D2)
Date: Mon, 22 Oct 2012 10:55:20 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Set HT caps when an interface is added
References: <1350402738-6422-1-git-send-email-mohammed@qca.qualcomm.com> <873918b0z0.fsf@qca.qualcomm.com>
In-Reply-To: <873918b0z0.fsf@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Sunday 21 October 2012 03:28 PM, Kalle Valo wrote:
> Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:
>
>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>
>> Set HT capabilites when a vif is added (based on ht_supported
>> advertized is 'true'). ath6kl_set_htcap
>> seems to be called when an AP vif is added but not so in
>> other vifs. Fix this.
>>
>> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> This was found during code review, right? Or does it fix a real bug?

yes this was based on code review, would soon come with some test 
results with multivif.

>


-- 
thanks,
shafi


