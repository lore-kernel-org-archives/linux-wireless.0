Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:58382 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab0K2KOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 05:14:54 -0500
Message-ID: <4CF37D29.8090701@ti.com>
Date: Mon, 29 Nov 2010 12:15:05 +0200
From: Shahar Levi <shahar_levi@ti.com>
MIME-Version: 1.0
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH v3] wl12xx: BA Initiator support
References: <1290616180-16473-1-git-send-email-shahar_levi@ti.com> <1291023948.4284.4432.camel@wimaxnb.nmp.nokia.com>
In-Reply-To: <1291023948.4284.4432.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/29/2010 11:45 AM, Juuso Oikarinen wrote:
> On Wed, 2010-11-24 at 18:29 +0200, ext Shahar Levi wrote:
>> Add 80211n BA initiator session support wl1271 driver.
>> BA initiator session management included in FW independently.
>>
>> Signed-off-by: Shahar Levi<shahar_levi@ti.com>
>> ---
>> diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
>> index 75a6306..c511dce 100644
>> --- a/drivers/net/wireless/wl12xx/acx.h
>> +++ b/drivers/net/wireless/wl12xx/acx.h
>> @@ -1046,6 +1046,40 @@ struct wl1271_acx_ht_information {
>>   	u8 padding[3];
>>   } __packed;
>>
>> +#define BA_RECEIVER_WIN_SIZE 8
>
> This seems to be used only to configure the initiator mode window size,
> so why is the macro called BA_RECEIVER_WIN_SIZE?
should be change to BA_WIN_SIZE. will be fix on v2
Thanks.

>
> -Juuso
>

