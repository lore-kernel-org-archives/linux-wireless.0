Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58441 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2FRJRA convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 18 Jun 2012 05:17:00 -0400
Received: by bkcji2 with SMTP id ji2so3796905bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 02:16:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FD867DB.9070806@gmail.com>
References: <4FD867DB.9070806@gmail.com>
Date: Mon, 18 Jun 2012 17:16:40 +0800
Message-ID: <CALx5=V97QacZXoZ6XfwMc+scD05ixFAo7LBDYp0SjurAMzjsEA@mail.gmail.com> (sfid-20120618_111705_281277_2451E7EC)
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : RT3290 chip support v4
From: Matt Chen <machen@suse.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Woody.Hung@mediatek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/6/13 Xose Vazquez Perez <xose.vazquez@gmail.com>:
> Woody Hung wrote:
>
>> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
>> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
>> @@ -47,6 +47,7 @@
>>  * 8051 firmware image.
>>  */
>>  #define FIRMWARE_RT2860                        "rt2860.bin"
>> +#define FIRMWARE_RT3290                        "rt3290.bin"
>
>
> There is no rt3290 fw in linux-firmware [1]
> Please, send it ASAP.
Indeed, I found the firmware is only in
http://www.ralink.com.tw/en/04_support/support.php?sn=501, RT3290 PCIe
driver tar ball.

Hi Woody,
Please send the firmware to the linux-firmware ASAP. :)

> [1] http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
>
>
> _______________________________________________
> users mailing list
> users@rt2x00.serialmonkey.com
> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>



-- 
Thank you.
