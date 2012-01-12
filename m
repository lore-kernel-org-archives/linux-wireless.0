Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:54651 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752857Ab2ALIUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 03:20:04 -0500
Received: by lagp5 with SMTP id p5so677626lag.7
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jan 2012 00:20:01 -0800 (PST)
Subject: Re: [PATCH] wl12xx: Make sure HW is available in sched scan ops
From: Luciano Coelho <coelho@ti.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1326288162-9113-1-git-send-email-pontus.fuchs@gmail.com>
References: <1326288162-9113-1-git-send-email-pontus.fuchs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Jan 2012 10:19:58 +0200
Message-ID: <1326356398.32758.18.camel@cumari> (sfid-20120112_092008_986296_9BF383E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-01-11 at 14:22 +0100, Pontus Fuchs wrote: 
> The sched_scan_(stop|start) ops fails to check for WL1271_STATE_OFF.
> This can lead to a race where the driver tries to access the HW
> while it's off.
> 
> Fix this by checking for WL1271_STATE_OFF before accessing the HW.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

