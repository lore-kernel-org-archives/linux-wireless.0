Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44212 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYH3NA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2008 09:00:29 -0400
Date: Sat, 30 Aug 2008 08:58:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-08-29
Message-ID: <20080830125833.GC11718@tuxdriver.com> (sfid-20080830_150034_903276_81A646B4)
References: <20080829205414.GB11718@tuxdriver.com> <20080829.140303.71048853.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080829.140303.71048853.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2008 at 02:03:03PM -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Fri, 29 Aug 2008 16:54:14 -0400
> 
> > Here is this week's supply of stuff for -next -- mostly cleanups and
> > other driver updates.  Please let me know if there are problems!
>  ...
> > are available in the git repository at:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git master
> 
> I'm pulling this, thanks John.
> 
> I hope to get a chance tonight to deal with that net-2.6 vs. net-next-2.6
> wireless conflict by doing a merge.  It had to do with that IBSS message
> your ifdef'd out in net-2.6

Ah, yes...it looks trivial to fix, but the trivial fix won't build!

I have it fixed here:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git merged-test

And the fixed file is the same as what is in wireless-testing.

Hth!

John
-- 
John W. Linville
linville@tuxdriver.com
