Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38329 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700Ab0IWVS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 17:18:28 -0400
Message-ID: <4C9BC41E.70804@candelatech.com>
Date: Thu, 23 Sep 2010 14:18:22 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v2 1/3] mac80211: remove prepare_for_handlers sdata argument
References: <20100923193747.677517441@sipsolutions.net> <20100923193818.656678519@sipsolutions.net>
In-Reply-To: <20100923193818.656678519@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I applied these 3 patches and using two STA interfaces on ath9k
appears to work fine.  I'll leave them in my tree and continue
testing.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

