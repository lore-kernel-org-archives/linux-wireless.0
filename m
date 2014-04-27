Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:43211 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaD0Ubm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2014 16:31:42 -0400
Received: by mail-ob0-f182.google.com with SMTP id uy5so6392488obc.41
        for <linux-wireless@vger.kernel.org>; Sun, 27 Apr 2014 13:31:41 -0700 (PDT)
Message-ID: <535D692C.7080905@lwfinger.net> (sfid-20140427_223145_020521_FE5A7E25)
Date: Sun, 27 Apr 2014 15:31:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Firmware(rtl8723befw.bin) for the Realtek 8723BE 802.11n PCI
 wireless(rtl8723be)
References: <535D5712.6000106@gmail.com>
In-Reply-To: <535D5712.6000106@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/27/2014 02:14 PM, poma wrote:
>
> Ahoy!
>
> Firmware(rtl8723befw.bin) for the Realtek 8723BE 802.11n PCI
> wireless(rtl8723be)
> missing in the "Repository of firmware blobs for use with the Linux kernel".
> https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/rtlwifi
> rtl8723befw.bin?
>
>
> $ modinfo rtl8723be
> filename:
> /lib/modules/3.15.0-0.rc2.git3.1.fc21.x86_64/kernel/drivers/net/wireless/rtlwifi/rtl8723be/rtl8723be.ko
> firmware:       rtlwifi/rtl8723befw.bin
> description:    Realtek 8723BE 802.11n PCI wireless
> license:        GPL
> ...
>
>
> However attending in the "Code for new variety of the 8723 PCI cards -
> temp until code added to kernel"
> https://github.com/lwfinger/rtl8723be/tree/master/firmware/rtlwifi
> rtl8723befw.bin

Thanks for this note. I thought that I had sent the firmware to git repo at 
git://git.kernel.org/pub/scm/linux/kernel/git/dwmw2/linux-firmware.git, but that 
was not correct until now. Within a few days, it should be in the repo. Until 
then, it can be gotten through the GitHub link posted above.

Larry

