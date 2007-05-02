Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44597 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2993248AbXEBPWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2007 11:22:08 -0400
Message-ID: <4638AC8C.9060706@lwfinger.net>
Date: Wed, 02 May 2007 10:21:48 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Patrick McHardy <kaber@trash.net>
CC: Jiri Benc <jbenc@suse.cz>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix for missing global (tcf_destroy_chain)  in build
References: <46389ebb.JZh37v8gJUSOn1+U%Larry.Finger@lwfinger.net> <4638A163.8030505@trash.net>
In-Reply-To: <4638A163.8030505@trash.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patrick McHardy wrote:
> 
> 
> That pretty much defeats the reason why CONFIG_NET_SCH_FIFO was created.
> So far without CONFIG_NET_SCHED the wme scheduler didn't even register,
> so it seems the proper fix is to get rid of all #ifdef CONFIG_NET_SCHED
> and simply avoid building it.

At least this "fix" lets the system build. Whomever broke it needs to do the proper fix.

Larry
