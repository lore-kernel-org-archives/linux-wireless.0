Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56050 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab0KYRAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 12:00:43 -0500
Message-ID: <4CEE962C.8060203@candelatech.com>
Date: Thu, 25 Nov 2010 09:00:28 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 1/2] nl80211/cfg80211: extend mgmt-tx API for off-channel
References: <20101125090228.087298683@sipsolutions.net> <20101125090254.456149961@sipsolutions.net>
In-Reply-To: <20101125090254.456149961@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What are the units for DURATION?  It seems the code is treating
that as jiffies, but surely user-space should specify in msecs
or similar and have the kernel do the conversion?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
