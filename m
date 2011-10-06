Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:34852 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758322Ab1JFNR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 09:17:27 -0400
Received: by mail-bw0-f51.google.com with SMTP id zu17so4151524bkb.24
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 06:17:26 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: configure rate policy for p2p operations
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1317636396-23387-1-git-send-email-eliad@wizery.com>
References: <1317636396-23387-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 16:17:15 +0300
Message-ID: <1317907035.3549.8.camel@cumari> (sfid-20111006_151729_122135_47C156F4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-03 at 12:06 +0200, Eliad Peller wrote: 
> p2p packets should go out only with OFDM rates.
> 
> Configure a new rate policy that will (later) be used
> during p2p_find (when the p2p_cli / p2p_go interfaces
> are in use, we won't have to use this policy, as
> the configured rates should already be OFDM-only).
> 
> Additionally, update CONF_TX_MAX_RATE_CLASSES to reflect
> the current value from the fw api.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks!

-- 
Cheers,
Luca.

