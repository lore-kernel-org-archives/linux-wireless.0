Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2293 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992549AbXEBCwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2007 22:52:16 -0400
Date: Tue, 1 May 2007 22:16:56 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jiri Benc <jbenc@suse.cz>, Daniel Drake <dsd@gentoo.org>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: limit URB buffering in tx path
Message-ID: <20070502021656.GB5621@tuxdriver.com>
References: <20070501030100.BDE3D7B409F@zog.reactivated.net> <20070501123411.081c43c6@logostar.upir.cz> <20070501195008.GA14294@p15091797.pureserver.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070501195008.GA14294@p15091797.pureserver.info>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 01, 2007 at 09:50:08PM +0200, Ulrich Kunitz wrote:
> On 07-05-01 12:34 Jiri Benc wrote:

> > It is :-) Look for ieee80211_wake_queues. But as I said, you shouldn't need
> > that.
> 
> I provided the patch to add ieee80211_wake_queues(). Sorry for
> missing the moment, when it has been integrated. I will update the
> patch.

No need, I have adjusted the patch accordingly.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
