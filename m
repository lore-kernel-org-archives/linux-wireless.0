Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:54348 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbZADR1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 12:27:39 -0500
Date: Sun, 4 Jan 2009 18:41:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-wireless@vger.kernel.org
Subject: Re: rate instability in wireless stack
Message-ID: <20090104174123.GW496@one.firstfloor.org> (sfid-20090104_182743_018358_1C91B6E8)
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200901041736.47650.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 04, 2009 at 05:36:47PM +0100, Michael Buesch wrote:
> On Sunday 04 January 2009 17:46:49 Andi Kleen wrote:
> [snip]
> 
> I guess you're using the minstrel rate control.
> Can you switch to PID rate control and retry.

I thought i had tried both, but on rechecking it looks like
Kconfig makes it actively hard to do that (grumbl) and probably minstrel
was on all the time.

Anyways with PID i get between 1Mbit/s and 5.5Mbit/s, most of the
time 1Mbit/s. So it's not really much better.

-Andi
-- 
ak@linux.intel.com
