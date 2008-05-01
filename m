Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3592 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556AbYEAU3K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 16:29:10 -0400
Date: Thu, 1 May 2008 16:02:31 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix some TX/RX locking issues
Message-ID: <20080501200231.GA21387@tuxdriver.com> (sfid-20080501_222858_589090_004A590C)
References: <200804251929.09301.mb@bu3sch.de> <200805011208.10533.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805011208.10533.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 01, 2008 at 12:08:10PM +0200, Michael Buesch wrote:
> John, did you drop this patch? I can't see it in git and your latest push,
> while a patch submitted later is in there.

No, I'm sorry.  I fat-fingered my patches.  I've still got it, and
it will go in the next round.

John

> On Friday 25 April 2008, Michael Buesch wrote:
> > This fixes some TX/RX related locking issues.
> > With this patch applied, some of the PHY transmission errors are fixed.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > John, this is for 2.6.26.
-- 
John W. Linville
linville@tuxdriver.com
