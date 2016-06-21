Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:35100 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbcFUOtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 10:49:55 -0400
Received: by mail-lf0-f43.google.com with SMTP id l188so27006147lfe.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Jun 2016 07:49:54 -0700 (PDT)
Subject: Re: [PATCH 1/2] ath10k: remove unused <linux/semaphore.h>
To: Chaehyun Lim <chaehyun.lim@gmail.com>, kvalo@qca.qualcomm.com
References: <20160621114539.15313-1-chaehyun.lim@gmail.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <bf7b2008-b333-2d79-a952-fda895da8479@cogentembedded.com> (sfid-20160621_164958_870444_7FE4A5CB)
Date: Tue, 21 Jun 2016 16:46:00 +0300
MIME-Version: 1.0
In-Reply-To: <20160621114539.15313-1-chaehyun.lim@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.

On 6/21/2016 2:45 PM, Chaehyun Lim wrote:

> <linux/semaphore.h> is not used anymore, so just remove it.

    s/it/#include/?

> Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
[...]

> diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
> index cc82718..0c55cd9 100644
> --- a/drivers/net/wireless/ath/ath10k/htc.h
> +++ b/drivers/net/wireless/ath/ath10k/htc.h
> @@ -22,7 +22,6 @@
>  #include <linux/list.h>
>  #include <linux/bug.h>
>  #include <linux/skbuff.h>
> -#include <linux/semaphore.h>
>  #include <linux/timer.h>
>
>  struct ath10k;

MBR, Sergei

