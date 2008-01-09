Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4922 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752487AbYAICUJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2008 21:20:09 -0500
Date: Tue, 8 Jan 2008 20:49:57 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	davem@davemloft.net
Subject: Belay that... -- Re: Please pull 'upstream-jgarzik' branch of
	wireless-2.6
Message-ID: <20080109014957.GA3048@tuxdriver.com> (sfid-20080109_022022_922566_A7C94C27)
References: <20080108222305.GD3086@tuxdriver.com> <20080108224202.GE3086@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080108224202.GE3086@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please don't pull yet -- I let a patch get in out of order.

I'll post a new pull request when I straighten this out...

John

On Tue, Jan 08, 2008 at 05:42:02PM -0500, John W. Linville wrote:
> On Tue, Jan 08, 2008 at 05:23:05PM -0500, John W. Linville wrote:
> > Jeff,
> > 
> > Another round of patches intended for 2.6.25...the biggest factions are
> > rt2x00 and b43 updates, as well as some Viro-isms... :-)
> > 
> > Please let me know if there are any problems!
> > 
> > John
> > 
> > P.S.  Copying Dave in case he is handling these requests...FWIW, it
> > will definitely depend on the patches already in netdev-2.6#upstream...
> 
> I left out a patch.  I have pushed it on top of the previous request.
> 
> Let me know if there are problems!
> 
> Thanks,
> 
> John
-- 
John W. Linville
linville@tuxdriver.com
