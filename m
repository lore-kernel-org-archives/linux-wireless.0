Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43768 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab1BDUGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 15:06:13 -0500
Message-ID: <4D4C5C2F.50403@candelatech.com>
Date: Fri, 04 Feb 2011 12:06:07 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v10] mac80211: Optimize scans on current operating channel.
References: <1296849257-10260-1-git-send-email-greearb@candelatech.com> <1296849410.3671.15.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296849410.3671.15.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2011 11:56 AM, Johannes Berg wrote:
> I'm not going to be able to review this properly until I get back -- so
> maybe we should just merge it and fix fallout, if any, later?

Well, that is fine by me.  I'll certainly be willing to help
with any issues that come up as a top priority.

I've been running one version or another of this patch for several
weeks and I haven't noticed any obvious problems with it, and
it would be great to get some additional testing coverage.

Most of the real gains will come after we order the operating
channel first in the list of channels to scan, and (if possible)
allow scanning on channel-types other than just NO_HT so that we
can scan-on channel while running HT20, HT40, etc.

Thanks,
Ben


>
> johannes
>
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

