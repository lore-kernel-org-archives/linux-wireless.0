Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:36004 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756786Ab1F0ImX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 04:42:23 -0400
Received: by bwd5 with SMTP id 5so1502771bwd.5
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 01:42:21 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: don't bail if mmc isn't MMC_CAP_POWER_OFF_CARD
From: Luciano Coelho <coelho@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: linux-wireless@vger.kernel.org, tim@kangatronix.co.uk
In-Reply-To: <1306676163-17325-1-git-send-email-ohad@wizery.com>
References: <1306676163-17325-1-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 11:42:18 +0300
Message-ID: <1309164138.30221.5.camel@cumari> (sfid-20110627_105823_058760_9DE8527A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-05-29 at 16:36 +0300, Ohad Ben-Cohen wrote:
> If our SDIO function has its runtime PM disabled, don't try to
> manipulate its runtime PM status at all. This way we can still
> power on cards plugged to mmc hosts that are not
> MMC_CAP_POWER_OFF_CARD.
> 
> Reported-and-tested-by: Tim Yamin <tim@kangatronix.co.uk>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> --- 

Applied, thank you!

-- 
Cheers,
Luca.

