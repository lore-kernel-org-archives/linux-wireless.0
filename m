Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:44061 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742Ab1HaIIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 04:08:17 -0400
Received: by mail-ew0-f43.google.com with SMTP id 20so279360ewy.2
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 01:08:12 -0700 (PDT)
Subject: Re: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1314777198.4161.20.camel@jlt3.sipsolutions.net>
References: <1314707979-26484-1-git-send-email-coelho@ti.com>
	 <1314713812.4011.33.camel@jlt3.sipsolutions.net>
	 <1314718038.2296.460.camel@cumari>
	 <1314720557.4011.41.camel@jlt3.sipsolutions.net>
	 <1314770941.2296.507.camel@cumari>
	 <1314771627.4161.9.camel@jlt3.sipsolutions.net>
	 <1314775816.2296.531.camel@cumari>
	 <1314776396.4161.19.camel@jlt3.sipsolutions.net>
	 <1314776962.2296.540.camel@cumari>
	 <1314777198.4161.20.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 11:08:08 +0300
Message-ID: <1314778088.2296.553.camel@cumari> (sfid-20110831_100822_661247_C70A14FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 09:53 +0200, Johannes Berg wrote: 
> I guess the thing to keep in mind is that it's all an optimisation and
> if a device can't support certain combinations it doesn't really
> matter :)

Yeah, it must be clear in the implementation that the device may send
things that are not really following the filtering rules.  We can't
avoid that anyway, because some other entity may start a scan and mangle
with our BSS cache.

-- 
Cheers,
Luca.

