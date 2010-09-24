Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:62384 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab0IXSvM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 14:51:12 -0400
Subject: Re: [PATCH v3] omap: beagle: add support for wl1271 on the board
 file
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "ext John W. Linville" <linville@tuxdriver.com>
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"tony@atomide.com" <tony@atomide.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
In-Reply-To: <20100924180316.GE8077@tuxdriver.com>
References: <1285236215-21136-1-git-send-email-luciano.coelho@nokia.com>
	 <20100924180316.GE8077@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Sep 2010 21:50:49 +0300
Message-ID: <1285354249.9779.3.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-24 at 20:03 +0200, ext John W. Linville wrote:
> On Thu, Sep 23, 2010 at 01:03:35PM +0300, Luciano Coelho wrote:
> > Add board configuration for the wl1271 daughter board.  This patch is based
> > on Ohad Ben-Cohen's patches for Zoom boards.
> > 
> > Cc: Ohad Ben-Cohen <ohad@wizery.com>
> > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
> > ---
> > from v2 to v3: removed accidental change to wl1271.h
> 
> I presume that this should come through my tree as well (since it
> contains the move of wl12xx.h)?

Yes, this is based on your tree.  But please hold on, because there were
some comments (namely, the expansion board should be detected, not
configured for wl1271 by default), which I still have to fix.  I'm
waiting for the manufacturer of the expansion board to provide me with
some more info for proper detection.

Also, I know that there are some other work being done in the beagle
board file, so we may need to rethink how to sync this.

So, for now, let's skip this patch and I'll provide another one when
these issues are addressed.

-- 
Cheers,
Luca.

