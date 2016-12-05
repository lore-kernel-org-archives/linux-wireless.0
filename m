Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55004 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbcLELKZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Dec 2016 06:10:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mwifiex: clean up some messy indenting
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20161130192156.GD28180@mwanda>
References: <20161130192156.GD28180@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Karthik D A <karthida@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20161205111024.B1520615FF@smtp.codeaurora.org> (sfid-20161205_121029_545064_5729DBF7)
Date: Mon,  5 Dec 2016 11:10:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> These lines were indented one tab extra.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> index f5dffdf..fdc6cc2 100644
> --- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
> @@ -1937,8 +1937,8 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
>  		mwifiex_dbg(priv->adapter, ERROR,
>  			    "0x%x command not supported by firmware\n",
>  			    cmd_no);
> -			return -EOPNOTSUPP;
> -		}
> +		return -EOPNOTSUPP;
> +	}
>  
>  	/* Prepare command */
>  	switch (cmd_no) {

Patch applied to wireless-drivers-next.git, thanks.

e54a8c4b5753 mwifiex: clean up some messy indenting

-- 
https://patchwork.kernel.org/patch/9454717/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
