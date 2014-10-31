Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:39961 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbaJaIQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 04:16:57 -0400
Message-ID: <1414743414.2918.12.camel@jrissane-mobl.ger.corp.intel.com> (sfid-20141031_091702_066946_52058DF5)
Subject: Re: [PATCH] mac80211-hwsim:  add frequency attribute to netlink pkts
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 31 Oct 2014 10:16:54 +0200
In-Reply-To: <1414742686.3014.15.camel@jlt4.sipsolutions.net>
References: <1414447486-10385-1-git-send-email-greearb@candelatech.com>
	 <1414742568.2918.11.camel@jrissane-mobl.ger.corp.intel.com>
	 <1414742686.3014.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On pe, 2014-10-31 at 09:04 +0100, Johannes Berg wrote:
> On Fri, 2014-10-31 at 10:02 +0200, Jukka Rissanen wrote:
> 
> > while rebasing my hwsim patches on top of Ben's patches, I noticed that
> > the freq attribute is not mentioned in hwsim_genl_policy struct. The
> > same applies also to radio name and vif attributes. Just wondered should
> > they be mentioned in the policy struct like the other attributes?
> 
> Hmm, yes, they should be there. It's only important for the name, I
> guess, but better have them all. I can fix it or would you like to send
> a patch?

Please fix it so it gets applied faster :)


Cheers,
Jukka


