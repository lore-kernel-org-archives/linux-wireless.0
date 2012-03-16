Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from exchange.solarflare.com ([216.237.3.220]:52098 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932695Ab2CPUxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 16:53:55 -0400
Message-ID: <1331931232.2504.9.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20120316_215410_346282_1A3155CD)
Subject: Re: [PATCH v2 4/4] ath9k:  Support ethtool getstats api.
From: Ben Hutchings <bhutchings@solarflare.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Date: Fri, 16 Mar 2012 20:53:52 +0000
In-Reply-To: <1331927952-8706-4-git-send-email-greearb@candelatech.com>
References: <1331927952-8706-1-git-send-email-greearb@candelatech.com>
	 <1331927952-8706-4-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 12:59 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This returns many of the values that formerly could
> only be obtained from debugfs.  This should be an
> improvement when trying to access these counters
> programatically.  Currently this support is only
> enabled when DEBUGFS is enabled because otherwise
> these stats are not accumulated.
[...]

Given that ethtool (unlike debugfs) is itself an unconditional feature,
why not make this unconditional?  Is it expensive to accumulate the
stats?

Please at least fix the name.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

