Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56383 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567AbaHKPA3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 11:00:29 -0400
Message-ID: <1407769223.9844.2.camel@jlt4.sipsolutions.net> (sfid-20140811_170033_080575_B7D96A7B)
Subject: Re: [PATCH] mac80211: Fix accounting of the tailroom-needed counter
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	Ido Yariv <idox.yariv@intel.com>
Date: Mon, 11 Aug 2014 17:00:23 +0200
In-Reply-To: <1406637533-19393-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1406637533-19393-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-07-29 at 15:38 +0300, Emmanuel Grumbach wrote:
> From: Ido Yariv <ido@wizery.com>
> 
> When hw acceleration is enabled, the GENERATE_IV or PUT_IV_SPACE flags
> will only require headroom space. Consequently, the tailroom-needed
> counter can safely be decremented.

Applied.

johannes

