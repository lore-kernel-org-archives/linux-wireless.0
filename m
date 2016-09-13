Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55057 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754745AbcIMMnO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 08:43:14 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Spelling and miscellaneous neatening
Date: Tue, 13 Sep 2016 12:43:09 +0000
Message-ID: <871t0oj7hf.fsf@kamboji.qca.qualcomm.com> (sfid-20160913_144336_723125_8E9199D4)
References: <95a6b65277914d88178ed2b15e182455067cca60.1472490319.git.joe@perches.com>
In-Reply-To: <95a6b65277914d88178ed2b15e182455067cca60.1472490319.git.joe@perches.com>
        (Joe Perches's message of "Mon, 29 Aug 2016 10:05:51 -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:

> Correct some trivial comment typos.
> Remove unnecessary parentheses in a long line.
> Convert a return; before the end of a void function definition to just ;
>
> Signed-off-by: Joe Perches <joe@perches.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2118,7 +2118,7 @@ err:
>  	/* TODO: It's probably a good idea to release device from the driver
>  	 * but calling device_release_driver() here will cause a deadlock.
>  	 */
> -	return;
> +	;
>  }

I don't think this improves anything, I dropped this part from the patch
in my pending branch.

--=20
Kalle Valo=
