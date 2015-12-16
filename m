Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43081 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbbLPOOT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:14:19 -0500
Message-ID: <1450275253.8247.16.camel@sipsolutions.net> (sfid-20151216_151422_583685_21BF6AFB)
Subject: Re: question on "mac80211_hwsim: support any address in userspace"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>
Date: Wed, 16 Dec 2015 15:14:13 +0100
In-Reply-To: <56717119.1040701@candelatech.com>
References: <5670DA9A.4010102@candelatech.com>
				 (sfid-20151216_042934_976896_DCE1A2B3) <1450257464.3159.1.camel@sipsolutions.net>
			 <56716386.4070107@candelatech.com>
		 <1450272308.8247.11.camel@sipsolutions.net>
		 <567168AF.4060804@candelatech.com>
	 <1450273362.8247.15.camel@sipsolutions.net>
	 <56717119.1040701@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-12-16 at 06:11 -0800, Ben Greear wrote:
> 
> > You can query the ID/index already through the netlink API, or even
> > from sysfs since the virtual device name is essentially
> > 	sprintf(name, "hwsim%d", idx)
> 
> Good lord, please don't even suggest parsing the name.  You can
> easily rename a phy device.  I do it all the time to keep a phyname
> associated with a real radio through module reloads.
> 

You're confusing the wiphy name and the hwsim virtual class device name
(which you can't touch) :)

johannes
