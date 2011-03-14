Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36456 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1CNQ4c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Mar 2011 12:56:32 -0400
Received: by iyb26 with SMTP id 26so5125807iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Mar 2011 09:56:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300121590-27998-1-git-send-email-ohad@wizery.com>
References: <1300121590-27998-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 14 Mar 2011 18:56:10 +0200
Message-ID: <AANLkTi=3UsQAsY40LAG-yCNz3sTsgF6Wbgb--Yw8DNwg@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: update bet_max_consecutive
To: linux-wireless@vger.kernel.org
Cc: "Coelho, Luciano" <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 14, 2011 at 6:53 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Allow early termination of 50 consecutive beacons.
>
> This value is the recommended one by the 12xx's system/RF team,
> and tests show that power consumption is improved as expected.
>
> Reported-by: Ruthy Zaphir <ruthyz@ti.com>
> Tested-by: Danil Shalumov <danils@ti.com>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---

- Luciano Coelho <luciano.coelho@nokia.com>
+ Luciano Coelho <coelho@ti.com>

Sorry, my scripts are outdated.


>  drivers/net/wireless/wl12xx/main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 8b3c8d1..4e6660d 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
> @@ -254,7 +254,7 @@ static struct conf_drv_settings default_conf = {
>                .ps_poll_threshold           = 10,
>                .ps_poll_recovery_period     = 700,
>                .bet_enable                  = CONF_BET_MODE_ENABLE,
> -               .bet_max_consecutive         = 10,
> +               .bet_max_consecutive         = 50,
>                .psm_entry_retries           = 5,
>                .psm_exit_retries            = 255,
>                .psm_entry_nullfunc_retries  = 3,
> --
> 1.7.1
>
>
