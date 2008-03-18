Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:49791 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYCRBBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 21:01:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 1/5] b43: Use the b43_phy_maskset where possible
Date: Tue, 18 Mar 2008 02:00:09 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1205801249.2329.49.camel@brick>
In-Reply-To: <1205801249.2329.49.camel@brick>
MIME-Version: 1.0
Message-Id: <200803180200.09331.mb@bu3sch.de> (sfid-20080318_010149_736434_F69E45AE)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 18 March 2008 01:47:29 Harvey Harrison wrote:
> [lots of patches]

What do these patches actually fix?
I see they shuffle a _lot_ of code around, but what does that
actually fix? As I said, I won't apply any patch that just shuffles
code without fixing anything.

This shuffling has a _HUGE_ risk of introducing bugs that I am NOT
going to debug and fix afterwards.
The code works pretty well. There's absolutely no need to rewrite it.

And no, "this makes the code 200bytes smaller" doesn't count as a fix. :)

We do _not_ understand what this code does and it is a really really huge
pain in the ass to debug. So I am not going to risk bugs here.

Please search for another target, like the b43-MAC code (everything except
the PHY stuff).
Of course, if you found an actual bug in the PHY code, I'd like to know
and I'd like to have a patch that fixes it without shuffling hundreds
of lines of code.

Thanks a lot.

-- 
Greetings Michael.
