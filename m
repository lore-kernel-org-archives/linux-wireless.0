Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1045 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932758Ab2JKRZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 13:25:00 -0400
Message-ID: <507700DF.80401@broadcom.com> (sfid-20121011_192506_137807_882E7220)
Date: Thu, 11 Oct 2012 19:24:47 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] wireless: cfg80211: add peer-to-peer related
 definitions
References: <1349965104-14475-1-git-send-email-arend@broadcom.com>
 <1349973736.13097.12.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349973736.13097.12.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2012 06:42 PM, Johannes Berg wrote:
> On Thu, 2012-10-11 at 16:18 +0200, Arend van Spriel wrote:
>
>> +++ b/include/linux/ieee80211.h
>> @@ -168,6 +168,9 @@
>>   #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK	0x03
>>   #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT	5
>>
>> +/* Vendor-specific IE */
>> +#define IEEE80211_VENDOR_SPEC_IE		0xDD
>
> actually this already exists, as ..._EID_VENDOR or so?
>
> johannes
>
>

Thanks, Johannes

I probably overlooked it. Let me re-check.

Gr. AvS

