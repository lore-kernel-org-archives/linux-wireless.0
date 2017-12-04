Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbdLDKBF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 05:01:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vincent Legoll <vincent.legoll@gmail.com>
Cc: m@bues.ch, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Make SSB a menuconfig to ease disabling it all
References: <20171203211921.20233-1-vincent.legoll@gmail.com>
Date: Mon, 04 Dec 2017 12:01:00 +0200
In-Reply-To: <20171203211921.20233-1-vincent.legoll@gmail.com> (Vincent
        Legoll's message of "Sun, 3 Dec 2017 22:19:20 +0100")
Message-ID: <87efoan76r.fsf@purkki.adurom.net> (sfid-20171204_110122_632413_48BEC21F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vincent Legoll <vincent.legoll@gmail.com> writes:

> The following patch makes it easier to disable all SSB config
> options without entering the submenu. It will also enable one
> to see that en-disabled state from the outside menu.
>
> This is only intended to change menuconfig UI, not change
> the config dependencies.

So you have just oneliners as the commit log in the patch and here in
the cover letter you have a better description. As the cover letters are
not normally archived to the git repository it's better to have the
proper log in the commit log.

Also prefix the title with "ssb: " like other patches have done:

$ git log --oneline -10 drivers/ssb/
b24413180f56 License cleanup: add SPDX GPL-2.0 license identifier to files with no license
c6c092dcb21e ssb: Delete an error message for a failed memory allocation in ssb_devices_register()
8052d7245b60 ssb: Fix error routine when fallback SPROM fails
c683ffe2193b SSB: Change bare unsigned to unsigned int to suit coding style
2d4443be10a7 ssb: gpio_driver: use gpiochip data pointer
10da848f67a7 ssb: host_soc depends on sprom
b7e2d195cc52 ssb: mark ssb_bus_register as __maybe_unused
541c9a84cd85 ssb: pick SoC invariants code from MIPS BCM47xx arch
845da6e58e19 ssb: add Kconfig entry for compiling SoC related code
830c7df46247 ssb: move functions specific to SoC hosted bus to separated file

-- 
Kalle Valo
