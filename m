Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:52323 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbeEPIzD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 04:55:03 -0400
Received: by mail-wm0-f68.google.com with SMTP id w194-v6so9880wmf.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 01:55:03 -0700 (PDT)
Subject: Re: [PATCH 4/8] mwifiex: support sysfs initiated device coredump
References: <1526375691-31789-5-git-send-email-arend.vanspriel@broadcom.com>
 <201805160424.9rVs4AKw%fengguang.wu@intel.com>
Cc: linux-wireless@vger.kernel.org
To: Kalle Valo <kvalo@codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AFBF1E5.7000505@broadcom.com> (sfid-20180516_105510_974538_5CCCAECB)
Date: Wed, 16 May 2018 10:55:01 +0200
MIME-Version: 1.0
In-Reply-To: <201805160424.9rVs4AKw%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/15/2018 10:22 PM, kbuild test robot wrote:
> Hi Arend,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on next-20180515]
> [cannot apply to wireless-drivers-next/master wireless-drivers/master bluetooth-next/master v4.17-rc5 v4.17-rc4 v4.17-rc3 v4.17-rc5]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Arend-van-Spriel/brcmfmac-coredump-functionality-and-fixes/20180515-233022
> config: i386-allmodconfig (attached as .config)
> compiler: gcc-7 (Debian 7.3.0-16) 7.3.0
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>     WARNING: modpost: missing MODULE_LICENSE() in sound/soc/omap/snd-soc-sdma.o
>     see include/linux/module.h for more information
>>> ERROR: "mwifiex_send_cmd" [drivers/net/wireless/marvell/mwifiex/mwifiex_usb.ko] undefined!

Yikes. Missed that. In my build this is a warning which I overlooked. Is 
there some Kconfig to make it an ERROR like above?

You applied the first patch so should I resubmit all other patches?

Regards,
Arend
