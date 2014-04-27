Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45369 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaD0VfS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2014 17:35:18 -0400
Received: by mail-wi0-f180.google.com with SMTP id q5so4798605wiv.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2014 14:35:16 -0700 (PDT)
Message-ID: <535D7813.80100@gmail.com> (sfid-20140427_233555_716644_AD9AF7F3)
Date: Sun, 27 Apr 2014 23:35:15 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Firmware(rtl8723befw.bin) for the Realtek 8723BE 802.11n PCI
 wireless(rtl8723be)
References: <535D5712.6000106@gmail.com> <535D692C.7080905@lwfinger.net>
In-Reply-To: <535D692C.7080905@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27.04.2014 22:31, Larry Finger wrote:
> On 04/27/2014 02:14 PM, poma wrote:
>>
>> Ahoy!
>>
>> Firmware(rtl8723befw.bin) for the Realtek 8723BE 802.11n PCI
>> wireless(rtl8723be)
>> missing in the "Repository of firmware blobs for use with the Linux kernel".
>> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/rtlwifi
>> rtl8723befw.bin?
>>
>>
>> $ modinfo rtl8723be
>> filename:
>> /lib/modules/3.15.0-0.rc2.git3.1.fc21.x86_64/kernel/drivers/net/wireless/rtlwifi/rtl8723be/rtl8723be.ko
>> firmware:       rtlwifi/rtl8723befw.bin
>> description:    Realtek 8723BE 802.11n PCI wireless
>> license:        GPL
>> ...
>>
>>
>> However attending in the "Code for new variety of the 8723 PCI cards -
>> temp until code added to kernel"
>> https://github.com/lwfinger/rtl8723be/tree/master/firmware/rtlwifi
>> rtl8723befw.bin
> 
> Thanks for this note. I thought that I had sent the firmware to git repo at 
> git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git, but that 
> was not correct until now. Within a few days, it should be in the repo. Until 
> then, it can be gotten through the GitHub link posted above.
> 
> Larry
> 

OK, thanks.


poma


