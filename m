Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59659 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab0JGSPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 14:15:09 -0400
Date: Thu, 7 Oct 2010 14:04:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 1/6] iwlwifi: schedule to deprecate software scan support
Message-ID: <20101007180421.GC20950@tuxdriver.com>
References: <1286378593-7509-1-git-send-email-wey-yi.w.guy@intel.com>
 <1286378593-7509-2-git-send-email-wey-yi.w.guy@intel.com>
 <20101006173609.GH2472@tuxdriver.com>
 <1286387500.12594.24.camel@wwguy-ubuntu>
 <20101006190343.GI2472@tuxdriver.com>
 <1286440790.3657.28.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286440790.3657.28.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 07, 2010 at 10:39:50AM +0200, Johannes Berg wrote:
> On Wed, 2010-10-06 at 15:03 -0400, John W. Linville wrote:
> 
> > > The current HW scan implementation was improve a lot and sw scan will
> > > cause problem, especially once we introduce P2P.
> > 
> > What support issues are caused by supporting software scanning?
> > 
> > Whatever issues are caused by scanning with P2P, doesn't mac80211
> > have to handle them anyway?
> 
> Technically, yes, but there are some things it doesn't handle today, and
> there are some things in mac80211's scan implementation that
> unfortunately make our firmware somewhat unhappy. Also, when we have two
> virtual interfaces (for p2p) the firmware can get completely confused by
> a software scan, especially when we were operating as a p2p-GO.
> 
> But isn't this the wrong way around -- shouldn't you be arguing why it
> should be kept and dig out bug reports about the HW scan implementation
> that weren't addressed? ;-)

Hmmm...not so sure about that.  Alan Cox has been quoted as saying
"a maintainer's job is to say no".

I suppose we can argue about this again when you actually try to
remove the option...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
