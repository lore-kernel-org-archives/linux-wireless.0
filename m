Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3607 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbXIQSKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 14:10:37 -0400
Date: Mon, 17 Sep 2007 13:37:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] b43legacy: Don't cancel the restart workqueue in  wireless_core_exit
Message-ID: <20070917173754.GD9282@tuxdriver.com>
References: <46e577e8.J3sSMKsbv5F0EAQY%Larry.Finger@lwfinger.net> <20070917150358.GC9282@tuxdriver.com> <46EEB3E0.4010501@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <46EEB3E0.4010501@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 17, 2007 at 12:05:36PM -0500, Larry Finger wrote:
> John W. Linville wrote:
> > Is this the correct patch?  The first hunk conflicts with an earlier
> > patch ("b43legacy: Fix cancellation of work queues").
> > 
> > John
> 
> Yes, this one is correct. The first one was without a commit message, and had an error.

Hmmmm, not that one.  There was another patch that (looking closer)
you sent me and cc'ed bcm43xx-dev on or about 30 August.  I guess
I'll drop that one and use this one instead.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
