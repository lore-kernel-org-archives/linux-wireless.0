Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55985 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbaIKKZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:25:09 -0400
Message-ID: <1410431106.22863.8.camel@jlt4.sipsolutions.net> (sfid-20140911_122519_625119_1BDFBF60)
Subject: Re: [PATCH] cfg80211/mac80211: add wmm info to assoc event
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Thu, 11 Sep 2014 12:25:06 +0200
In-Reply-To: <1410271785-10088-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410271785-10088-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-09-09 at 17:09 +0300, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Userspace might need to know what queues are configured
> for uapsd (e.g. for setting proper default values in tspecs).
> 
> Add this bitmap to the association event (inside wmm
> nested attribute)
> 
> Add additional parameter to cfg80211_rx_assoc_resp,
> and update its callers.

Applied.

johannes

