Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.225]:24089 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756586AbYCRBKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 21:10:54 -0400
Received: by wr-out-0506.google.com with SMTP id c48so4262646wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 18:10:53 -0700 (PDT)
Subject: Re: [PATCH 1/5] b43: Use the b43_phy_maskset where possible
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200803180200.09331.mb@bu3sch.de>
References: <1205801249.2329.49.camel@brick>
	 <200803180200.09331.mb@bu3sch.de>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 18:10:51 -0700
Message-Id: <1205802651.2329.59.camel@brick> (sfid-20080318_011105_271376_F5A30DD1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-03-18 at 02:00 +0100, Michael Buesch wrote:
> On Tuesday 18 March 2008 01:47:29 Harvey Harrison wrote:
> > [lots of patches]
> 
> What do these patches actually fix?
> I see they shuffle a _lot_ of code around, but what does that
> actually fix? As I said, I won't apply any patch that just shuffles
> code without fixing anything.

This was done as I checked through the remaining nested cases for
mismatched registers being read/written to after sending the fix
for the braces typo last week.  The easiest way I found to do that
was convert them over as I checked them.


> This shuffling has a _HUGE_ risk of introducing bugs that I am NOT
> going to debug and fix afterwards.
> The code works pretty well. There's absolutely no need to rewrite it.
> 
> And no, "this makes the code 200bytes smaller" doesn't count as a fix. :)
> 

Well, I think in some cases it looks a _lot_ better, but I understand
your reluctance to mess with something lacking docs.

> We do _not_ understand what this code does and it is a really really huge
> pain in the ass to debug. So I am not going to risk bugs here.
> 
> Please search for another target, like the b43-MAC code (everything except
> the PHY stuff).
> Of course, if you found an actual bug in the PHY code, I'd like to know
> and I'd like to have a patch that fixes it without shuffling hundreds
> of lines of code.

I'm done here, just thought as I had done the work while checking it
I may as well make it available in case someone wanted it.

Cheers,

Harvey

