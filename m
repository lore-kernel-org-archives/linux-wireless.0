Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38693 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757930Ab2BOKOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Feb 2012 05:14:49 -0500
Received: by mail-lpp01m010-f51.google.com with SMTP id s15so786268lag.38
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2012 02:14:47 -0800 (PST)
Message-ID: <1329300883.19569.39.camel@cumari> (sfid-20120215_111452_038313_DC399C8A)
Subject: Re: [PATCH 1/2] Revert "wl12xx: Change claiming of the SDIO bus"
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 15 Feb 2012 12:14:43 +0200
In-Reply-To: <1327579952-4595-1-git-send-email-eliad@wizery.com>
References: <1327579952-4595-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-26 at 14:12 +0200, Eliad Peller wrote: 
> This reverts commit 393fb560d328cc06e6a5c7b7473901ad724f82e7.
> 
> Commit b6ad726 ("mmc: core: Prevent too long response times
> for suspend") fails the suspend if the mmc host can't be
> claimed before suspend. As the host is claimed by us as long
> as the chip is powered on, suspend will always fail.
> 
> Revert to claiming the sdio bus only when needed.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied the set, thank you.

-- 
Cheers,
Luca.

