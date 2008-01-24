Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51664 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751936AbYAXW0v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 17:26:51 -0500
Date: Thu, 24 Jan 2008 14:26:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michael Buesch <mb@bu3sch.de>
cc: linux-wireless@vger.kernel.org
Subject: Re: Linux 2.6.24-rc7
In-Reply-To: <200801242317.50948.mb@bu3sch.de>
Message-ID: <alpine.LFD.1.00.0801241423190.7482@hp.linux-foundation.org> (sfid-20080124_222654_579341_2CA8D0BB)
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <200801081630.31110.mb@bu3sch.de> <alpine.LFD.1.00.0801241224050.2803@woody.linux-foundation.org> <200801242317.50948.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Thu, 24 Jan 2008, Michael Buesch wrote:
> 
> This was fixed in the drivers. A fix for zd1211rw got in and for
> the RTL wireless drivers. Did any other driver trigger this warning?

The Intel driver does, and was tagged as the main culprit in at least the 
pseudo-automated oops reports that Arjan sends to lkml.

> So it can cause some delay sometimes, but I'm pretty sure the fixes
> should have hit mainline by now. I can recheck that if you desire.

I'm 100% sure they haven't, since I could trigger this warning as of the 
tree an hour ago (and I have since reverted it, so now I can't). That's 
what reminded me - doing a final round of "test on the machines I have 
available" before releasing 2.6.24.

			Linus
