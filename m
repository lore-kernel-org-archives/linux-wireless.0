Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:58707 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S966859AbXFHI6z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 04:58:55 -0400
Date: Fri, 8 Jun 2007 10:59:00 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH] mac80211: rc80211_lowest, a dumb rate control algorithm
Message-ID: <20070608105900.4c401e14@griffin.suse.cz>
In-Reply-To: <4668A7E5.3070500@lwfinger.net>
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
	<20070607221939.444e9d74@griffin.suse.cz>
	<20070607222113.0f752bf8@griffin.suse.cz>
	<20070607222210.1a445cd7@griffin.suse.cz>
	<4668A7E5.3070500@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 07 Jun 2007 19:50:45 -0500, Larry Finger wrote:
> I do not think this particular rate control algorithm is needed. A patch has been submitted that 
> will allow the user to use the SIOCSIWRATE ioctl to lock in a rate. In addition, a patch that 
> changes rc80211_simple to set the initial rate to the lowest supported value has also been 
> submitted. With these two alternatives, everything that this proposed module does is supported in 
> other ways.

Ok.

I'd still like to apply the patch allowing to change rate control
algorithm, but I'd like to hear Johannes' comments first - I suspect he
won't like what I did with his macros :-)

 Jiri

-- 
Jiri Benc
SUSE Labs
