Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31368 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbXHXIF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2007 04:05:27 -0400
Subject: Re: [RFC 09/11] mac80211, iwlwifi: remove atheros turbo modes
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070823164524.799041000@sipsolutions.net>
References: <20070823164500.998912000@sipsolutions.net>
	 <20070823164524.799041000@sipsolutions.net>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 16:00:29 +0800
Message-Id: <1187942429.13078.104.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-08-23 at 18:45 +0200, Johannes Berg wrote:
> This patch removes all mention of the atheros turbo modes that
> can't possibly work properly anyway since in some places we don't
> check for them when we should.
> 
> I have no idea what the iwlwifi drivers were doing with these but
> it can't possibly have been correct.
> 
> Cc: Zhu Yi <yi.zhu@intel.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

ACK. iwlwifi doesn't support turbo mode. The code was there for
completeness. I agree with the removal.

Thanks,
-yi
