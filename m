Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54354 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbbDNINk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 04:13:40 -0400
Message-ID: <1428999215.3019.6.camel@sipsolutions.net> (sfid-20150414_101345_327965_BBBD3C0B)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 14 Apr 2015 10:13:35 +0200
In-Reply-To: <551AC3B6.1040001@candelatech.com>
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>
	  	  (sfid-20150218_005956_617537_D2A9B91F) <1424692155.2782.6.camel@sipsolutions.net>
	  	 <54EB66CC.1030800@candelatech.com>
	   <1424772714.2192.16.camel@sipsolutions.net>
	   <54EC8C5D.5090400@candelatech.com>
	  <1424788834.2192.34.camel@sipsolutions.net>
	  <5500AE12.6040103@candelatech.com>
	 <1427812067.2057.27.camel@sipsolutions.net>
	 <551AC3B6.1040001@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-31 at 08:56 -0700, Ben Greear wrote:

> > Well, depends. Our driver just asks the firmware to do the scan, and it
> > will do all the scheduling by itself, i.e. it'll go through the channels
> > at convenient times etc.
> 
> I do not want to offload scanning in user-space, which is the equivalent
> of what your driver is doing as far as the kernel is concerned?  If someone wants
> to do that in the future, then sure, they can implement such a thing.

Well, the question isn't really that offloading, the question is what
happens with the hw-scan logic in hwsim? Though I guess now that I think
about it, that wouldn't show up in userspace at all with your changes.

johannes

