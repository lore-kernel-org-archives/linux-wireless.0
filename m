Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:35608 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753266AbXCWRcW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 13:32:22 -0400
Date: Fri, 23 Mar 2007 18:32:20 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
Message-ID: <20070323183220.11ffb2a3@griffin.suse.cz>
In-Reply-To: <200703231822.50522.mb@bu3sch.de>
References: <200703061902.00001.mb@bu3sch.de>
	<20070323181746.7a8f4b56@griffin.suse.cz>
	<200703231822.50522.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 23 Mar 2007 18:22:50 +0100, Michael Buesch wrote:
> kill == (make sure it's not scheduled anymore) && disable

Are you sure? I cannot find anything in tasklet_kill which disables the
tasklet.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
