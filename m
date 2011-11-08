Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:33087 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab1KHOOn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:14:43 -0500
Received: by mail-bw0-f51.google.com with SMTP id t8so412045bka.38
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:14:41 -0800 (PST)
Subject: Re: [PATCH] wl12xx: fix SDIO suspend/resume
From: Luciano Coelho <coelho@ti.com>
To: Eyal Shapira <eyal@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1320760615-19794-1-git-send-email-eyal@wizery.com>
References: <1320760615-19794-1-git-send-email-eyal@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:14:38 +0200
Message-ID: <1320761678.19479.18.camel@cumari> (sfid-20111108_151447_128461_FCD041B0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 15:56 +0200, Eyal Shapira wrote: 
> wl1271_suspend/resume() accessed the wrong struct and not wl1271
> which caused it to think that wow was enabled when it wasn't.
> 
> Signed-off-by: Eyal Shapira <eyal@wizery.com>
> ---

Applied.  Thanks Eyal!

-- 
Cheers,
Luca.

