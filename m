Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000Ab3KMScP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 13:32:15 -0500
Message-ID: <1384367532.14578.23.camel@jlt4.sipsolutions.net> (sfid-20131113_193218_696769_5BE4CD9E)
Subject: Re: RFC:  Add precise timing to wifi association messages?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 13 Nov 2013 19:32:12 +0100
In-Reply-To: <5283C3F7.4090700@candelatech.com>
References: <5283BDB6.5020700@candelatech.com>
	  <5283BE63.8090801@candelatech.com>
	 (sfid-20131113_190112_830842_FCA007A3) <1384366716.14578.13.camel@jlt4.sipsolutions.net>
	 <5283C3F7.4090700@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 10:24 -0800, Ben Greear wrote:
> On 11/13/2013 10:18 AM, Johannes Berg wrote:
> > On Wed, 2013-11-13 at 10:01 -0800, Ben Greear wrote:
> > 
> >> I chose a poor example here...my intention is to just add timers to existing
> >> messages...
> > 
> > What does this do that printk timestamps don't?
> 
> Sub-second precision, and the same in 'dmesg' output.
> 
> There may be a way to get /var/log/messages to show sub-second
> precision, but at least it is not enabled by default on the systems
> I use.  dmesg has no timestamps at all from what I can tell.

Err. Just set CONFIG_PRINTK_TIME in your kernel.

johannes

