Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751980AbeEGNLE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 09:11:04 -0400
Received: from mail-qt0-f176.google.com (mail-qt0-f176.google.com [209.85.216.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F8C2204EE
        for <linux-wireless@vger.kernel.org>; Mon,  7 May 2018 13:11:03 +0000 (UTC)
Received: by mail-qt0-f176.google.com with SMTP id c2-v6so36082539qtn.9
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2018 06:11:03 -0700 (PDT)
MIME-Version: 1.0
References: <9481d7f7694345f2966e78c2284ee4a0@SC-EXCH02.marvell.com>
In-Reply-To: <9481d7f7694345f2966e78c2284ee4a0@SC-EXCH02.marvell.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 07 May 2018 13:10:51 +0000
Message-ID: <CA+5PVA6k+a=7Z9zOZktK_=J5ST9j8x7EVgaptGE0yX7qCeGxow@mail.gmail.com> (sfid-20180507_151118_250293_CEF871EF)
Subject: Re: pull-request mwifiex-firmware 2018-05-07
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

On Mon, May 7, 2018 at 8:31 AM Ganapathi Bhat <gbhat@marvell.com> wrote:

> The following changes since commit
5446916b53de395245d89400dea566055ec4502c:

>    linux-firmware: update Marvell PCIe-USB8897/8997 firmware image to add
WPA2 vulnerability fix (2018-01-16 01:45:00 -0800)

> are available in the git repository at:

>    git://git.marvell.com/mwifiex-firmware.git

> for you to fetch changes up to e1abab618308110789a4c27db543d132fd62e89f:

>    linux-firmware: update Marvell USB8997 firmware image to add WPA2
vulnerability fix (2018-05-07 17:54:42 +0530)

> ----------------------------------------------------------------
> Ganapathi Bhat (2):
>        linux-firmware: update Marvell SD8897-B0 firmware image to add WPA2
vulnerability fix
>        linux-firmware: update Marvell USB8997 firmware image to add WPA2
vulnerability fix

>   WHENCE                       |   4 ++--
>   mrvl/sd8897_uapsta.bin       | Bin 814048 -> 821024 bytes
>   mrvl/usbusb8997_combo_v4.bin | Bin 602100 -> 604536 bytes
>   3 files changed, 2 insertions(+), 2 deletions(-)

Thanks.  Pulled and pushed out.

josh
