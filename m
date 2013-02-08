Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:58393 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab3BHSu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 13:50:29 -0500
Message-ID: <511548F2.5090602@lwfinger.net> (sfid-20130208_195218_946170_9FC4C43D)
Date: Fri, 08 Feb 2013 12:50:26 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Add new USB ID
References: <1360348098-8687-1-git-send-email-Larry.Finger@lwfinger.net> <1360348677.2268.7.camel@joe-AO722>
In-Reply-To: <1360348677.2268.7.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2013 12:37 PM, Joe Perches wrote:
> On Fri, 2013-02-08 at 12:28 -0600, Larry Finger wrote:
>> A new model of the RTL8188CUS has appeared.
> []
>> diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>> index 577c0dc..a73a17b 100644
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>> @@ -285,6 +285,7 @@ static struct usb_device_id rtl8192c_usb_ids[] = {
>>   	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)},
>>   	/* RTL8188CUS-VL */
>>   	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x818a, rtl92cu_hal_cfg)},
>> +	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x819a, rtl92cu_hal_cfg)},
>>   	/* 8188 Combo for BC4 */
>>   	{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x8754, rtl92cu_hal_cfg)},
>
> One day would you please do a s/_VENDOR_/_VENDOR_/g

Sure, even though that particular command would not accomplish what you want. I 
know what you meant. :)

Larry


