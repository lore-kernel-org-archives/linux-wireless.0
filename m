Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54173 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934360AbbIVTQc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2015 15:16:32 -0400
Message-ID: <1442949387.2018.50.camel@sipsolutions.net> (sfid-20150922_211639_523683_51C745AF)
Subject: Re: [PATCH] iwlwifi: fix requested firmware name for iwlwifi-3160
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>, emmanuel.grumbach@intel.com
Cc: ilw@linux.intel.com, linux-wireless@vger.kernel.org
Date: Tue, 22 Sep 2015 21:16:27 +0200
In-Reply-To: <5601A883.1010209@hauke-m.de>
References: <1442659190-6060-1-git-send-email-hauke@hauke-m.de>
	 (sfid-20150919_124007_995516_62A820AE) <1442911476.2018.2.camel@sipsolutions.net>
	 (sfid-20150922_104447_027012_36D311B0) <1442911617.2018.3.camel@sipsolutions.net>
	 <5601A883.1010209@hauke-m.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> Should I change something?

No, I already created a different patch to make it simply use the 7260
number instead of the 3165 one. I also made one, in fact, to get rid of
the 3165 since that has the same values anyway.

> iwl3165 uses iwl3160 firmware, but support for that was added in rev 
> 13 of that firmware. That's the information I got from the driver and
> the linux-firmware commit messages.
> 

Ah. it may be that we have changed this internally vs. upstream, need
to check on that. Actually, Luca will just find out when he tries to
upstream my changes :)

johannes
