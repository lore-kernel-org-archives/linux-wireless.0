Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2530 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752420AbYEPPvC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 11:51:02 -0400
Date: Fri, 16 May 2008 11:16:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/7][MAC8021]: Fix one more call to synchronize_rcu in
	atomic context.
Message-ID: <20080516151620.GC6510@tuxdriver.com> (sfid-20080516_175108_292806_35C25882)
References: <4821CE54.9000401@openvz.org> <482D6A80.6030804@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <482D6A80.6030804@openvz.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 03:05:36PM +0400, Pavel Emelyanov wrote:

> Sorry for bothering you, I guess that you're very busy now, 
> but what are you plans about this set?
> 
> After I saw my first set included in some wireless git update,
> I thought this one would be in some of the next ones (since
> this set fixes some bugs in mesh tables), and started waiting.
> 
> Here's a new wireless git update and this set is still not in.
> Shall I resubmit one?

Pavel,

I still have your patchset.  I'm still working on clearing my
backlog, as well as waiting for some fixes to make the round-trip
net-2.6->linux-2.6->net-next-2.6.  The combination of that and the
fact that your patch hit locking and "the usual suspects" had not
yet commented on it made me decide to wait until the next round.

If you are desperate to see them sooner, I could probably put them
in the -testing tree early?  Let me know if you would like that.

John
-- 
John W. Linville
linville@tuxdriver.com
