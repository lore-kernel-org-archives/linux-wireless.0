Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:36812 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758394Ab1JFNSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 09:18:22 -0400
Received: by mail-bw0-f42.google.com with SMTP id r4so7220710bka.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 06:18:21 -0700 (PDT)
Subject: Re: [PATCH 00/29] wl12xx: start preparing the driver for multi-vif
 support
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Oct 2011 16:18:18 +0300
Message-ID: <1317907098.3549.9.camel@cumari> (sfid-20111006_151832_002142_57E34AAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-10-05 at 11:55 +0200, Eliad Peller wrote: 
> The wl12xx fw currently supports only a single vif at a time.
> Upcoming fw versions are going to support concurrentl vifs.
> 
> While mac80211 works well with multiple vifs, the wl12xx
> driver assumes it handles only a single interface.
> 
> This is the first patchset in order to make the driver ready
> for multiple vifs support. The main action here is defining
> a new per-interface data struct (wlvif), and moving the
> currently-global fields into it.
> 
> (Additional global fields/flags will be addressed by further patchsets)
> 
> Note that this patchset only adds functionality - it doesn't
> break compatability with the current fw.

Applied the series.  Thanks for the patchbomb! :P


-- 
Cheers,
Luca.

