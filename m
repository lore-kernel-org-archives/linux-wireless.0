Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61105 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab2KPOIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 09:08:14 -0500
Cc: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Message-ID: <50A648C9.6030108@qca.qualcomm.com> (sfid-20121116_150820_881370_FBF62769)
Date: Fri, 16 Nov 2012 19:38:09 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Set HT caps when an interface is added
References: <1350402738-6422-1-git-send-email-mohammed@qca.qualcomm.com> <873918b0z0.fsf@qca.qualcomm.com> <5084D8C0.80708@qca.qualcomm.com> <50A62400.2020603@qca.qualcomm.com>
In-Reply-To: <50A62400.2020603@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Friday 16 November 2012 05:01 PM, Kalle Valo wrote:
> Hi,
>
> On 10/22/2012 08:25 AM, Mohammed Shafi Shajakhan wrote:
>> On Sunday 21 October 2012 03:28 PM, Kalle Valo wrote:
>>> Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:
>>>
>>>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>>>
>>>> Set HT capabilites when a vif is added (based on ht_supported
>>>> advertized is 'true'). ath6kl_set_htcap
>>>> seems to be called when an AP vif is added but not so in
>>>> other vifs. Fix this.
>>>>
>>>> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>>
>>> This was found during code review, right? Or does it fix a real bug?
>>
>> yes this was based on code review, would soon come with some test
>> results with multivif.
>
> I'm not sure what was the conclusion, is this safe to apply?

Sorry i missed this, yeah will confirm it soon with a basic test and let 
you know. Please don't apply till that. thanks for your patience :)

>
> Kalle
>


-- 
thanks,
shafi


