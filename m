Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46519 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762479AbXFGVWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 17:22:54 -0400
Message-ID: <4668772C.1000107@lwfinger.net>
Date: Thu, 07 Jun 2007 16:22:52 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Jiri Benc <jbenc@suse.cz>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net> <20070607221939.444e9d74@griffin.suse.cz>
In-Reply-To: <20070607221939.444e9d74@griffin.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jiri Benc wrote:
> 
> Don't misuse module parameters, please. If you have more devices, this
> single parameter will affect all of them. That's not a good approach,
> especially when the value you are trying to change can be changed on
> the fly.
--- snip ---
> However, I'm not against setting the initial value to the lowest rate
> available. As Johannes pointed out, if the rate control algorithm isn't
> able to quickly migrate to higher rates, it's a good candidate for
> rewrite.

I'm more than a little confused. First you tell me that setting the initial rate with a module 
parameter is bad because it sets a value for all _MY_ devices, then you say that you will allow a 
change that would affect _EVERYONE'S_ devices. Huh? I wrote the code the way I did because I thought 
it was much better to allow a local solution rather than a global one.

Larry

