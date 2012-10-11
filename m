Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-3.exch022.serverdata.net ([206.225.164.186]:60295
	"EHLO HUB022-nj-3.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758088Ab2JKIAm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2012 04:00:42 -0400
Message-ID: <50767CA1.1060804@posedge.com> (sfid-20121011_100046_194179_B24F5412)
Date: Thu, 11 Oct 2012 13:30:33 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Subject: Re: [PATCH v2] {nl,cfg}80211: Peer STA VHT caps
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCFB4B0@mbx022-e1-nj-10.exch022.domain.local> <1349941762.13097.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1349941762.13097.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2012 01:19 PM, Johannes Berg wrote:
> On Thu, 2012-10-11 at 05:44 +0000, Mahesh Palivela wrote:
>> From: Mahesh Palivela <maheshp@posedge.com>
>>
>> To save STAs VHT caps in AP mode
>>
>> Signed-off-by: Mahesh Palivela <maheshp@posedge.com>
>> ---
>> Patch version 2 to take care of Jouni Malinen's comment
>>
>>   include/linux/nl80211.h |    3 +++
>>   include/net/cfg80211.h  |    2 ++
>>   net/mac80211/cfg.c      |    5 +++++
>>   net/wireless/nl80211.c  |    5 +++++
>>   4 files changed, 15 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> index 179a0c2..b82ab80 100644
>> --- a/include/linux/nl80211.h
>> +++ b/include/linux/nl80211.h
>> @@ -1535,6 +1535,8 @@ enum nl80211_attrs {
>>
>>   	NL80211_ATTR_SAE_DATA,
>>
>> +	NL80211_ATTR_VHT_CAPABILITY,
>
> Looks fine, but please add documentation for this new attribute.
>
> johannes
>
Sorry. Update on its way ....
