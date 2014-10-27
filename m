Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24106 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbaJ0LzU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 07:55:20 -0400
Message-ID: <1414410917.2705.201.camel@jrissane-mobl.ger.corp.intel.com> (sfid-20141027_125523_884195_24A2C116)
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and
 removed
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Oct 2014 13:55:17 +0200
In-Reply-To: <1414409485.3836.5.camel@jlt4.sipsolutions.net>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114536_599448_FF2C1C5E) <1414408856.3836.3.camel@jlt4.sipsolutions.net>
	 <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com>
	 <1414409485.3836.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On ma, 2014-10-27 at 12:31 +0100, Johannes Berg wrote:
> On Mon, 2014-10-27 at 13:29 +0200, Jukka Rissanen wrote:
> 
> > Yes, but from generic nl80211 event you cannot know if event is from
> > hwsim radio or not. With this patch, the listener can know that the
> > radio new/del event is specifically related to hwsim radio.
> 
> That's not particularly hard to figure out, for example by looking at
> sysfs.
> 
> Is this really so time-constrained/important/... that you can't do that?

It does not seem very practical to dig this information from sysfs as
the same information can be easily get via netlink as this patch shows.


Cheers,
Jukka


