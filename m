Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ipout1-voc1esa.cbr1.mail-filtering.com.au ([117.55.234.241]:52853
        "EHLO o-voc1esa.cbr1.mail-filtering.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754677AbdERJWh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 05:22:37 -0400
Subject: Re: [PATCH] rt2800usb: Add Epson wireless adapter device-id
To: Kalle Valo <kvalo@codeaurora.org>
References: <8e00714b-ab62-15e9-e86a-e0de5009797d@records.headdesk.com.au>
 <87shk267jc.fsf@purkki.adurom.net>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        helmut.schaa@googlemail.com
From: =?UTF-8?Q?Tom_Gaudasi=c5=84ski?= <tomg@records.headdesk.com.au>
Message-ID: <8177522a-e1c0-353a-8ce7-d7506415b6d7@records.headdesk.com.au> (sfid-20170518_112250_788661_8CE3B986)
Date: Thu, 18 May 2017 18:46:14 +1000
MIME-Version: 1.0
In-Reply-To: <87shk267jc.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is it advisable to re-submit with the noted corrections fixed?


On 18/05/17 15:47, Kalle Valo wrote:
> Tom Gaudasiński <tomg@records.headdesk.com.au> writes:
>
>> Make Epson WN7512BEP work by adding its device-id to rt2800usb. Device
>> contains a Ralink RT3071L, registers as vendor Accton/Arcadyan.
>>
>> Signed-off-by: Tom Gaudasinski <tomg@records.headdesk.com.au>
> The prefix should be "rt2x00:".
>
>> --- linux/drivers/net/wireless/ralink/rt2x00/rt2800usb.c.orig   
>> 2017-05-17 19:49:44.893895819 +1000
>> +++ linux/drivers/net/wireless/ralink/rt2x00/rt2800usb.c    2017-05-17
>> 19:49:32.906111192 +1000
>> @@ -1156,6 +1156,8 @@ static struct usb_device_id rt2800usb_de
>>      { USB_DEVICE(0x2001, 0x3c17) },
>>      /* Panasonic */
>>      { USB_DEVICE(0x083a, 0xb511) },
>> +    /* Accton/Arcadyan/Epson */
>> +    { USB_DEVICE(0x083a, 0xb512) },
> The patch looks to be corrupted, didn't it test it though. Better use
> 'git send-email' to submit patches.
>
