Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([207.115.11.56]:36711 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbZDJE7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 00:59:43 -0400
Message-ID: <49DED22E.4000001@lwfinger.net> (sfid-20090410_065946_469700_355608C2)
Date: Thu, 09 Apr 2009 23:59:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Kalle Valo <kalle.valo@iki.fi>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Another regression in 2.6.30-rc1
References: <49DE1638.8060906@lwfinger.net> <873achunwz.fsf@litku.valot.fi>
In-Reply-To: <873achunwz.fsf@litku.valot.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> 
> Thanks Larry, this was very helpful. After cherry picking this commit
> wireless-testing is booting without errors for me.
> 
> In general sharing regressions and workarounds in this list is a very
> good idea. I'm sure most of the people (including me) don't have time to
> follow lkml and find fixes for all regressions.

I make a point of following Linus's tree quite closely during the merge process
so that the number of rebuilds is not too large when I do a bisection. For some
reason, the stuff that comes in just before -rc1 seems to have the most
problems. I had 3 regressions from the last two batches of commits. Fortunately,
I only had to bisect two of them, but it was interesting while finding the
third. At every kernel build I had to test whether the patches for the other 2
cases needed to be installed. The 3rd regression and one of the others were from
successive commits! Murphy rules.

When I know of unfixed problems in the wireless-testing tree, I will certainly
continue to post whatever info I have, just as I rely on the members of this
list when I have a problem.

Larry


