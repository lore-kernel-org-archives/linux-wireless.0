Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51893 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2FTK3c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 06:29:32 -0400
Received: by vcbf11 with SMTP id f11so3724930vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2012 03:29:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALx5=V-+aCcOMXHPrxmqVHwaiosNurT17gHBTi0mTdYJ6bZRMA@mail.gmail.com>
References: <CALx5=V--5TEC2J39xdJn1fxLbmgEXsWwxbAVaXMsw=Lk2WxKRg@mail.gmail.com>
	<CAD2nsn04Bi5aNMBMLWGm9uQwTXzT8GnDfHZcBP8-+vMEgqBCag@mail.gmail.com>
	<CALx5=V-MEZVNkQ0SqqtLqBcDG_Dkp1V6XjiZEv4BBSVn9JQpCw@mail.gmail.com>
	<CALx5=V-L83VUcRddP=hk_vB4AK5+uZ5Gcdbg+HSbhvqNurrMbQ@mail.gmail.com>
	<CAD2nsn35gDLLP3Wkn9qpG5UhxUGPOcn1q_kpP2WexjQ1+LvXFg@mail.gmail.com>
	<CALx5=V-+aCcOMXHPrxmqVHwaiosNurT17gHBTi0mTdYJ6bZRMA@mail.gmail.com>
Date: Wed, 20 Jun 2012 15:59:31 +0530
Message-ID: <CAD2nsn2KrgLh-Oth-npUjY59bh2ycpEv7UocfXH0uE27TD19fQ@mail.gmail.com> (sfid-20120620_122935_668993_AB54FD63)
Subject: Re: Atheros [168c 0034] can't enable wireless button LED.
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Matt,

> Both 0x2f and 0x2d can work fine to me of enabling
> wiphy_rfkill_start_polling() in gpio.c:ath_start_rfkill_poll().
>
> 1) with 0x2f
>   0x404c address would change when press wifi button
>   rfkill block : yes -> 0x00000455
>   rfkill block : no   -> 0x00000c55
> 2) with 0x2d
>   0x404c address would change when press wifi button
>   rfkill block : yes -> 0x00000455
>   rfkill block : no   -> 0x00000c55
>
>
> But I don't see the LED is changing, it is staying OFF (Amber).

not sure about that, but i think rfkill is working for both of us
i told 0xeed changes to 0x6ed for me

you got 0x455 changes to 0xc55

BIT 12(GPIO pin 11 seems to toggle  4 ->C), you can confirm by rfkill list

-- 
thanks,
shafi
