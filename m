Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coyote.holtmann.net ([212.227.132.17]:39109 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbeB0S0F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 13:26:05 -0500
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: [PATCH 3/3] btmrvl: support sysfs initiated firmware coredump
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1519210220-22437-4-git-send-email-arend.vanspriel@broadcom.com>
Date: Tue, 27 Feb 2018 19:26:02 +0100
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <F1346A83-77FD-42B9-8F36-ACA45381CF03@holtmann.org> (sfid-20180227_192620_148330_0A4DA140)
References: <1519210220-22437-1-git-send-email-arend.vanspriel@broadcom.com>
 <1519210220-22437-4-git-send-email-arend.vanspriel@broadcom.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> Since commit 3c47d19ff4dc ("drivers: base: add coredump driver ops")
> it is possible to initiate a device coredump from user-space. This
> patch adds support for it in btmrvl_sdio adding the .coredump()
> driver callback. This makes dump through debugfs obsolete so removing
> it.
> 
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> drivers/bluetooth/btmrvl_debugfs.c | 31 -------------------------------
> drivers/bluetooth/btmrvl_drv.h     |  2 --
> drivers/bluetooth/btmrvl_main.c    |  6 ------
> drivers/bluetooth/btmrvl_sdio.c    | 18 ++++++++++++------
> 4 files changed, 12 insertions(+), 45 deletions(-)

patch has been applied to bluetooth-next tree.

Regards

Marcel
