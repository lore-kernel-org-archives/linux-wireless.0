Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:43760 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbZAEEtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 23:49:03 -0500
Date: Mon, 5 Jan 2009 06:02:48 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andi Kleen <andi@firstfloor.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105050248.GG496@one.firstfloor.org> (sfid-20090105_054914_739278_1EA36CCD)
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49618497.50809@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 04, 2009 at 09:55:03PM -0600, Larry Finger wrote:
> Andi Kleen wrote:
> > 
> > Same issue with this patch. It fluctuates some time between 11Mbit/s
> > and 48Mbit/s, but then eventually settles on 1Mbit/s again. That's with PID
> > now, not Mistrel. I think it takes longer with this patch than
> > before, but not much.
> > 
> > BTW I see the problem with RT2561 too.
> 
> Can you retry with mistrel? In my experience, it converges to a lower rate than
> does pid, but it doesn't fluctuate as much.

Minstrel stays constantly at 1 Mbit/s

-Andi
-- 
ak@linux.intel.com
