Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:43391 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513Ab1HLHeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 03:34:23 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so1913157bke.5
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2011 00:34:22 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Add support to RX packets payload alignment
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1310633427-15882-1-git-send-email-shahar_levi@ti.com>
References: <1310633427-15882-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Aug 2011 10:34:17 +0300
Message-ID: <1313134457.2407.943.camel@cumari> (sfid-20110812_093426_747843_E981C8BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-07-14 at 11:50 +0300, Shahar Levi wrote: 
> In case of QoS packets the packet payload isn't aligned to
> 4 bytes. In that case the mac80211 layer take care of that
> via memmove() in ieee80211_deliver_skb().
> Add support of copy packets from aggregation buffer to the
> skbs with packet payload aligned care. In case of QoS packets
> copy the packets in offset of 2 bytes guarantee payload aligned
> to 4 bytes.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Applied and pushed, thanks!

-- 
Cheers,
Luca.

