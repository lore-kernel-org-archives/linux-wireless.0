Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange.solarflare.com ([216.237.3.220]:52147 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965404Ab2CPU41 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 16:56:27 -0400
Message-ID: <1331931383.2504.11.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20120316_215650_103982_BFB7BB47)
Subject: Re: [PATCH v2 2/4] mac80211:  Support getting sta_info stats via
 ethtool.
From: Ben Hutchings <bhutchings@solarflare.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Date: Fri, 16 Mar 2012 20:56:23 +0000
In-Reply-To: <1331927952-8706-2-git-send-email-greearb@candelatech.com>
References: <1331927952-8706-1-git-send-email-greearb@candelatech.com>
	 <1331927952-8706-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 12:59 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This lets ethtool print out stats related to station
> interfaces.  Does not yet get stats from the underlying
> driver.
[...]

Nice.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

