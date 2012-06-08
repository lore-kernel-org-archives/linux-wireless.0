Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:32907 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751457Ab2FHGhw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 02:37:52 -0400
Received: by lbbgh12 with SMTP id gh12so1671326lbb.39
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 23:37:49 -0700 (PDT)
Message-ID: <1339137468.7078.134.camel@cumari.coelho.fi> (sfid-20120608_083755_709356_ACB81F6E)
Subject: Re: [PATCH 2/5] wl18xx: update fw statistics
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: Ido Reis <idor@ti.com>
Date: Fri, 08 Jun 2012 09:37:48 +0300
In-Reply-To: <1339137055-30095-3-git-send-email-coelho@ti.com>
References: <1339137055-30095-1-git-send-email-coelho@ti.com>
	 <1339137055-30095-3-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-06-08 at 09:30 +0300, Luciano Coelho wrote:
> From: Ido Reis <idor@ti.com>
> 
> Aligned to the struct in FW 8.2.0.0.91 and updated the debugfs entries
> accordingly.
> 
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

[...]

> @@ -292,7 +308,8 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
>  	DEBUGFS_FWSTATS_ADD(tx, frag_cache_hit);
>  	DEBUGFS_FWSTATS_ADD(tx, frag_cache_miss);
>  
> -	DEBUGFS_FWSTATS_ADD(rx, rx_out_of_mem);
> +        DEBUGFS_FWSTATS_ADD(rx, rx_beacon_early_term);
> +        DEBUGFS_FWSTATS_ADD(rx, rx_out_of_mpdu_nodes);

There were some checkpatch whitespace errors such as these ones above.
I didn't notice them before sending.  I'll fix them before applying.

--
Luca.

