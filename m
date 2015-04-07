Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39126 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbbDGO25 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 10:28:57 -0400
Message-ID: <1428416926.1841.17.camel@sipsolutions.net> (sfid-20150407_162914_475985_1BDC46A6)
Subject: Re: [PATCH] mac80211: Move message tracepoints to their own header
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Date: Tue, 07 Apr 2015 16:28:46 +0200
In-Reply-To: <20150407102146.216cf90b@gandalf.local.home>
References: <20150406231357.2b8e452d@grimm.local.home>
	 <1428389938.1841.1.camel@sipsolutions.net>
	 <20150407102146.216cf90b@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-04-07 at 10:21 -0400, Steven Rostedt wrote:
> On Tue, 07 Apr 2015 08:58:58 +0200
> Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > On Mon, 2015-04-06 at 23:13 -0400, Steven Rostedt wrote:
> > > Every tracing file must have its own TRACE_SYSTEM defined.
> > 
> > Oh, that requirement is new to me. I also have the same in iwlwifi, with
> > even more TRACE_SYSTEMs.
> 
> OK, the reason I did not stumble over this is because the previous
> patch broke the build before I got here.
> 
> During my latest tests, this breaks it too.
> 
> You OK if I make more patches to split that file apart?

Sure, no problem. I don't think we have any work on them that could
possibly conflict now.

johannes

