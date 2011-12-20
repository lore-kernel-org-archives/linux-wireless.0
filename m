Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:47902 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab1LTUvO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 15:51:14 -0500
Received: by lagv3 with SMTP id v3so842263lag.28
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 12:51:11 -0800 (PST)
Subject: Re: [PATCH] wl12xx: fix sched scan of DFS channels
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1324375441-2053-1-git-send-email-eyal@wizery.com>
References: <1324375441-2053-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Dec 2011 22:51:07 +0200
Message-ID: <1324414267.2182.75.camel@cumari> (sfid-20111220_215116_421236_056A5A75)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-20 at 12:04 +0200, Eyal Shapira wrote: 
> DFS channels weren't scanned properly because
> min/max_duration weren't set for these channels
> even though they're required by the FW.
> The change sets passive_duration and min/max_duration
> for all channels as the FW uses the correct parameters
> according to the channel type.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

Applied, thanks Eyal!

-- 
Cheers,
Luca.

