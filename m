Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55879 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaIKKCc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:02:32 -0400
Message-ID: <1410429749.1825.6.camel@jlt4.sipsolutions.net> (sfid-20140911_120236_051306_2E5E5856)
Subject: Re: [PATCH 1/4] cfg80211: clear connect keys when freeing them
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Sep 2014 12:02:29 +0200
In-Reply-To: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410345597-28565-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-10 at 13:39 +0300, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When freeing the connect keys, clear the memory to avoid
> having the key material stick around in memory "forever".

Applied, except for patch 4 which is actually pointless.

johannes

