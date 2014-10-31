Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:35488 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaJaPuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 11:50:52 -0400
Message-ID: <5453AFDB.4050106@candelatech.com> (sfid-20141031_165056_081931_35CD7CC5)
Date: Fri, 31 Oct 2014 08:50:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] mac80211-hwsim:  add frequency attribute to netlink pkts
References: <1414447486-10385-1-git-send-email-greearb@candelatech.com> <1414742568.2918.11.camel@jrissane-mobl.ger.corp.intel.com>
In-Reply-To: <1414742568.2918.11.camel@jrissane-mobl.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/31/2014 01:02 AM, Jukka Rissanen wrote:
> Hi Ben & Johannes,
> 
> while rebasing my hwsim patches on top of Ben's patches, I noticed that
> the freq attribute is not mentioned in hwsim_genl_policy struct. The
> same applies also to radio name and vif attributes. Just wondered should
> they be mentioned in the policy struct like the other attributes?

Thanks for fixing that!

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

