Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:47468 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755299AbZHDIZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 04:25:12 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1MYFKX-0004OP-PS
	for linux-wireless@vger.kernel.org; Tue, 04 Aug 2009 08:25:10 +0000
Received: from i59F7B022.versanet.de ([89.247.176.34])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 08:25:09 +0000
Received: from jal2 by i59F7B022.versanet.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2009 08:25:09 +0000
To: linux-wireless@vger.kernel.org
From: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH] cfg80211: clear SSID on disconnect
Date: Tue, 4 Aug 2009 08:24:59 +0000 (UTC)
Message-ID: <loom.20090804T082338-799@post.gmane.org>
References: <1249311832.4561.2.camel@johannes.local>  <loom.20090804T064513-963@post.gmane.org> <1249370029.9415.1.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:


 
> Aha. yes, the same assignment is _also_ missing in
> __cfg80211_connect_result(), can you add it there manually (in the
> status != WLAN_STATUS_SUCCESS block at the end) and see what happens?

Yes, that helped in my case.

Thanks,
Jörg. 



