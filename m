Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49020 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1L0ODU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Dec 2011 09:03:20 -0500
Received: by vbbfc26 with SMTP id fc26so9036054vbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Dec 2011 06:03:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <C981C123-844A-4A16-8CD6-6C836E0C2974@gmail.com>
References: <20111219210724.27454.1642.stgit@bob.linux.org.uk>
	<C981C123-844A-4A16-8CD6-6C836E0C2974@gmail.com>
Date: Tue, 27 Dec 2011 15:03:19 +0100
Message-ID: <CAOZOX0X9_HLB3MbFC8qjoH34irBRfjmhk2DZBMBVg5ZMcOMBXw@mail.gmail.com> (sfid-20111227_150324_292481_99584977)
Subject: Re: [PATCH] rt2800: Add support for the Fujitsu Stylistic Q550
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2011 at 10:35 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> On 19 dec. 2011, at 22:07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>
>> From: Alan Cox <alan@linux.intel.com>
>>
>> Just another USB identifier.
>>
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>
> Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

>
>> ---
>>
>> drivers/net/wireless/rt2x00/rt2800usb.c |    2 ++
>> 1 files changed, 2 insertions(+), 0 deletions(-)
>>
>>
>> diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
>> index f156579..9e5556c 100644
>> --- a/drivers/net/wireless/rt2x00/rt2800usb.c
>> +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
>> @@ -1158,6 +1158,8 @@ static struct usb_device_id rt2800usb_device_table[] = {
>>    { USB_DEVICE(0x7392, 0x7722) },
>>    /* Encore */
>>    { USB_DEVICE(0x203d, 0x14a1) },
>> +    /* Fujitsu Stylistic 550 */
>> +    { USB_DEVICE(0x1690, 0x0761) },
>>    /* Gemtek */
>>    { USB_DEVICE(0x15a9, 0x0010) },
>>    /* Gigabyte */
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
