Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54971 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3LBOpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 09:45:15 -0500
Date: Mon, 2 Dec 2013 09:34:12 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ujjal Roy <royujjal@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: TEST: testing how to send a patch from git repository
Message-ID: <20131202143411.GB26033@tuxdriver.com> (sfid-20131202_154519_946380_19760066)
References: <1385881036-6069-1-git-send-email-royujjal@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1385881036-6069-1-git-send-email-royujjal@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please DO NOT use linux-wireless as a test destination for patch
mailing tools.  It's bad enough to do it once, but over and over
again is a bit rude.

On Sun, Dec 01, 2013 at 12:27:16PM +0530, Ujjal Roy wrote:
> Testing how to send an email through git to see the patch is exactly
> submitted or not. Actually testing the tab characters. Please don't
> mind.
> 
> Signed-off-by: Ujjal Roy <royujjal@gmail.com>
> ---
>  net/wireless/sme.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/wireless/sme.c b/net/wireless/sme.c
> index 5eeb8e0..19a5df4 100644
> --- a/net/wireless/sme.c
> +++ b/net/wireless/sme.c
> @@ -20,6 +20,8 @@
>  #include "reg.h"
>  #include "rdev-ops.h"
>  
> +	printk("TEST: submitting patch from git >> Ujjal Roy C: royujjal@gmail.com");
> +
>  /*
>   * Software SME in cfg80211, using auth/assoc/deauth calls to the
>   * driver. This is is for implementing nl80211's connect/disconnect
> -- 
> 1.8.3.1
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
