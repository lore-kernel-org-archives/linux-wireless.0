Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:45174 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913Ab1KHONA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:13:00 -0500
Received: by mail-bw0-f54.google.com with SMTP id zs8so580273bkb.13
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:12:59 -0800 (PST)
Subject: Re: [PATCH] wl12xx: couple role_start_dev with roc
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318326944-14072-1-git-send-email-eliad@wizery.com>
References: <1318326944-14072-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:12:56 +0200
Message-ID: <1320761576.19479.11.camel@cumari> (sfid-20111108_151305_331368_9FC90DAF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 11:55 +0200, Eliad Peller wrote: 
> Device role is always started along with ROC.
> Couple them together by introducing new wl12xx_start_dev
> and wl12xx_stop_dev functions.
> 
> By using these functions, we solve a bug that occured during
> channel switch - we started the dev role on one channel, and
> ROCed on a different one.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

