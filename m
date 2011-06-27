Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:49562 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756805Ab1F0Imh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 04:42:37 -0400
Received: by bwd14 with SMTP id 14so1535226bwd.28
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 01:42:35 -0700 (PDT)
Subject: Re: [PATCH v2] wl12xx: split channel array per band in sched_scan
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1306849136-21535-1-git-send-email-coelho@ti.com>
References: <1306849136-21535-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 11:42:32 +0300
Message-ID: <1309164152.30221.6.camel@cumari> (sfid-20110627_105905_034252_3AD8B4D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-31 at 16:38 +0300, Luciano Coelho wrote: 
> The firmware, in practice, treats the channels in three separate
> blocks, one for each band (bg, a and j).  Instead of using a single
> array and doing some magic with indices, split the array in 3 to make
> it more readable.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

