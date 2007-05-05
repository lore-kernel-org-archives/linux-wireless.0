Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4342 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452AbXEEFc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 May 2007 01:32:26 -0400
Date: Sat, 5 May 2007 01:26:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/4] add mac80211 wireless infrastructure
Message-ID: <20070505052635.GB6041@tuxdriver.com>
References: <20070505031749.GA5308@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070505031749.GA5308@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 04, 2007 at 11:17:49PM -0400, John W. Linville wrote:

> The wireless developers would like this to be considered for merge
> in time for 2.6.22.  Patches for at least one mac80211-based driver
> will follow shortly.

Ooops!  I forgot to add a "From: Jiri Benc..." line to the top of
the mailed patches.

Dave, can you add that before applying them?  Or shall I resend?

Also, if you apply the copies on my kernel.org page or if you pull
from git then the Author information should already be correct:

	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git mac80211

Sorry for the confusion!

John

P.S.  Hmmm...I would have thought that I would have seen the patches
I sent by now...?  Did the list eat them?  I don't think they were
that big...?  Let me know if I need to re-send.
-- 
John W. Linville
linville@tuxdriver.com
