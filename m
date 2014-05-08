Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47607 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459AbaEHKVs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2014 06:21:48 -0400
Message-ID: <1399543199.9163.1.camel@jlt4.sipsolutions.net> (sfid-20140508_122151_967287_3CAF5129)
Subject: Re: [PATCH] cfg80211: fix docbook warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, standby24x7@gmail.com
Date: Thu, 08 May 2014 11:59:59 +0200
In-Reply-To: <1399478825-18141-1-git-send-email-luca@coelho.fi>
References: <1399478825-18141-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-07 at 19:07 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> When trying to generate documentation, at least xmldocs, we get the
> following warning:
> 
> Warning(include/net/cfg80211.h:461): No description found for parameter 'nl80211_iftype'
> 
> Fix it by adding the iftype argument name to the
> cfg80211_chandef_dfs_required() function declaration.

Applied, thanks.

johannes

