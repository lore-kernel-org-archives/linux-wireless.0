Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:46511 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751932AbdDCJVI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 05:21:08 -0400
Message-ID: <1491211256.27353.58.camel@perches.com> (sfid-20170403_112143_201975_A4808E0A)
Subject: Re: [PATCH] wlcore: fix spelling mistake in wl1271_warning 'iligal'
 -> 'illegal'
From: Joe Perches <joe@perches.com>
To: Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 03 Apr 2017 02:20:56 -0700
In-Reply-To: <20170403091530.18564-1-colin.king@canonical.com>
References: <20170403091530.18564-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-04-03 at 10:15 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> trivial fix to spelling mistake in wl1271_warning error message
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wireless/ti/wlcore/debugfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
> index 58e148d7bc7b..416080adc181 100644
> --- a/drivers/net/wireless/ti/wlcore/debugfs.c
> +++ b/drivers/net/wireless/ti/wlcore/debugfs.c
> @@ -1249,7 +1249,7 @@ static ssize_t fw_logger_write(struct file *file,
>  	}
>  
>  	if (wl->conf.fwlog.output == 0) {
> -		wl1271_warning("iligal opperation - fw logger disabled by default, please change mode via wlconf");
> +		wl1271_warning("illegal opperation - fw logger disabled by default, please change mode via wlconf");

Hi Colin.

When you do these would you please fix all the typos on the
same line?  opperation -> operation

Also, generally, invalid is a better word choice than illegal
for these situations.

Thanks and cheers, Joe
