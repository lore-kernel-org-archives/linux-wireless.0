Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49702 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1ATWmd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 17:42:33 -0500
Message-ID: <4D38BA56.4060207@openwrt.org>
Date: Thu, 20 Jan 2011 23:42:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 1/4] ath9k: remove the virtual wiphy debugfs interface
References: <1295562349-17161-1-git-send-email-nbd@openwrt.org> <4D38B990.50406@candelatech.com>
In-Reply-To: <4D38B990.50406@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-20 11:39 PM, Ben Greear wrote:
> On 01/20/2011 02:25 PM, Felix Fietkau wrote:
>> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>> ---
>>   drivers/net/wireless/ath/ath9k/debug.c |  202 --------------------------------
>>   1 files changed, 0 insertions(+), 202 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
>> index 3586c43..73644c4 100644
>> --- a/drivers/net/wireless/ath/ath9k/debug.c
>> +++ b/drivers/net/wireless/ath/ath9k/debug.c
>> @@ -381,204 +381,6 @@ static const struct file_operations fops_interrupt = {
>>   	.llseek = default_llseek,
>>   };
> 
> I think a lot of this could still be useful, even if it's named something
> other than wiphy, so please don't remove all the filter debug and
> similar...
Yeah, I overlooked that part. I'll send a v3

- Felix
