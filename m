Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:38285 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751573AbXCWUQn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 16:16:43 -0400
Date: Fri, 23 Mar 2007 21:16:40 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
Message-ID: <20070323211640.0f085182@griffin.suse.cz>
In-Reply-To: <200703231936.42249.mb@bu3sch.de>
References: <200703061902.00001.mb@bu3sch.de>
	<200703231822.50522.mb@bu3sch.de>
	<20070323183220.11ffb2a3@griffin.suse.cz>
	<200703231936.42249.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 23 Mar 2007 19:36:42 +0100, Michael Buesch wrote:
> Why disable it? If there's anything scheduling the tasklet while
> we have unregistered we _want_ it to crash, as that's a real bug
> in the first place. (And I don't think it's possible to
> schedule it after unregister).

Hm, yes, sorry. Applied.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
