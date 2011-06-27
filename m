Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:38287 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757703Ab1F0LH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 07:07:29 -0400
Received: by mail-bw0-f49.google.com with SMTP id 12so1700244bwf.36
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 04:07:27 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: use _ni version of ieee80211_tx_status
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1307432439-1752-1-git-send-email-eliad@wizery.com>
References: <1307432439-1752-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:07:24 +0300
Message-ID: <1309172844.30221.29.camel@cumari> (sfid-20110627_131559_406448_A187E308)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-07 at 10:40 +0300, Eliad Peller wrote: 
> wl1271_flush_deferred_work(), which calls ieee80211_rx() and
> ieee80211_tx_status(), is called from a process context.
> hence, use ieee80211_tx_status_ni() instead of ieee80211_tx_status().
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

