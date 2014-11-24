Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:9727 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKXPb6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 10:31:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Yanbo Li <yanbol@qti.qualcomm.com>
CC: <dreamfly281@gmail.com>, <linux-wireless@vger.kernel.org>,
	<michal.kazior@tieto.com>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Add the target register access and memory dump debugfs interface
References: <1416656922-6645-1-git-send-email-yanbol@qti.qualcomm.com>
Date: Mon, 24 Nov 2014 17:31:51 +0200
In-Reply-To: <1416656922-6645-1-git-send-email-yanbol@qti.qualcomm.com> (Yanbo
	Li's message of "Sat, 22 Nov 2014 19:48:42 +0800")
Message-ID: <87wq6k4ntk.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_163201_883880_B3F655B0)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yanbo Li <yanbol@qti.qualcomm.com> writes:

> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -22,6 +22,7 @@
>  #include <linux/vmalloc.h>
>  
>  #include "core.h"
> +#include "hif.h"
>  #include "debug.h"
>  #include "hif.h"

hif.h is now included twice.

Let me send a v2. I'll also try splitting the patches as then it makes
it easier to write the commit log.

-- 
Kalle Valo
