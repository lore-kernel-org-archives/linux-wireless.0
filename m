Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:45284 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973Ab2DHRhZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 13:37:25 -0400
Received: by vcqp1 with SMTP id p1so1422902vcq.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 10:37:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F81C0D4.2090004@lwfinger.net>
References: <CAA2SeN+7FsyQKmCK62tzEzrHLVi6-H21wZ+bdTjS2rLDDdauCA@mail.gmail.com>
	<4F81C0D4.2090004@lwfinger.net>
Date: Sun, 8 Apr 2012 19:37:25 +0200
Message-ID: <CAA2SeNKEFDtciKU29Lwi5kJYy5eaVeFb6cJg33T4QKP2=oCdSA@mail.gmail.com> (sfid-20120408_193759_894607_69433844)
Subject: Re: [PATCH] rtlwifi: ID for Belkin Surf N300 XR
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 04/08/2012 11:00 AM, Lorenzo Bianconi wrote:
>>
>> Hi,
>>
>> I added ID for Belkin Surf N300 XR wireless usb adapter to rtlwifi driver.
>>
>> Regards
>>
>> Lorenzo
>>
>> Signed-off-by: Lorenzo Bianconi<lorenzo.bianconi83@gmail.com>
>> ---
>> --- a/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>> +++ b/drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
>> @@ -340,6 +340,7 @@
>>        /****** 8192CU ********/
>>        {RTL_USB_DEVICE(0x050d, 0x2102, rtl92cu_hal_cfg)},
>> /*Belcom-Sercomm*/
>>        {RTL_USB_DEVICE(0x050d, 0x2103, rtl92cu_hal_cfg)},
>> /*Belcom-Edimax*/
>> +       {RTL_USB_DEVICE(0x050d, 0x1004, rtl92cu_hal_cfg)},
>> /*Belkin-SurfN300*/
>>        {RTL_USB_DEVICE(0x0586, 0x341f, rtl92cu_hal_cfg)}, /*Zyxel
>> -Abocom*/
>>        {RTL_USB_DEVICE(0x07aa, 0x0056, rtl92cu_hal_cfg)}, /*ATKK-Gemtek*/
>>        {RTL_USB_DEVICE(0x07b8, 0x8178, rtl92cu_hal_cfg)}, /*Funai
>> -Abocom*/
>
>
> Thanks for the patch, but I have some comments.
>
> Anything you state above the first --- delimiter ends up in the permanent
> commit message in the kernel. I doubt that you wanted your little note to be
> in that category.
>
> I try to keep the USB IDs sorted by device type, and in numerical order
> within a type. Are you sure your device is an 8192CU, and not an 8188CU?
> Belcom has used both. Is the one you have an F7D2101? Does 'lsusb' say
> anything about what chip is used?
>
> Larry

My device is F9L1004az. lsusb reports just Vendor and Product ID. I
suppose the device is 8192CU because Windows driver is rtl8192cu.

I will rewrite the patch respecting the numerical order

Regards

Lorenzo
