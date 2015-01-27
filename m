Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:60190 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864AbbA0Ffj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 00:35:39 -0500
Message-ID: <54C723A3.8000508@linux.intel.com> (sfid-20150127_063601_380030_625A0F2E)
Date: Tue, 27 Jan 2015 13:35:31 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	brudley@broadcom.com, Franky Lin <frankyl@broadcom.com>,
	meuleman@broadcom.com, linville@tuxdriver.com,
	pieterpg@broadcom.com, hdegoede@redhat.com, wens@csie.org,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	netdev@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
References: <54BDCC06.8090107@linux.intel.com>	<87twzincvz.fsf@kamboji.qca.qualcomm.com>	<54C1012F.1020400@cogentembedded.com> <54C1646B.4080409@broadcom.com> <87y4otldln.fsf@kamboji.qca.qualcomm.com> <54C28E6B.8090408@broadcom.com>
In-Reply-To: <54C28E6B.8090408@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2015/1/24 2:09, Arend van Spriel wrote:
> On 01/23/15 16:29, Kalle Valo wrote:
>> Arend van Spriel<arend@broadcom.com>  writes:
>>
>>> On 01/22/15 14:54, Sergei Shtylyov wrote:
>>>> Hello.
>>>>
>>>> On 1/22/2015 4:49 PM, Kalle Valo wrote:
>>>>
>>>>>> > From 04d3fa673897ca4ccbea6c76836d0092dba2484a Mon Sep 17 00:00:00 2001
>>>>>> From: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>>>>>> Date: Tue, 20 Jan 2015 11:14:13 +0800
>>>>>> Subject: [PATCH] brcmfmac: avoid duplicated suspend/resume operation
>>>>
>>>>>> WiFi chip has 2 SDIO functions, and PM core will trigger
>>>>>> twice suspend/resume operations for one WiFi chip to do
>>>>>> the same things. This patch avoid this case.
>>>>
>>>>>> Acked-by: Arend van Spriel<arend@broadcom.com>
>>>>>> Acked-by: Sergei Shtylyov<sergei.shtylyov@cogentembedded.com>
>>>>>> Acked-by: Kalle Valo<kvalo@codeaurora.org>
>>>>>> Signed-off-by: Zhonghui Fu<zhonghui.fu@linux.intel.com>
>>>>
>>>>> I don't remember giving Acked-by to this (or for matter to anything for
>>>>> a long time). What about Sergei or Arend?
>>>>
>>>> I haven't ACK'ed this patch either.
>>>
>>> I did ACK the initial patch and felt it still valid for this 'V2' patch.
>>
>> Ok, thanks. So the patch is good, Zhonghui just needs to remove the two
>> acked-by lines.
>
> Indeed.

I have removed the two acked-by lines and sent the new patch in another mail.

Thanks,
Zhonghui
>
> Regards,
> Arend
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

