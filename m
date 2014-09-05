Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44867 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071AbaIELmF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 07:42:05 -0400
Message-ID: <1409917321.1940.15.camel@jlt4.sipsolutions.net> (sfid-20140905_134210_354467_131E8630)
Subject: Re: [PATCH 08/10] mac80211: use bss_conf->dtim_period instead of
 conf.ps_dtim_period
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 05 Sep 2014 13:42:01 +0200
In-Reply-To: <1409747106-30717-9-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1409747106-30717-9-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-03 at 15:25 +0300, Emmanuel Grumbach wrote:
> sta_set_sinfo is obviously takes data for specific station.
> This specific station is attached to a specific virtual
> interface. Hence we should use the dtim_period from this
> virtual interface rather than the system wide dtim_period.

I'll apply this to mac80211.git

johannes

