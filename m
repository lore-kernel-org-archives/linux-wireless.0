Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:31060 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2KPLbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2012 06:31:21 -0500
Cc: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>
Message-ID: <50A62400.2020603@qca.qualcomm.com> (sfid-20121116_123133_548958_C6B0E2D9)
Date: Fri, 16 Nov 2012 13:31:12 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Set HT caps when an interface is added
References: <1350402738-6422-1-git-send-email-mohammed@qca.qualcomm.com> <873918b0z0.fsf@qca.qualcomm.com> <5084D8C0.80708@qca.qualcomm.com>
In-Reply-To: <5084D8C0.80708@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 10/22/2012 08:25 AM, Mohammed Shafi Shajakhan wrote:
> On Sunday 21 October 2012 03:28 PM, Kalle Valo wrote:
>> Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com> writes:
>>
>>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>>
>>> Set HT capabilites when a vif is added (based on ht_supported
>>> advertized is 'true'). ath6kl_set_htcap
>>> seems to be called when an AP vif is added but not so in
>>> other vifs. Fix this.
>>>
>>> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>
>> This was found during code review, right? Or does it fix a real bug?
> 
> yes this was based on code review, would soon come with some test 
> results with multivif.

I'm not sure what was the conclusion, is this safe to apply?

Kalle
