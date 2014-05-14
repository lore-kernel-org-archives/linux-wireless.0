Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42676 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbaENOmz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 10:42:55 -0400
Message-ID: <1400078561.4759.12.camel@jlt4.sipsolutions.net> (sfid-20140514_164258_754039_EC8D5C6D)
Subject: Re: [PATCH] cfg80211: fix start_radar_detection issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@intel.com
Date: Wed, 14 May 2014 16:42:41 +0200
In-Reply-To: <1400066704-7286-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140514_132528_512073_C7EE5921)
References: <1400066704-7286-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140514_132528_512073_C7EE5921)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-14 at 13:25 +0200, Janusz Dziedzic wrote:
> After patch:
> cfg80211/mac80211: refactor cfg80211_chandef_dfs_required()
> 
> start_radar_detection always fail with -EINVAL.

Applied, thanks.

johannes

