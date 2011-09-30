Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51894 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1I3Spk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 14:45:40 -0400
Date: Fri, 30 Sep 2011 14:43:11 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] mac80211: pass vif param to conf_tx() callback
Message-ID: <20110930184310.GB2526@tuxdriver.com> (sfid-20110930_204544_106277_0443F498)
References: <1316970415-23239-1-git-send-email-eliad@wizery.com>
 <1316970415-23239-3-git-send-email-eliad@wizery.com>
 <1317217708.3986.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1317217708.3986.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 28, 2011 at 03:48:28PM +0200, Johannes Berg wrote:
> On Sun, 2011-09-25 at 20:06 +0300, Eliad Peller wrote:
> > tx params should be configured per interface.
> > Add ieee80211_vif param to the conf_tx callback,
> > and update all the drivers that use this callback.
> 
> I see patches 1 and 2 in the tree, but not this. I suspect the reason is
> that it was actually incomplete, not updating for example iwlwifi
> because there the function is defined in another file and the spatch
> failed?

It didn't apply.  I thought I might try again now that I pulled
wireless into wireless-next...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
