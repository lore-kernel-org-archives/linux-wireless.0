Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:50375 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757Ab1LOIyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:54:11 -0500
Received: by lami14 with SMTP id i14so838213lam.6
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 00:54:09 -0800 (PST)
Subject: Re: [PATCH v2] wl12xx: use ieee80211_free_txskb()
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1323782798-16811-1-git-send-email-eliad@wizery.com>
References: <1323782798-16811-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 10:54:05 +0200
Message-ID: <1323939245.2800.180.camel@cumari> (sfid-20111215_095413_891181_16EDEE55)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-13 at 15:26 +0200, Eliad Peller wrote: 
> Use the newly introduced ieee80211_free_txskb() instead
> of dev_kfree_skb() for failed tx packets.
> 
> Additionally, if the skb is a dummy packet, re-enqueue
> it (as the fw expects it) instead of freeing it.
> 
> Reported-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks Eliad!

-- 
Cheers,
Luca.

