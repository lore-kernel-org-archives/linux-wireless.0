Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:32940 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbbBGTIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 14:08:51 -0500
Received: by iecrl12 with SMTP id rl12so8509019iec.0
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2015 11:08:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54D6487D.1020607@lwfinger.net>
References: <1423305971-8360-1-git-send-email-leon.nardella@gmail.com>
	<54D6487D.1020607@lwfinger.net>
Date: Sat, 7 Feb 2015 17:08:50 -0200
Message-ID: <CABLm8Yh3H_=s-c8ZfdMYmBDseqEj51DdSgjfZsRFPi9voW_4rg@mail.gmail.com> (sfid-20150207_200854_916830_ECC50148)
Subject: Re: [PATCH] * Add support for Philips (or NXP) PTA01 Wireless Adapter
From: Leon Nardella <leon.nardella@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry,


Thank for your remarks! I'll submit it again!



Att,

Leon Nardella

On Sat, Feb 7, 2015 at 3:16 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 02/07/2015 04:46 AM, Leon Nardella wrote:
>>
>> Signed-off-by: Leon Nardella <leon.nardella@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/hif_usb.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c
>> b/drivers/net/wireless/ath/ath9k/hif_usb.c
>> index 8e7153b..10c02f5 100644
>> --- a/drivers/net/wireless/ath/ath9k/hif_usb.c
>> +++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
>> @@ -40,6 +40,7 @@ static struct usb_device_id ath9k_hif_usb_ids[] = {
>>         { USB_DEVICE(0x0cf3, 0xb003) }, /* Ubiquiti WifiStation Ext */
>>         { USB_DEVICE(0x0cf3, 0xb002) }, /* Ubiquiti WifiStation */
>>         { USB_DEVICE(0x057c, 0x8403) }, /* AVM FRITZ!WLAN 11N v2 USB */
>> +       { USB_DEVICE(0x0471, 0x209e) }, /* Philips (or NXP) PTA01 */
>>
>>         { USB_DEVICE(0x0cf3, 0x7015),
>>           .driver_info = AR9287_USB },  /* Atheros */
>
>
> Leon,
>
> Your patch is correct, but your subject and commit message needs a little
> work.
>
> When I add a new USB ID for a driver, my subject usually includes the driver
> name followed by a colon, and the "Add new USB ID". In your case, that would
> be "[PATCH] ath9k_htc: Add new USB ID". Then in the commit message I include
> the make and model of the device, and some indication of why that device ID
> should be added. For example, was that ID found in a Windows driver?
> Finally, indicate that the patch has been tested. Such a statement should
> not be necessary, but recently there have been a number of patches submitted
> that have not been tested on real hardware.
>
> Larry
>
>
