Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51534 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaJ0MIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 08:08:38 -0400
Message-ID: <1414411714.3836.7.camel@jlt4.sipsolutions.net> (sfid-20141027_130842_012569_0DDF4FD9)
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and
 removed
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Oct 2014 13:08:34 +0100
In-Reply-To: <1414410917.2705.201.camel@jrissane-mobl.ger.corp.intel.com>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114536_599448_FF2C1C5E) <1414408856.3836.3.camel@jlt4.sipsolutions.net>
	 <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com>
	 <1414409485.3836.5.camel@jlt4.sipsolutions.net>
	 <1414410917.2705.201.camel@jrissane-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 13:55 +0200, Jukka Rissanen wrote:

> > That's not particularly hard to figure out, for example by looking at
> > sysfs.
> > 
> > Is this really so time-constrained/important/... that you can't do that?
> 
> It does not seem very practical to dig this information from sysfs as
> the same information can be easily get via netlink as this patch shows.

Well, that's a slippery slope. I'd consider it more practical to use
existing APIs instead of (gratuitously) inventing new ones. It'll even
work on older kernels as an added benefit.

johannes

