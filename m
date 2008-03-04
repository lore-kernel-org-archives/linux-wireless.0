Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4055 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbYCDWc3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Mar 2008 17:32:29 -0500
Date: Tue, 4 Mar 2008 17:16:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-03-04
Message-ID: <20080304221641.GC3158@tuxdriver.com> (sfid-20080304_223234_512558_B355682B)
References: <20080304212953.GB3158@tuxdriver.com> <20080304.134003.223058560.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080304.134003.223058560.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 04, 2008 at 01:40:03PM -0800, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Tue, 4 Mar 2008 16:29:53 -0500
> 
> > Here is today's round of fixes for the 2.6.25 tree.  These are mostly
> > simple fixes, even one-liners.  The rc80211-pid patch is, of course, an
> > exception...
> 
> Please don't just clone Linus's tree, pull net-2.6, and then stuff
> things on top of that and ask me to pull.  I end up being forced to
> end up with a merge of Linus's current tree as a result, and that's
> not how this is supposed to work.
> 
> I keep net-2.6 stable for a reason.  Jeff did what you're doing right
> now the other week and now you're doing it too.

Sorry, Dave.  I'll fix it up and post a new request.

John
-- 
John W. Linville
linville@tuxdriver.com
