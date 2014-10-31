Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50405 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbaJaIFE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 04:05:04 -0400
Message-ID: <1414742686.3014.15.camel@jlt4.sipsolutions.net> (sfid-20141031_090511_685195_E07932AA)
Subject: Re: [PATCH] mac80211-hwsim:  add frequency attribute to netlink pkts
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 31 Oct 2014 09:04:46 +0100
In-Reply-To: <1414742568.2918.11.camel@jrissane-mobl.ger.corp.intel.com>
References: <1414447486-10385-1-git-send-email-greearb@candelatech.com>
	 <1414742568.2918.11.camel@jrissane-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-10-31 at 10:02 +0200, Jukka Rissanen wrote:

> while rebasing my hwsim patches on top of Ben's patches, I noticed that
> the freq attribute is not mentioned in hwsim_genl_policy struct. The
> same applies also to radio name and vif attributes. Just wondered should
> they be mentioned in the policy struct like the other attributes?

Hmm, yes, they should be there. It's only important for the name, I
guess, but better have them all. I can fix it or would you like to send
a patch?

johannes

