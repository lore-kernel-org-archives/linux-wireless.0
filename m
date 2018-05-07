Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751005AbeEGMVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 08:21:06 -0400
Received: from mail-qk0-f176.google.com (mail-qk0-f176.google.com [209.85.220.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BD5B2173F
        for <linux-wireless@vger.kernel.org>; Mon,  7 May 2018 12:21:05 +0000 (UTC)
Received: by mail-qk0-f176.google.com with SMTP id s70so21632414qks.13
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2018 05:21:05 -0700 (PDT)
MIME-Version: 1.0
References: <76132c14dc564054af97f3355dddf4e7@SC-EXCH02.marvell.com>
In-Reply-To: <76132c14dc564054af97f3355dddf4e7@SC-EXCH02.marvell.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 07 May 2018 12:20:54 +0000
Message-ID: <CA+5PVA6PhygeHtm9duGWZA1GtXjbAKNgyU8gUKiphkyAt9NWOw@mail.gmail.com> (sfid-20180507_142109_747846_9740945D)
Subject: Re: pull-request mwifiex-firmware 2018-05-04
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        James Cao <jcao@marvell.com>, mmangesh@marvell.com,
        spatki@marvell.com, rprashk@marvell.com, mayur@marvell.com,
        jayrao@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 4, 2018 at 3:34 AM Ganapathi Bhat <gbhat@marvell.com> wrote:

> The following changes since commit
5446916b53de395245d89400dea566055ec4502c:

>    linux-firmware: update Marvell PCIe-USB8897/8997 firmware image to add
WPA2 vulnerability fix (2018-01-16 01:45:00 -0800)

> are available in the git repository at:

>    git://git.marvell.com/mwifiex-firmware.git

> for you to fetch changes up to 8b2f89bba6e8330c484f9ad39367d8efd42d23b4:

>    linux-firmware: update Marvell USB8997 firmware image to add WPA2
vulnerability fix (2018-05-04 12:51:40 +0530)

> ----------------------------------------------------------------
> Ganapathi Bhat (2):
>        linux-firmware: update Marvell SD8897-B0 firmware image to add WPA2
vulnerability fix
>        linux-firmware: update Marvell USB8997 firmware image to add WPA2
vulnerability fix

Both of those commits are missing the Signed-off-by: tag.  Can you add it
please?

josh


> WHENCE                       |   4 ++--
> mrvl/sd8897_uapsta.bin       | Bin 814048 -> 821024 bytes
> mrvl/usbusb8997_combo_v4.bin | Bin 602100 -> 604536 bytes
> 3 files changed, 2 insertions(+), 2 deletions(-)
