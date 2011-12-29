Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43272 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab1L2N2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Dec 2011 08:28:08 -0500
Message-ID: <4EFC6AE0.6070306@qca.qualcomm.com> (sfid-20111229_142826_753656_DA7FED0C)
Date: Thu, 29 Dec 2011 18:58:00 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, Paul Stewart <pstew@google.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH] mac80211: use RCU read locks for sta_info_get
References: <1324882778-3079-1-git-send-email-mohammed@qca.qualcomm.com> <87mxabcyi6.fsf@purkki.adurom.net>
In-Reply-To: <87mxabcyi6.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Thursday 29 December 2011 06:42 PM, Kalle Valo wrote:
> Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>  writes:
>
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> Cc: Paul Stewart<pstew@google.com>
>> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>
> A bit more background would be nice. What user visible bug this actually
> fixes? Is this a new regression or an old bug? If the former, what
> commit introduced the regression?

i had sent a v2 stating its introduced by the recent commit
http://www.spinics.net/lists/linux-wireless/msg82717.html

>


-- 
thanks,
shafi
