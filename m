Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731160AbeG0QbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 12:31:13 -0400
Received: from mail-qt0-f170.google.com (mail-qt0-f170.google.com [209.85.216.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8327208B2
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2018 15:08:52 +0000 (UTC)
Received: by mail-qt0-f170.google.com with SMTP id e19-v6so5345266qtp.8
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jul 2018 08:08:52 -0700 (PDT)
MIME-Version: 1.0
References: <fa9898c2c9cf45758c532adc2ddaf378@SC-EXCH02.marvell.com>
In-Reply-To: <fa9898c2c9cf45758c532adc2ddaf378@SC-EXCH02.marvell.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Fri, 27 Jul 2018 11:08:40 -0400
Message-ID: <CA+5PVA5kUKfnOyT96+h86gyG39X4MCZrCS70C9Mqq2WxVS2CMw@mail.gmail.com> (sfid-20180727_170856_059978_C339A27D)
Subject: Re: pull-request mwifiex-firmware 2018-07-20
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Sanjay Subbarao <jayrao@marvell.com>, rakeshp@marvell.com,
        Cathy Luo <cluo@marvell.com>, James Cao <jcao@marvell.com>,
        spatki@marvell.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 20, 2018 at 1:42 AM Ganapathi Bhat <gbhat@marvell.com> wrote:
>
> The following changes since commit e1abab618308110789a4c27db543d132fd62e89f:
>
>   linux-firmware: update Marvell USB8997 firmware image to add WPA2 vulnerability fix (2018-05-07 17:54:42 +0530)
>
> are available in the git repository at:
>
>   git://git.marvell.com/mwifiex-firmware.git
>
> for you to fetch changes up to 0ced724f6ed564a5e1602808163db7cfa4697f39:
>
>   linux-firmware: update Marvell USB8801 B0 firmware image (2018-07-20 11:00:29 +0530)
>
> ----------------------------------------------------------------
> Ganapathi Bhat (1):
>       linux-firmware: update Marvell USB8801 B0 firmware image
>
>  WHENCE                  |   2 +-
>  mrvl/usb8801_uapsta.bin | Bin 255948 -> 250940 bytes
>  2 files changed, 1 insertion(+), 1 deletion(-)

Pulled and pushed out.  Thanks.

josh
