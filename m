Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:38945 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985Ab1CaHRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 03:17:15 -0400
Received: by mail-ew0-f45.google.com with SMTP id 24so651770ewy.32
        for <linux-wireless@vger.kernel.org>; Thu, 31 Mar 2011 00:17:14 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: fix module author's email address in the spi
 and sdio modules
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <1301509899-6444-1-git-send-email-coelho@ti.com>
References: <1301509899-6444-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 10:17:46 +0300
Message-ID: <1301555866.1988.273.camel@cumari>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-03-30 at 21:31 +0300, Luciano Coelho wrote:
> The MODULE_AUTHOR() macro in the main module (wl12xx) has been updated
> to reflect one of the author's new email address, but the wl12xx_spi
> and wl12xx_sdio modules haven't been updated.  This patches updates
> them.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

-- 
Cheers,
Luca.

