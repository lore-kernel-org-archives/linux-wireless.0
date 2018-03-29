Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751008AbeC2M3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 08:29:16 -0400
From: "Dedy Lansky" <dlansky@codeaurora.org>
To: "'David Dean'" <daviddean166@gmail.com>,
        <linux-wireless@vger.kernel.org>
References: <CAFnQ7os8AQGwJfkunZG-x9f9jdnOw=tjGCHE9wNxNwLfqka_tQ@mail.gmail.com>
In-Reply-To: <CAFnQ7os8AQGwJfkunZG-x9f9jdnOw=tjGCHE9wNxNwLfqka_tQ@mail.gmail.com>
Subject: RE: wil6210: low level sector API
Date: Thu, 29 Mar 2018 15:29:12 +0300
Message-ID: <001901d3c759$8cd5b970$a6812c50$@codeaurora.org> (sfid-20180329_142920_309938_42E9AFCA)
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: linux-wireless-owner@vger.kernel.org =
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of David Dean
Sent: Monday, March 26, 2018 9:38 PM

> My question is how I can disable TXSS. One way I found in the wmi.h is =
setting the number of sectors of TXSS to 0 or 1 > by using =
wmi_prio_tx_sectors_num_cmd so that the TXSS will only use 1 sector.
> However, when I called this cmd, I got this error:
> wil6210 0000:03:00.0 wlp3s0: wil6210_irq_misc: Firmware error =
detected, assert codes FW 0x00001038, UCODE 0x00000000
> wil6210 0000:03:00.0 wlp3s0: wil_fw_core_dump: fw core dumped, size =
823296 bytes
> wil6210 0000:03:00.0 wlp3s0: wil_notify_fw_error: Notify about =
firmware error
> So I am wondering whether the firmware does not support these kinds of =
wmi commands. Does anyone have any experience on this? Thank you.

Indeed this error indicates that FW doesn't support these WMI commands.
We are working on releasing new FW version with support for these =
commands.

Thanks,
 Dedy.
