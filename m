Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:44761 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751747AbYKNRoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 12:44:23 -0500
Date: Fri, 14 Nov 2008 09:30:09 -0800
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
	"otus-devel@lists.madwifi-project.org"
	<otus-devel@lists.madwifi-project.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [FYI] ar9170 driver
Message-ID: <20081114173009.GB22980@kroah.com> (sfid-20081114_184426_809556_BC2204A1)
References: <1226531034.14186.39.camel@johannes.berg> <491D380D.7050707@teltonika.lt> <1226660018.4120.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226660018.4120.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 14, 2008 at 11:53:38AM +0100, Johannes Berg wrote:
> On Fri, 2008-11-14 at 10:34 +0200, Paulius Zaleckas wrote:
> 
> > If this driver is not going in through wireless or any other tree, because it
> > still needs some work, maybe it is worth to get it to staging tree maintained
> > by Greg?
> 
> No way. It _will_ go through the wireless tree, trust me, it's just not
> ready yet. Meanwhile, Greg has the mess of a vendor driver.

I agree, Johannes is doing the right thing here, it doesn't need to be
in the staging tree at all.

thanks,

greg k-h
