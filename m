Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55891 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153AbaIKKHA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 06:07:00 -0400
Message-ID: <1410430017.1825.7.camel@jlt4.sipsolutions.net> (sfid-20140911_120703_062528_2DF19C53)
Subject: Re: [PATCH] cfg80211: clear nl80211 messages carrying keys after
 processing
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Sep 2014 12:06:57 +0200
In-Reply-To: <1410350416-16339-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1410350416-16339-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-09-10 at 15:00 +0300, Emmanuel Grumbach wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Clear any nl80211 messages that might contain keys after
> processing them to avoid leaving their data in memory
> "forever" after they've been freed.

Applied.

johannes

