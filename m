Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33483 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932694AbcJLVpZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 17:45:25 -0400
Received: by mail-yw0-f196.google.com with SMTP id w3so2331615ywg.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Oct 2016 14:45:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <147629570687.26062.4786752681864367162.stgit@localhost.localdomain>
References: <147629570687.26062.4786752681864367162.stgit@localhost.localdomain>
From: Steve deRosier <derosier@gmail.com>
Date: Wed, 12 Oct 2016 14:32:18 -0700
Message-ID: <CALupW3D2dsTeixs3z+e9JC_D2D_Bd_AHquHKttCf17OhMqEFUg@mail.gmail.com> (sfid-20161012_234529_671888_1164D570)
Subject: Re: [PATCH] ath6k1: add Dell OEM SDIO I/O for the Venue 8 Pro
To: Alan <alan@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alan,

Sorry to quibble, but the subsystem label on the commit subject line
should be "ath6kl:"  it's a lower-case "L", not a one.


On Wed, Oct 12, 2016 at 11:08 AM, Alan <alan@linux.intel.com> wrote:
> From: Adam Williamson <adamw@happyassassin.net>
>
> SDIO ID 0271:0418
>
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Bugzilla-ID: https://bugzilla.kernel.org/show_bug.cgi?id=67921
>
> diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
> index eab0ab9..76eb336 100644
> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -1401,6 +1401,7 @@ static const struct sdio_device_id ath6kl_sdio_devices[] = {
>         {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x0))},
>         {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x1))},
>         {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x2))},
> +       {SDIO_DEVICE(MANUFACTURER_CODE, (MANUFACTURER_ID_AR6004_BASE | 0x18))},
>         {},
>  };
>
>

I see nothing wrong with this if the chip does indeed identify itself
this way.  So please fix the subject and you can add:

Reviewed-by: Steve deRosier <steve.derosier@lairdtech.com>

- Steve
