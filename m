Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45528 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934012AbdIYIZA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 04:25:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: make const array tos_to_ac static,
 reduces object code size
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170919210500.31330-1-colin.king@canonical.com>
References: <20170919210500.31330-1-colin.king@canonical.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20170925082459.B18ED60719@smtp.codeaurora.org> (sfid-20170925_110027_638925_445ADCC0)
Date: Mon, 25 Sep 2017 08:24:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Colin Ian King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the read-only const array tos_to_ac on the stack,
> instead make it static. Makes the object code smaller by 250 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>   26104	   2720	    128	  28952	   7118	wmm.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>   25758	   2816	    128	  28702	   701e	wmm.o
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

7dfb0ebd022b mwifiex: make const array tos_to_ac static, reduces object code size

-- 
https://patchwork.kernel.org/patch/9960331/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
