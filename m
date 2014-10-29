Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38816 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934055AbaJ2QLm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 12:11:42 -0400
Message-ID: <1414599099.1827.29.camel@jlt4.sipsolutions.net> (sfid-20141029_171145_468749_3ACBE762)
Subject: Re: [PATCH] mac80211-hwsim:  add frequency attribute to netlink pkts
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 17:11:39 +0100
In-Reply-To: <54510F7B.4040102@candelatech.com>
References: <1414447486-10385-1-git-send-email-greearb@candelatech.com>
	 <1414598110.1827.19.camel@jlt4.sipsolutions.net>
	 <54510F7B.4040102@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-10-29 at 09:02 -0700, Ben Greear wrote:
> On 10/29/2014 08:55 AM, Johannes Berg wrote:
> > On Mon, 2014-10-27 at 15:04 -0700, greearb@candelatech.com wrote:
> >> From: Ben Greear <greearb@candelatech.com>
> >>
> >> Add frequency attribute when sending to user-space over
> >> netlink socket.  The frequency is currently ignored when
> >> receiving from user-space.
> > 
> > Applied.
> 
> Do you have any suggestions for how to deal with pkts
> received (from user-space netlink) on a frequency that does
> not match the current hwsim radio's center frequency?

No, sorry. I don't even know if you can find out the current frequency?
If you have multi-channel you don't even have a single frequency :)

johannes

