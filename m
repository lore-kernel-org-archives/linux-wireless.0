Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45919 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1DZUao (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:30:44 -0400
Date: Tue, 26 Apr 2011 16:27:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2.6.39 v2] iwlegacy: led stay solid on when no traffic
Message-ID: <20110426202721.GN2804@tuxdriver.com> (sfid-20110426_223047_648249_19C39239)
References: <1303755177-28781-1-git-send-email-wey-yi.w.guy@intel.com>
 <20110426190816.GH2804@tuxdriver.com>
 <1303845011.14995.204.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303845011.14995.204.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 12:10:11PM -0700, Guy, Wey-Yi wrote:
> On Tue, 2011-04-26 at 12:08 -0700, John W. Linville wrote:
> > On Mon, Apr 25, 2011 at 11:12:57AM -0700, Wey-Yi Guy wrote:
> > > commit 843f26f06a41c5797f19e843c23ca4ed2a71a0bc change the led behavior
> > > for iwlwifi driver; the side effect cause led blink all the time.
> > > 
> > > Modify the led blink table to fix this problem
> > > 
> > > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > 
> > Patch seems fine, but I can't find the listed commit ID that caused this issue?
> > 
> it is in wireless-testing

/home/linville/git/wireless-testing
[linville-8530p.local]:> git show 843f26f06a41c5797f19e843c23ca4ed2a71a0bc
fatal: bad object 843f26f06a41c5797f19e843c23ca4ed2a71a0bc

Must be your local tree?

> commit 843f26f06a41c5797f19e843c23ca4ed2a71a0bc
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Dec 15 07:30:01 2010 -0800
> 
>     iwlwifi: use mac80211 throughput trigger
>     
>     Instead of keeping track of LED blink speed
>     in the driver, use the new mac80211 trigger
>     and link it up with an LED classdev that we
>     now register. This also allows users more
>     flexibility in how they want to have the LED
>     blink or not.
>     
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>     Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> 
> 
> 
> for wireless-next-2.6, it is
> commit#commit 5ed540aecc2aae92d5c97b9a9306a5bf88ad5574

Thanks -- please cite the commit IDs from the public trees or just
use the subject.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
