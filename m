Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from toronto053.server4you.de ([62.75.220.53]:35672 "EHLO
	toronto053.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbZDVLd4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 07:33:56 -0400
Date: Wed, 22 Apr 2009 13:35:56 +0200
From: Daniel Wagner <wagi@monom.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Simulate medium behavior
Message-ID: <20090422113556.GB24586@toronto053.server4you.de> (sfid-20090422_133359_895892_4CC274E4)
References: <20090422092159.GA24586@toronto053.server4you.de> <1240393088.21756.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240393088.21756.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 22, 2009 at 11:38:08AM +0200, Johannes Berg wrote:
> Hi,
> 
> > Writing a 0 to /debug/ieee80211/phy*/hwsim/medium enables rx/tx for
> > the specific phy. Writing anything but 0 disables rx/tx.  Not a very
> > good API. It could be made something more realistic like reception
> > quality is 80% associated some statistical dropping algorithm. Any
> > thoughts?
> > 
> > Is this the right direction I'm heading to?
> 
> This looks like a very simple knob, just a little more work could get
> you much further -- have you seen this email/thread?
> 
> http://thread.gmane.org/gmane.linux.kernel.wireless.general/25001

No, I haven't. Yep, my solution is really too simple.  I like the
virtual air grouping. I'll implement it.

thanks for the tip!
daniel


