Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38022 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757204Ab1DHPHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:07:54 -0400
Received: by fxm17 with SMTP id 17so2390313fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Apr 2011 08:07:53 -0700 (PDT)
Message-ID: <4D9F2462.60600@gmail.com>
Date: Fri, 08 Apr 2011 19:06:10 +0400
From: Igor Plyatov <plyatov@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	George <george0505@realtek.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: net/wireless/rtlwifi: problem with D-link DWA-131 USB adapter
References: <4D9F0DAE.30809@gmail.com> <4D9F14FE.8060905@lwfinger.net>
In-Reply-To: <4D9F14FE.8060905@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Larry,

> The driver rtl8192cu is for the RTL8192CU/RTL8188CU chips. The DWA-131 
> contains an RTL8192SU chip. It cannot be driven by rtl8192cu - it will 
> never work.
>
> On my TODO list is the preparation of a driver named rtl8192su, but 
> since r8712u works, the priority is low. I'm much more interested in 
> getting the drivers for the RTL8192SE and RTL8192DE chips into the 
> kernel. Note that rtl8192su will share a lot of code with rtl8192se in 
> the same fashion that rtl8192ce and rtl8192cu share routines.
>
> When I prepared the r8712u driver for staging, I did not worry about 
> the LED, which is why it doesn't blink. What kind of LED action do you 
> prefer. Some users only want the LED on when the interface is active 
> and complain when it blinks. Others want it to blink when transmitting.
>
> Larry

Thank you for descriptive answer!

Is there any way to detect Realtek chipset type by some means like lsusb 
or else?

Best regards!
--
Igor Plyatov
