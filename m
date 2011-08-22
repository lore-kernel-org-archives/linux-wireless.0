Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:39175 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab1HVHmF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Aug 2011 03:42:05 -0400
Received: by bkbzu5 with SMTP id zu5so4298194bkb.23
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2011 00:42:03 -0700 (PDT)
Subject: Re: [PATCH v3] wl12xx: use 2 spare TX blocks for GEM cipher
From: Luciano Coelho <coelho@ti.com>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1313513352-32316-1-git-send-email-guy@wizery.com>
References: <1313513352-32316-1-git-send-email-guy@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 10:41:59 +0300
Message-ID: <1313998919.2296.23.camel@cumari> (sfid-20110822_094210_326662_584D13DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-16 at 19:49 +0300, Guy Eilam wrote: 
> Add tx_spare_blocks member to the wl1271 struct
> for more generic configuration of the amount
> of spare TX blocks that should be used.
> The default value is 1.
> In case GEM cipher is used by the STA, we need
> 2 spare TX blocks instead of just 1.
> 
> Signed-off-by: Guy Eilam <guy@wizery.com>
> ---

Next time when you send v2, v3 and so on, please add what has changed
comparing to the previous version.  You can add free-format comments
just below the "---" after the signed-off-by line.


-- 
Cheers,
Luca.

