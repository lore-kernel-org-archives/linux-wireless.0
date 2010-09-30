Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41587 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab0I3VrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 17:47:23 -0400
Received: by iwn5 with SMTP id 5so2935808iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 14:47:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283374914-4554-1-git-send-email-lrodriguez@atheros.com>
References: <1283374914-4554-1-git-send-email-lrodriguez@atheros.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 30 Sep 2010 14:47:01 -0700
Message-ID: <AANLkTim_VsitOUMJegGsermMkBqSfiUbuRkQCA0B8XT+@mail.gmail.com>
Subject: Re: [PATCH] linux-firmware: update Atheros firmware license
To: dwmw2@infradead.org
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	ath9k-devel@atheros.com, Len Widra <len.widra@atheros.com>,
	Brian Lee <briank.lee@atheros.com>,
	Adam Tachner <atachner@atheros.com>,
	Paul Lever <Paul.Lever@atheros.com>,
	Vipin Mehta <vipin.mehta@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 1, 2010 at 2:01 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> This makes the license Operating System agnostic and updates
> the patent license grant for use of the firmware license specifically
> on the Atheros chipsets.
>
> This allows us to share the same license between all Atheros chipsets,
> ath9k, ath9k_htc, ath6kl, and future chipsets.
>
> Cc: ath9k-devel@atheros.com
> Cc: Len Widra <len.widra@atheros.com>
> Cc: Brian Lee <briank.lee@atheros.com>
> Cc: Adam Tachner <atachner@atheros.com>
> Cc: Paul Lever <Paul.Lever@atheros.com>
> Cc: Vipin Mehta <vipin.mehta@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
>  LICENCE.atheros_firmware |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/LICENCE.atheros_firmware b/LICENCE.atheros_firmware
> index d336492..e0ebdac 100644
> --- a/LICENCE.atheros_firmware
> +++ b/LICENCE.atheros_firmware
> @@ -21,9 +21,7 @@ world-wide, royalty-free, non-exclusive license under patents it
>  now or hereafter owns or controls to make, have made, use, import,
>  offer to sell and sell ("Utilize") this software, but solely to
>  the extent that any such patent is necessary to Utilize the software
> -alone, or in combination with an operating system licensed under an
> -approved Open Source license as listed by the Open Source Initiative
> -at http://opensource.org/licenses.  The patent license shall not
> +in conjunction with an Atheros Chipset. The patent license shall not
>  apply to any other combinations which include this software. No
>  hardware per se is licensed hereunder.
>

Just a friendly reminder.

  Luis
