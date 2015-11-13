Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59563 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932616AbbKMQcx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 11:32:53 -0500
Message-ID: <1447432370.3271.20.camel@sipsolutions.net> (sfid-20151113_173256_547649_C30E77E3)
Subject: Re: [RFC v4 6/8] kconfig: introduce "count"
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-wireless@vger.kernel.org, Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Michal Marek <mmarek@suse.com>
Date: Fri, 13 Nov 2015 17:32:50 +0100
In-Reply-To: <20151113112630.20c27558@gandalf.local.home>
References: <1447318073-22669-1-git-send-email-johannes@sipsolutions.net>
	 <1447318073-22669-7-git-send-email-johannes@sipsolutions.net>
	 <20151113112630.20c27558@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-11-13 at 11:26 -0500, Steven Rostedt wrote:
> 
> >     config MY_DRIVER_2
> >             bool "my driver 2"
> >             count MY_COUNTER
> > 
> > This will get MY_COUNTER to have a value of 0, 1 or 2, depending
> > on whether or not MY_DRIVER_1/MY_DRIVER_2 are not at all, one or
> > both selected respectively.
> 
> I find the name "count" ambiguous. What happened to "increment" or
> something?
> 

I forgot about it :)

I'll go change it to "increment", that does indeed seem better.

johannes
