Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36282 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030216AbcIGLYS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Sep 2016 07:24:18 -0400
Received: by mail-it0-f65.google.com with SMTP id i184so924249itf.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2016 04:24:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <259efb66-b577-b6c1-a6af-2b27f8bbc1a4@redpinesignals.com>
References: <259efb66-b577-b6c1-a6af-2b27f8bbc1a4@redpinesignals.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 7 Sep 2016 21:23:56 +1000
Message-ID: <CAGRGNgVyybFSqNLvtvXn-OL4dSXCpbYG2xR+cepayEQ6zPowSg@mail.gmail.com> (sfid-20160907_132422_068101_37B3994D)
Subject: Re: [PATCH] rsi: code clean-up
To: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?16nXqNeZINep16jXldef?= <sarasharon1@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Nicholas Mc Guire <hofrat@osadl.org>, xypron.glpk@gmx.de,
        SF Markus Elfring <elfring@users.sourceforge.net>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Sep 7, 2016 at 8:26 PM, Prameela Rani Garnepudi
<prameela.garnepudi@redpinesignals.com> wrote:
>  From 0c3da95dfac07df5dffb5e00bcd8a38f2f8491c9 Mon Sep 17 00:00:00 2001
> From: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
> Date: Wed, 7 Sep 2016 15:28:43 +0530
> Subject: [PATCH] rsi: code clean-up

Describe what the changes are achieving.

You're also still sending this as a HTML email, there are instructions
on how to configure your email client to send plain text emails here:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/email-clients.txt

Because you're sending multi-part HTML emails, your emails are being
rejected by the mailing list.

> Signed-off-by: Prameela Rani Garnepudi
> <prameela.garnepudi@redpinesignals.com>
> ---
>   drivers/net/wireless/rsi/rsi_91x_core.c     |  18 ++--
>   drivers/net/wireless/rsi/rsi_91x_debugfs.c  |  13 +--
>   drivers/net/wireless/rsi/rsi_91x_mac80211.c |  81 +++++++++------
>   drivers/net/wireless/rsi/rsi_91x_main.c     |  16 ++-
>   drivers/net/wireless/rsi/rsi_91x_mgmt.c     | 155
> +++++++++++-----------------
>   drivers/net/wireless/rsi/rsi_91x_sdio.c     |  14 +--
>   drivers/net/wireless/rsi/rsi_91x_sdio_ops.c |  11 +-
>   drivers/net/wireless/rsi/rsi_91x_usb.c      |  34 ++++--
>   drivers/net/wireless/rsi/rsi_common.h       |   2 +-
>   drivers/net/wireless/rsi/rsi_debugfs.h      |   3 +-
>   drivers/net/wireless/rsi/rsi_main.h         |  36 ++++---
>   drivers/net/wireless/rsi/rsi_mgmt.h         |  54 +++++-----
>   drivers/net/wireless/rsi/rsi_sdio.h         |  18 ++--
>   13 files changed, 228 insertions(+), 227 deletions(-)

You're doing a lot of stuff here, you really need to split this up
into several patches, e.g.
1. Fix the spelling mistakes
2. Add the new debug messages
etc. etc. etc.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
