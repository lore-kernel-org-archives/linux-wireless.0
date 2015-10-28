Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:3157 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122AbbJ1H17 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 03:27:59 -0400
Message-ID: <563079AE.1090006@atmel.com> (sfid-20151028_082812_590951_93999615)
Date: Wed, 28 Oct 2015 16:30:54 +0900
From: glen lee <glen.lee@atmel.com>
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: <gregkh@linuxfoundation.org>, <devel@driverdev.osuosl.org>,
	<austin.shin@atmel.com>, <linux-wireless@vger.kernel.org>,
	<Nicolas.FERRE@atmel.com>, <adel.noureldin@atmel.com>,
	<tony.cho@atmel.com>, <leo.kim@atmel.com>,
	<adham.abozaeid@atmel.com>
Subject: Re: [PATCH 06/80] staging: wilc1000: host_interface: removes unused
 functions
References: <1446015640-29398-1-git-send-email-glen.lee@atmel.com> <1446015640-29398-6-git-send-email-glen.lee@atmel.com> <20151028072113.GD3649@sudip-pc>
In-Reply-To: <20151028072113.GD3649@sudip-pc>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2015년 10월 28일 16:21, Sudip Mukherjee wrote:
> On Wed, Oct 28, 2015 at 03:59:26PM +0900, Glen Lee wrote:
>> From: Leo Kim <leo.kim@atmel.com>
>>
>> This patch removes unused functions at host_interface files.
>>   - host_int_send_join_leave_info_to_host
>>   - host_int_send_network_info_to_host
>>
>> Signed-off-by: Leo Kim <leo.kim@atmel.com>
>> Signed-off-by: Glen Lee <glen.lee@atmel.com>
>> ---
>>   drivers/staging/wilc1000/host_interface.c | 11 ----------
>>   drivers/staging/wilc1000/host_interface.h | 34 -------------------------------
>>   2 files changed, 45 deletions(-)
>>
>> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
>> index c3826eb..7f29abd 100644
>> --- a/drivers/staging/wilc1000/host_interface.c
>> +++ b/drivers/staging/wilc1000/host_interface.c
>> @@ -4037,11 +4037,6 @@ s32 hif_get_cfg(struct host_if_drv *hif_drv, u16 u16WID, u16 *pu16WID_Value)
>>   	return result;
>>   }
>>   
>> -void host_int_send_join_leave_info_to_host
>> -	(u16 assocId, u8 *stationAddr, bool joining)
>> -{
>> -}
>> -
>>   static void GetPeriodicRSSI(unsigned long arg)
>>   {
>>   	struct host_if_drv *hif_drv = (struct host_if_drv *)arg;
>> @@ -4070,12 +4065,6 @@ static void GetPeriodicRSSI(unsigned long arg)
>>   	mod_timer(&periodic_rssi, jiffies + msecs_to_jiffies(5000));
>>   }
>>   
>> -
>> -void host_int_send_network_info_to_host
>> -	(u8 *macStartAddress, u16 u16RxFrameLen, s8 s8Rssi)
>> -{
>> -}
>> -
>>   s32 host_int_init(struct net_device *dev, struct host_if_drv **hif_drv_handler)
> In my staging tree this is:
> s32 host_int_init(struct host_if_drv **hif_drv_handler)
>
> Is this patchseries dependent on some previous unapplied patch?

Yes, there are 27 patch series which are unapplied yet.
Please refer to the following patch.
[PATCH V2 13/27] staging: wilc1000: host_int_init: add argument net_device

>
> regards
> sudip

