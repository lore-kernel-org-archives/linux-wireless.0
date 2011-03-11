Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48880 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1CKOPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 09:15:51 -0500
Date: Fri, 11 Mar 2011 09:13:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 0/2] update for 2.6.39
Message-ID: <20110311141333.GB14583@tuxdriver.com>
References: <1299816807-26813-1-git-send-email-wey-yi.w.guy@intel.com>
 <1299834147.3755.3.camel@jlt3.sipsolutions.net>
 <1299833475.5082.187.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1299833475.5082.187.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 11, 2011 at 12:51:15AM -0800, Guy, Wey-Yi wrote:
> On Fri, 2011-03-11 at 01:02 -0800, Johannes Berg wrote:
> > On Thu, 2011-03-10 at 20:13 -0800, Wey-Yi Guy wrote:
> > > We add off-channel tx support for P2P
> > > 
> > > Johannes Berg (2):
> > >   iwlagn: support off-channel TX
> > >   iwlagn: fix offchannel TX bug
> > 
> > Can't we just squash these into one patch? :)
> > 
> my bad, I did it without thinking :-(
> John, would you like me to resubmit or you can squash these two?

I'll squash them.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
