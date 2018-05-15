Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49396 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752129AbeEOJar (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:30:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/8] btmrvl: support sysfs initiated firmware coredump
References: <1526375691-31789-1-git-send-email-arend.vanspriel@broadcom.com>
        <1526375691-31789-6-git-send-email-arend.vanspriel@broadcom.com>
Date: Tue, 15 May 2018 12:30:43 +0300
In-Reply-To: <1526375691-31789-6-git-send-email-arend.vanspriel@broadcom.com>
        (Arend van Spriel's message of "Tue, 15 May 2018 11:14:48 +0200")
Message-ID: <87bmdhp8os.fsf@kamboji.qca.qualcomm.com> (sfid-20180515_113051_149467_9B64B875)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
> it is possible to initiate a device coredump from user-space. This
> patch adds support for it in btmrvl_sdio adding the .coredump()
> driver callback. This makes dump through debugfs obsolete so removing
> it.
>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>  drivers/bluetooth/btmrvl_debugfs.c | 31 -------------------------------
>  drivers/bluetooth/btmrvl_drv.h     |  2 --
>  drivers/bluetooth/btmrvl_main.c    |  6 ------
>  drivers/bluetooth/btmrvl_sdio.c    | 11 ++++++++---
>  4 files changed, 8 insertions(+), 42 deletions(-)

Shouldn't this go via bluetooth tree?

-- 
Kalle Valo
