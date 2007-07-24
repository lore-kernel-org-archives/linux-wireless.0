Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:59380 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750990AbXGXVNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2007 17:13:15 -0400
Message-ID: <46A66B63.6030006@garzik.org>
Date: Tue, 24 Jul 2007 17:13:07 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Stephen Clark <Stephen.Clark@seclark.us>,
	Axj <axjslack@bluebottle.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] Request for help...
References: <1185289332.46a61474a444c@mail.bluebottle.com> <20070724161226.GA24344@tuxdriver.com> <46A64503.1080003@seclark.us> <20070724203035.GG24344@tuxdriver.com>
In-Reply-To: <20070724203035.GG24344@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Tue, Jul 24, 2007 at 02:29:23PM -0400, Stephen Clark wrote:
> 
>> Just being a user I am not sure what you mean by come back to working 
>> with community? None of
>> their stuff is hidden is it? Does "the community" make it so hard to get 
>> stuff included that it is
>> not worth the pain for Intel?
> 
> Very simple -- conduct mac80211 development in public on a mailing
> list appropriate to discussion of an in-kernel component rather than
> hiding on a mailing list that is ostensibly for development of a
> specific driver.  As the authors of the patches it is incumbent on
> Intel to post them for inclusion upstream.  That is the price of good
> citizenship in the Linux community.

Not just that... it's good engineering.

Wireless driver patches that don't make it rapidly to linux-wireless and 
upstream rapidly fester.  It becomes a real engineering challenge to 
sync up with upstream, if you don't make that your primary task to begin 
with.

There is a reason why we say "release early, release often."  If 
wireless developers don't hear from Intel on a regular basis, the 
codebases will diverge, wireless hackers will not get the useful 
feedback they need, and Intel hackers will not get the useful feedback 
they need.

Open source isn't just about a source code license.  This is an 
-engineering process-.  Post -> [merge | revise based on feedback ] -> 
<infinity>.  The lower the frequency of posting and community 
interaction, the less you are actually participating in key portions of 
the engineering process.

	Jeff



