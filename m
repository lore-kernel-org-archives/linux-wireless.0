Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:55588 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab1KHOO3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:14:29 -0500
Received: by mail-bw0-f48.google.com with SMTP id r19so430387bka.7
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:14:27 -0800 (PST)
Subject: Re: [PATCH 2/2] wl12xx: handle idle changes per-interface
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>
In-Reply-To: <1319350915-31222-2-git-send-email-arik@wizery.com>
References: <1319350915-31222-1-git-send-email-arik@wizery.com>
	 <1319350915-31222-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:14:24 +0200
Message-ID: <1320761664.19479.17.camel@cumari> (sfid-20111108_151432_896731_68D8C9B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-10-23 at 08:21 +0200, Arik Nemtsov wrote: 
> From: Eliad Peller <eliad@wizery.com>
> 
> Idle changes are currently handled per hardware.
> However, some operations should be done only per-interface.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied this patch.  1/2 from this same set is still pending a
dependency and will be applied later.

-- 
Cheers,
Luca.

