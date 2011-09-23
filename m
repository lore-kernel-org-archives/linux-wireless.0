Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:52838 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752240Ab1IWLo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 07:44:59 -0400
Received: by mail-bw0-f49.google.com with SMTP id t2so5024646bka.22
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2011 04:44:58 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: AP mode - support hidden SSID
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1315070523-31102-1-git-send-email-arik@wizery.com>
References: <1315070523-31102-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 14:44:55 +0300
Message-ID: <1316778295.2157.734.camel@cumari> (sfid-20110923_134502_653017_7097786A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-09-03 at 20:22 +0300, Arik Nemtsov wrote: 
> If a hidden SSID is requested, generate a probe response template
> containing the real SSID.
> 
> Depends on the patch "mac80211: add ssid config to bss information
> in AP-mode".
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Rebased and applied.  Thanks!

-- 
Cheers,
Luca.

