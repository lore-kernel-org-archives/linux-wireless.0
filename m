Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38858 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753511AbbDGNkU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 09:40:20 -0400
Message-ID: <1428414006.1841.16.camel@sipsolutions.net> (sfid-20150407_154039_390054_EE2BF258)
Subject: Re: [PATCH] mac80211: Move message tracepoints to their own header
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Date: Tue, 07 Apr 2015 15:40:06 +0200
In-Reply-To: <20150407085550.7dc6aaed@gandalf.local.home>
References: <20150406231357.2b8e452d@grimm.local.home>
	 <1428389938.1841.1.camel@sipsolutions.net>
	 <20150407085550.7dc6aaed@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-07 at 08:55 -0400, Steven Rostedt wrote:

> Hmm, I must have missed the iwlwifi part, as that should have not built
> with an allmodconfig :-/

Dunno, it seems that should be selected with allmodconfig, and it has 5
different ones ... :)

> > I could merge through my tree but I guess you'll want to put it through
> > a different one to be able to change the code that depends on this move.

> Right, I'll need to pull this in my tree, as I have a set of patches
> dependent on this.

Makes sense.

johannes

