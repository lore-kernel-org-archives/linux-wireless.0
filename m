Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39585 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab2CPOCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 10:02:11 -0400
Date: Fri, 16 Mar 2012 09:49:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Support getting sta_info stats via ethtool.
Message-ID: <20120316134909.GA2563@tuxdriver.com> (sfid-20120316_150214_216166_289E797F)
References: <1331833159-12694-1-git-send-email-greearb@candelatech.com>
 <1331833159-12694-2-git-send-email-greearb@candelatech.com>
 <1331837531.3432.36.camel@jlt3.sipsolutions.net>
 <4F623B58.1070106@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F623B58.1070106@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 15, 2012 at 11:56:24AM -0700, Ben Greear wrote:
> On 03/15/2012 11:52 AM, Johannes Berg wrote:
> >On Thu, 2012-03-15 at 10:39 -0700, greearb@candelatech.com wrote:
> >>From: Ben Greear<greearb@candelatech.com>
> >>
> >>This lets ethtool print out stats related to station
> >>interfaces.  Does not yet get stats from the underlying
> >>driver.
> >
> >Hmm. What's the advantage of using ethtool over iw, which already has a
> >bunch of these numbers?
> 
> Well, ethtool api might be easier for some apps to use,
> and perhaps easier for users to read if all they want
> are stats.

And they can use the same tool for both wired and wireless interfaces
-- could be handy.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
