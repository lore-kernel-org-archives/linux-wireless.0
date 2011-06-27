Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:38937 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755977Ab1F0Kkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 06:40:40 -0400
Received: by fxe23 with SMTP id 23so1703565fxe.15
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 03:40:37 -0700 (PDT)
Subject: Re: [PATCH v2 1/4] wl12xx: don't check wow param on suspend/resume
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1307352115-28969-1-git-send-email-eliad@wizery.com>
References: <1307352115-28969-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 13:40:34 +0300
Message-ID: <1309171234.30221.27.camel@cumari> (sfid-20110627_124538_788949_DBE7C5A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-06 at 12:21 +0300, Eliad Peller wrote: 
> Since mac80211 calls suspend/resume only when wowlan triggers
> exist, there is no need to check for triggers existance in the
> callbacks as well.
> Add a WARN_ON() to verify it.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied the series, thanks!

-- 
Cheers,
Luca.

