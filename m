Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51198 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaJ0Lbg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 07:31:36 -0400
Message-ID: <1414409485.3836.5.camel@jlt4.sipsolutions.net> (sfid-20141027_123139_005955_66405B29)
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and
 removed
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Oct 2014 12:31:25 +0100
In-Reply-To: <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114536_599448_FF2C1C5E) <1414408856.3836.3.camel@jlt4.sipsolutions.net>
	 <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 13:29 +0200, Jukka Rissanen wrote:

> Yes, but from generic nl80211 event you cannot know if event is from
> hwsim radio or not. With this patch, the listener can know that the
> radio new/del event is specifically related to hwsim radio.

That's not particularly hard to figure out, for example by looking at
sysfs.

Is this really so time-constrained/important/... that you can't do that?

johannes

