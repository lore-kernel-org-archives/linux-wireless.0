Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:56153 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754913Ab1KHONP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:13:15 -0500
Received: by mail-bw0-f41.google.com with SMTP id s6so594754bka.14
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:13:14 -0800 (PST)
Subject: Re: [PATCH] wl12xx: reconfigure rate policies on set_bitrate_mask
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318327059-14158-1-git-send-email-eliad@wizery.com>
References: <1318327059-14158-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:13:10 +0200
Message-ID: <1320761590.19479.12.camel@cumari> (sfid-20111108_151319_072266_36A56B92)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 11:57 +0200, Eliad Peller wrote: 
> The rate policies are configured only after association,
> resulting in auth req being sent in wrong rates.
> 
> Reconfigure rate policies on bitrate mask change.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied!

-- 
Cheers,
Luca.

