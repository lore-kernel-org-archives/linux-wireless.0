Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:47518 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755908AbbDGOVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 10:21:50 -0400
Date: Tue, 7 Apr 2015 10:21:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Move message tracepoints to their own header
Message-ID: <20150407102146.216cf90b@gandalf.local.home> (sfid-20150407_162228_182653_EFB58B50)
In-Reply-To: <1428389938.1841.1.camel@sipsolutions.net>
References: <20150406231357.2b8e452d@grimm.local.home>
	<1428389938.1841.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 07 Apr 2015 08:58:58 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2015-04-06 at 23:13 -0400, Steven Rostedt wrote:
> > Every tracing file must have its own TRACE_SYSTEM defined.
> 
> Oh, that requirement is new to me. I also have the same in iwlwifi, with
> even more TRACE_SYSTEMs.

OK, the reason I did not stumble over this is because the previous
patch broke the build before I got here.

During my latest tests, this breaks it too.

You OK if I make more patches to split that file apart?

Thanks,

-- Steve
