Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51966 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751673AbdITMrl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 08:47:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: make const arrays static to shink object code size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170916153424.28285-1-colin.king@canonical.com>
References: <20170916153424.28285-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170920124740.CCDD160912@smtp.codeaurora.org> (sfid-20170920_144759_114660_683B65B3)
Date: Wed, 20 Sep 2017 12:47:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate const arrays on the stack, instead make them static
> Makes the object code smaller by nearly 300 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   69260	  16149	    576	  85985	  14fe1	cfg80211.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   68385	  16725	    576	  85686	  14eb6	cfg80211.o
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

d157bcfaf854 mwifiex: make const arrays static to shink object code size

-- 
https://patchwork.kernel.org/patch/9954375/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
