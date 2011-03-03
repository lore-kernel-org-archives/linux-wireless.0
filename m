Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:52691 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754035Ab1CCPmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 10:42:54 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1163244wyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2011 07:42:52 -0800 (PST)
Subject: Re: [PATCH] wl12xx: wakeup chip from ELP during scan
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1298975246-1720-1-git-send-email-arik@wizery.com>
References: <1298975246-1720-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 17:42:55 +0200
Message-ID: <1299166975.7039.6.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-01 at 12:27 +0200, Arik Nemtsov wrote:
> Commands are sometimes sent to FW on scan completion. Make sure the chip
> is awake to receive them. Sending commands while the chip is in ELP
> can cause SDIO read errors and/or crash the FW.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Applied, thanks Arik!

-- 
Cheers,
Luca.

