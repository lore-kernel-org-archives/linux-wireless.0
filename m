Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53858 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYHgW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 03:36:22 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: <pkshih@realtek.com>
Cc: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 00/19] rtlwifi: halmac: Add new module halmac
References: <20180425020820.6141-1-pkshih@realtek.com>
Date: Wed, 25 Apr 2018 10:36:17 +0300
In-Reply-To: <20180425020820.6141-1-pkshih@realtek.com> (pkshih@realtek.com's
        message of "Wed, 25 Apr 2018 10:08:01 +0800")
Message-ID: <87lgdbagb2.fsf@kamboji.qca.qualcomm.com> (sfid-20180425_093625_788660_D825C18E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<pkshih@realtek.com> writes:

> From: Ping-Ke Shih <pkshih@realtek.com>
>
> v3: patch 06/17 in v2 is too big, so mail server may block the mail.
>     In this patchset, I decompose the patch into three patches 06/19-08/19,
>     so in patchset view v2 and v3 are identical.

I can confirm, all patches made it to patchwork now.

> v2: remove indirection to get halmac ops
>     Only patches 1/17 and 11/17 are changed.
>
> Patches 1/19-3/19 are added structure to support this module.
> Patches 4/19-18/19 add new files.
> Patch 19/19 add this module to Makefile and Kconfig.
>
> Ping-Ke Shih (19):
>   rtlwifi: add halmac structure to wifi.h
>   rtlwifi: add debug ID COMP_HALMAC
>   rtlwifi: add dmdef.h to share with driver and other modules
>   rtlwifi: halmac: add main definition used by halmac
>   rtlwifi: halmac: describe number and size of chip functions
>   rtlwifi: halmac: add register definitions
>   rtlwifi: halmac: add bit field definitions
>   rtlwifi: halmac: add bit field definitions of rtl8822b
>   rtlwifi: halmac: add definition of TX/RX descriptor
>   rtlwifi: halmac: add GPIO pin/pinmux definitions
>   rtlwifi: halmac: add power sequence to turn on/off wifi card
>   rtlwifi: halmac: access efuse through halmac helper functions
>   rtlwifi: halmac: add files to implement halmac ops
>   rtlwifi: halmac: add halmac init/deinit functions
>   rtlwifi: halmac: add firmware related functions and definitions
>   rtlwifi: halmac: add bus interface commands
>   rtlwifi: halmac: add to control WiFi mac functions and registers
>   rtlwifi: halmac: add to support BB and RF functions
>   rtlwifi: add halmac to Makefile and Kconfig

You are adding a new component to rtlwifi but there's no introduction in
the cover letter. Why is this needed? For what hardware is it for? What
new features does it bring?

>  77 files changed, 64201 insertions(+)

This is a huge patchset, I'm not even sure if I want to start reviewing
this. Especially when I have no clue about the big picture (which should
be described in the cover letter). 

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#too_many_patches

And I even read all 19 commit logs and there was no mention of why this
is needed either. I cannot just blindly apply patches without knowing
what they do.

-- 
Kalle Valo
