Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab2K2OFI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 09:05:08 -0500
Message-ID: <1354197930.879.1.camel@jlt4.sipsolutions.net> (sfid-20121129_150523_432705_3CABBC3D)
Subject: Re: [PATCH v2] mac80211: add debugfs file for current tx rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 29 Nov 2012 15:05:30 +0100
In-Reply-To: <50B76AC0.3060507@posedge.com>
References: <50B768A5.1040701@posedge.com>
	 <1354197377.879.0.camel@jlt4.sipsolutions.net>
	 <50B76AC0.3060507@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 19:31 +0530, Saravana wrote:
> On 11/29/2012 07:26 PM, Johannes Berg wrote:
> > On Thu, 2012-11-29 at 19:22 +0530, Saravana wrote:
> >> Add a debugfs file showing the current tx rate.
> >> The information available in the rc_stats file
> >> doesn't evidently provides us the current tx rate.
> >> This patch adds the support for the same.
> > 
> > Applied. But it doesn't actually require the *rx* rework, so I've left
> > that out.
> > 
> *rx* rework is required for the last rx rate stat. 
> After giving my rationale on the need for addition of 
> last rx rate and mic failure count stat, i am waiting for 
> your inputs regarding the same. 

Oh sorry. I'm not sure I'd use it, but if you find it useful it's just
debugfs so go ahead.

johannes

