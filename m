Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43712 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbYJNQsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 12:48:17 -0400
Subject: Re: [PATCH] ipw2200: Change driver default policies
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: timg@tpi.com, linux-wireless@vger.kernel.org
In-Reply-To: <1224002103.10113.42.camel@johannes.berg>
References: <20081014145708.CAF215A1D8@sepang.rtg.net>
	 <1223998992.3936.28.camel@localhost.localdomain> <48F4C7E8.4020201@tpi.com>
	 (sfid-20081014_182519_109984_4FB94716)  <1224002103.10113.42.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 12:47:07 -0400
Message-Id: <1224002827.1799.8.camel@localhost.localdomain> (sfid-20081014_184819_503654_35314675)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 18:35 +0200, Johannes Berg wrote:
> On Tue, 2008-10-14 at 10:25 -0600, Tim Gardner wrote:
> 
> > >> 3) roaming=0 - do not automatically roam to another AP with the same SSID.
> > > 
> > > Not really sure why this should be changed?  Were there reported issues
> > > with this behavior?
> > > 
> > 
> > Its been my expereince that wireless drivers rarely make the correct
> > decision about when or where to roam. It also seems like a policy
> > decision that ought to be made elsewhere.
> > 
> > Frankly, I'm not that concerned about the roaming option. The default
> > for 'associate' was the one I _really_ wanted changed. I'll submit a v2
> > patch with just that change.
> 
> Would that also turn off the spectrum-polluting continuous scanning
> these cards do? :)

No, that would be a separate patch to disable the background scanning
behavior or at least tone it down to once every few seconds or
something.

Dan


