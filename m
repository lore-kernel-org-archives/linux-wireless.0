Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52147 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab2DSPTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 11:19:30 -0400
Message-ID: <1334848754.1980.3.camel@dcbw.foobar.com> (sfid-20120419_171933_883610_E8BEF259)
Subject: Re: [PATCH] libertas: add missing include
From: Dan Williams <dcbw@redhat.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Date: Thu, 19 Apr 2012 10:19:14 -0500
In-Reply-To: <1334836452-75639-1-git-send-email-nbd@openwrt.org>
References: <1334836452-75639-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-19 at 13:54 +0200, Felix Fietkau wrote:
> Without it, I get compile errors due to missing TASK_NORMAL,
> TASK_UNINTERRUPTIBLE and schedule.

Yeah, got this too (though on 2.6.4x when testing CS, I don't think I
got it on 3.3).

Acked-by: Dan Williams <dcbw@redhat.com>

> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/libertas/firmware.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/firmware.c b/drivers/net/wireless/libertas/firmware.c
> index cd23f1a..77f6504 100644
> --- a/drivers/net/wireless/libertas/firmware.c
> +++ b/drivers/net/wireless/libertas/firmware.c
> @@ -5,6 +5,7 @@
>  #include <linux/firmware.h>
>  #include <linux/firmware.h>
>  #include <linux/module.h>
> +#include <linux/sched.h>
>  
>  #include "dev.h"
>  #include "decl.h"


