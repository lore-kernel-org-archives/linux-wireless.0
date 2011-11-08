Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43412 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932377Ab1KHONY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 09:13:24 -0500
Received: by mail-bw0-f49.google.com with SMTP id t2so544496bka.8
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 06:13:23 -0800 (PST)
Subject: Re: [PATCH] wl12xx: keep beacon-filtering enabled during STA
 operation
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319469920-5173-1-git-send-email-arik@wizery.com>
References: <1319469920-5173-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 16:13:20 +0200
Message-ID: <1320761600.19479.13.camel@cumari> (sfid-20111108_151329_680590_C78BC61D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-24 at 17:25 +0200, Arik Nemtsov wrote: 
> Enable beacon filtering on STA init, and don't disable it when entering
> active mode. Otherwise dynamic-PS supports means we receive beacons from
> the current AP during any Tx/Rx performed by the driver.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Applied, thank you!

-- 
Cheers,
Luca.

