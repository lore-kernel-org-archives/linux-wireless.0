Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:43389 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2FSD2W convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-wireless@vger.kernel.org:0:0>);
	Mon, 18 Jun 2012 23:28:22 -0400
Received: by bkcji2 with SMTP id ji2so4673567bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jun 2012 20:28:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <599E416D1C5C994980C45977191D726906AC82C5C2@MTKMBS03.mediatek.inc>
References: <4FD867DB.9070806@gmail.com>
	<CALx5=V97QacZXoZ6XfwMc+scD05ixFAo7LBDYp0SjurAMzjsEA@mail.gmail.com>
	<599E416D1C5C994980C45977191D726906AC82C5C2@MTKMBS03.mediatek.inc>
Date: Tue, 19 Jun 2012 11:28:09 +0800
Message-ID: <CALx5=V-q+5AdgUH549VsdBepDzFokAdiOSmEsOU5uVDOS=QY0w@mail.gmail.com> (sfid-20120619_052825_332239_8CDCDBE0)
Subject: Re: [rt2x00-users] [PATCH] rt2x00 : RT3290 chip support v4
From: Matt Chen <machen@suse.com>
To: =?Big5?B?V29vZHkgSHVuZyAorHis7qbLKQ==?= <woody.hung@mediatek.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=Big5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Woody,

2012/6/19 Woody Hung (¬x¬î¦Ë) <woody.hung@mediatek.com>:
> Dear All:
>
>        I have send it to the http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git.
>        And it have been applied 3 days ago.
>        Please see the short log "rt2800pci:Firmware update v1".
>        Do I miss something or some rule I need to follow???
I see. I found it in the
http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git.
I tested this patch and firmware, it works fine to me here. :)
> BR,
> Woody Hung
> -----Original Message-----
> From: Matt Chen [mailto:machen@suse.com]
> Sent: Monday, June 18, 2012 5:17 PM
> To: Xose Vazquez Perez
> Cc: linux-wireless@vger.kernel.org; users@rt2x00.serialmonkey.com; Woody Hung (¬x¬î¦Ë)
> Subject: Re: [rt2x00-users] [PATCH] rt2x00 : RT3290 chip support v4
>
> 2012/6/13 Xose Vazquez Perez <xose.vazquez@gmail.com>:
>> Woody Hung wrote:
>>
>>> --- a/drivers/net/wireless/rt2x00/rt2800pci.h
>>> +++ b/drivers/net/wireless/rt2x00/rt2800pci.h
>>> @@ -47,6 +47,7 @@
>>>  * 8051 firmware image.
>>>  */
>>>  #define FIRMWARE_RT2860                        "rt2860.bin"
>>> +#define FIRMWARE_RT3290                        "rt3290.bin"
>>
>>
>> There is no rt3290 fw in linux-firmware [1] Please, send it ASAP.
> Indeed, I found the firmware is only in
> http://www.ralink.com.tw/en/04_support/support.php?sn=501, RT3290 PCIe driver tar ball.
>
> Hi Woody,
> Please send the firmware to the linux-firmware ASAP. :)
>
>> [1]
>> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
>>
>>
>> _______________________________________________
>> users mailing list
>> users@rt2x00.serialmonkey.com
>> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmon
>> key.com
>>
>
>
>
> --
> Thank you.
>


-- 
Thank you.
