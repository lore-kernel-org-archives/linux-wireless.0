Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46524 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbaEOMvW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 08:51:22 -0400
Message-ID: <1400158267.4146.2.camel@jlt4.sipsolutions.net> (sfid-20140515_145126_064959_7B1EBC98)
Subject: Re: [PATCH] cfg80211: pass the actual iftype when calling
 cfg80211_chandef_dfs_required()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, eliad@wizery.com,
	janusz.dziedzic@tieto.com
Date: Thu, 15 May 2014 14:51:07 +0200
In-Reply-To: <1400148339-10006-1-git-send-email-luca@coelho.fi>
References: <1400148339-10006-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-05-15 at 13:05 +0300, Luca Coelho wrote:
> From: Luciano Coelho <luciano.coelho@intel.com>
> 
> There is no need to pass NL80211_IFTYPE_UNSPECIFIED when calling
> cfg80211_chandef_dfs_required() since we always already have the
> interface type.  So, pass the actual interface type instead.
> 
> Additionally, have cfg80211_chandef_dfs_required() WARN if the passed
> interface type is NL80211_IFTYPE_UNSPECIFIED, so we can detect
> problems more easily.

Applied, thanks.

johannes

