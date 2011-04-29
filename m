Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46705 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758348Ab1D2UI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 16:08:57 -0400
Received: by mail-ey0-f180.google.com with SMTP id 24so1737066eyg.11
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 13:08:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] wl12xx: discard corrupted packets in RX
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303850140-11230-2-git-send-email-arik@wizery.com>
References: <1303850140-11230-1-git-send-email-arik@wizery.com>
	 <1303850140-11230-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 23:08:46 +0300
Message-ID: <1304107726.12586.164.camel@cumari> (sfid-20110429_220900_065776_FA6CDD87)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-26 at 23:35 +0300, Arik Nemtsov wrote:
> When packets arrive with a RX descriptor indicating corruption, discard
> them.
> 
> In general white-list the RX descriptor status to prevent rouge data
> from being sent up.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

