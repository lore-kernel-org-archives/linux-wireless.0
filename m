Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33346 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbcDFSjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 14:39:15 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: btcoexist: Convert BTC_PRINTK to btc_<foo>_dbg
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <4672f9efb37df545ae504d51ca626bf34237fa63.1458258337.git.joe@perches.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20160406183913.BE8E8615EF@smtp.codeaurora.org> (sfid-20160406_203948_912070_66525046)
Date: Wed,  6 Apr 2016 18:39:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Use a more common logging style.
> 
> Miscellanea:
> 
> o Add specific logging macros for ALGORITHM and INTERFACE types
> o Output the messages at KERN_DEBUG
> o Coalesce formats
> o Align arguments
> o Whitespace style adjustments for only these changes
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Thanks, applied to wireless-drivers-next.git. There were some conflicts but
3-way merge was able to fix them. Please double check still.

Applying: rtlwifi: btcoexist: Convert BTC_PRINTK to btc_<foo>_dbg
Using index info to reconstruct a base tree...
Falling back to patching base and 3-way merge...
Auto-merging drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.h
Auto-merging drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtcoutsrc.c
Auto-merging drivers/net/wireless/realtek/rtlwifi/btcoexist/halbtc8723b2ant.c

Kalle Valo
