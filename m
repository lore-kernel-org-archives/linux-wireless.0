Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47608 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbaEHKVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 06:21:50 -0400
Message-ID: <1399543296.9163.2.camel@jlt4.sipsolutions.net> (sfid-20140508_122153_546713_35B320A5)
Subject: Re: [PATCH] mac80211: fix sparse warning caused by
 __ieee80211_channel_switch()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 May 2014 12:01:36 +0200
In-Reply-To: <1399482312-20151-1-git-send-email-luca@coelho.fi>
References: <1399482312-20151-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 20:05 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> Commit 59af6928 (mac80211: fix CSA tx queue stopping) introduced a
> sparse warning:
> 
> net/mac80211/cfg.c:3274:5: warning: symbol '__ieee80211_channel_switch' was not declared. Should it be static?
> 
> Fix it by declaring the function static.

Applied, thanks.

johannes

