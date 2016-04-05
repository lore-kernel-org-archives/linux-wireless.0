Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53741 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756182AbcDEKNP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2016 06:13:15 -0400
Message-ID: <1459851192.18188.43.camel@sipsolutions.net> (sfid-20160405_121318_859022_59D3A807)
Subject: Re: [PATCH 4/4] mac80211: fix cipher scheme function name
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 05 Apr 2016 12:13:12 +0200
In-Reply-To: <1458219775-24450-4-git-send-email-emmanuel.grumbach@intel.com>
References: <1458219775-24450-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1458219775-24450-4-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-17 at 15:02 +0200, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The code is only used with iwlwifi, but still should have proper
> mac80211 naming scheme; fix that.
> 
All 4 applied.

johannes
