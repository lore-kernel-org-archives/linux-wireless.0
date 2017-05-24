Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752602AbdEXNj0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:39:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,01/11] rsi: Rename file rsi_91x_pkt.c to rsi_91x_hal.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1494928877-27168-2-git-send-email-amit.karwar@redpinesignals.com>
References: <1494928877-27168-2-git-send-email-amit.karwar@redpinesignals.com>
To: amit karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Message-Id: <20170524133925.EA18060953@smtp.codeaurora.org> (sfid-20170524_154007_001028_904DB58E)
Date: Wed, 24 May 2017 13:39:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

amit karwar <amitkarwar@gmail.com> wrote:
> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> The file rsi_91x_hal.c is going to contain device specific code i.e new
> firmware loading method for RS9113 chipset. As the file rsi_91x_pkt.c
> contains code to prepare device specific descriptors for transmit packet,
> this file is renamed to rsi_91x_hal.c which is more relevant as per it's
> functionality.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

11 patches applied to wireless-drivers-next.git, thanks.

d7af6bb7e527 rsi: Rename file rsi_91x_pkt.c to rsi_91x_hal.c
897d341dee4f rsi: Changes to sdio reads and writes
7bdead7ae944 rsi: define RSI_USB_BUF_SIZE macro
2fbbe5179ebe rsi: Changes in USB read and write operations
4b1fc881173e rsi: use macros in USB specific code
ea3336ac0094 rsi: Handle usb multi-byte write failure case properly
88fa51e1b33c rsi: Add usb multi-byte read operation
a2ce952c8e09 rsi: Add host interface operations as separate structure.
b97e9b94ad75 rsi: Add new host interface operations
b78e91bcfb33 rsi: Add new firmware loading method
5578b1ffdc30 rsi: Remove old firmware loading method

-- 
https://patchwork.kernel.org/patch/9728767/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
