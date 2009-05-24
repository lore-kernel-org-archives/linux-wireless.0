Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37549 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZEXNTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 May 2009 09:19:51 -0400
Subject: Re: [PATCH 5/5] libertas: fix WPA adhoc network creation
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1243067061.4606.43.camel@johannes.local>
References: <1243037398.2495.14.camel@localhost.localdomain>
	 <1243067061.4606.43.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 24 May 2009 09:19:50 -0400
Message-Id: <1243171190.24236.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-05-23 at 10:24 +0200, Johannes Berg wrote:
> On Fri, 2009-05-22 at 20:09 -0400, Dan Williams wrote:
> > Oddly enough, the firmware's JOIN/START commands don't appear to have
> > any facility for setting custom IEs, thus the started adhoc network
> > doesn't advertise its WPA capability in the beacon.  Whee!
> 
> We don't even properly support WPA IBSS in mac80211...

Hmm, I support creating WPA-PSK adhoc networks in the NM UI (worked last
summer when I added the code), can you give a 10 second summary of
what's missing here?

Dan


