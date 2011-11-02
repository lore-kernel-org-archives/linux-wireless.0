Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43184 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab1KBRvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Nov 2011 13:51:41 -0400
Subject: Re: [wireless-next PATCH v2 1/4] mac80211: Support forcing station
 to disable 11n.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4EB1726E.5010503@candelatech.com>
References: <1319840474-2618-1-git-send-email-greearb@candelatech.com>
	 (sfid-20111029_002128_214854_3ACBE979) <1320220666.3950.6.camel@jlt3.sipsolutions.net>
	 <4EB1726E.5010503@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Nov 2011 18:51:36 +0100
Message-ID: <1320256296.7846.4.camel@jlt3.sipsolutions.net> (sfid-20111102_185146_016732_CC131C9F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-02 at 09:40 -0700, Ben Greear wrote:
> On 11/02/2011 12:57 AM, Johannes Berg wrote:
> > On Fri, 2011-10-28 at 15:21 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear<greearb@candelatech.com>
> >>
> >> This allows a user to configure a wifi station interface
> >> to disable 802.11n, even if the AP and NIC supports it.
> >
> > You really should've waited for the review on v1 to finish -- this v2 is
> > worthless. That makes John think that you addressed all review feedback,
> > when really we didn't even finish discussing some points; eventually
> > that'll just force me to have my own tree so John isn't confused all the
> > time.
> 
> I explicitly noted in the comments for several of the patches
> that I did not address all of your comments.  I re-posted because
> I thought I could at least fix some of your concerns and hopefully
> get the patches closer to right and make further reviews easier.

Ok, fair enough. I just saw them as extra mail and basically didn't even
read them, maybe I should have.

johannes

