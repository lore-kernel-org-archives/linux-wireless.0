Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49823 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab1EEOnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 10:43:43 -0400
Message-ID: <4DC2B78E.3000205@candelatech.com> (sfid-20110505_164346_564380_AD763896)
Date: Thu, 05 May 2011 07:43:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: [PATCH 3/3] cfg80211/nl80211: add interval attribute for scheduled
 scans
References: <1304600420-24227-1-git-send-email-coelho@ti.com> <1304600420-24227-4-git-send-email-coelho@ti.com>
In-Reply-To: <1304600420-24227-4-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2011 06:00 AM, Luciano Coelho wrote:
> Introduce NL80211_ATTR_SCHED_SCAN_INTERVAL as a required attribute for
> NL80211_CMD_START_SCHED_SCAN.  This value informs the driver at which
> intervals the scheduled scan cycles should be executed.

Please default to something useful instead of requiring
this so that things are backwards compatible.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
