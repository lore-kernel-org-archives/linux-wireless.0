Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36612 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758916Ab0FKRrt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jun 2010 13:47:49 -0400
Subject: Re: [PATCH] wireless: orphan ipw2x00 drivers
From: reinette chatre <reinette.chatre@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100609.225243.179940910.davem@davemloft.net>
References: <1276134269-2273-1-git-send-email-yi.zhu@intel.com>
	 <20100610014547.GA2318@tuxdriver.com>
	 <20100609.225243.179940910.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 10:47:47 -0700
Message-ID: <1276278467.25793.1296.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 22:52 -0700, David Miller wrote:
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Wed, 9 Jun 2010 21:45:47 -0400
> 
> > On Thu, Jun 10, 2010 at 09:44:29AM +0800, Zhu Yi wrote:
> >> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> >> ---
> >> Please let us know if someone is interested in maintaining these drivers.
> > 
> > Any chance of getting some hardware/firmware documentation?
> 
> Indeed.
> 
> I'm extremely disappointed that the only organization currently even
> capable of fixing low level bugs in these drivers no longer is willing
> to do so.

This is not the situation. We recently lost all expertise with these
drivers and are unable to maintain them respectfully anymore.

If we continue to have the MAINTAINERS file commit us to "Odd fixes" we
are still responsible for reviewing/acknowledging patches, answering
community questions related to the driver, and looking into at least
critical bugs. Unfortunately we now have no ability to do any of these
tasks and surely not any better that members from the community (some of
whom actually know these drivers better than any of the people left here
at Intel).

This is why we changed the status to "Orphaned" since it really seem to
reflect our status at this time. We really do not know what else to do. 

I understand that there is a concern with low level bugs for which
hardware documentation may be needed. We surely will do our best to help
out when these situations arise. 

> If documentation can't be provided so that others can maintain this
> driver (not just few specific people, because some day those folks
> might tire of maintaining this too) that would be a serious crime.

We are unable to release this documentation, but are looking into our
options at this time. With groups disbanded this will take some time.

Reinette


