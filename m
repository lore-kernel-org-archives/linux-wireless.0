Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53869 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbaJRGxX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 02:53:23 -0400
Message-ID: <1413615195.10246.0.camel@jlt4.sipsolutions.net> (sfid-20141018_085335_833478_A18ACCEE)
Subject: Re: [RFC] mac80211-hwsim:  support creating radios with specific
 name.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Sat, 18 Oct 2014 08:53:15 +0200
In-Reply-To: <1413576721-22258-1-git-send-email-greearb@candelatech.com>
References: <1413576721-22258-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-17 at 13:12 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, it can be very difficult to know which is which
> if you are trying to do detailed testing.

Having just implemented something with dynamic radios in the
wpa_supplicant test suite, I'm having second thoughts about this.

When you create a new radio, it returns the hwsim identifier, which
allows you to find the wiphy name in sysfs easily. Why not just rename
it afterwards from userspace?

johannes

