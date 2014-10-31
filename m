Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50279 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750710AbaJaHjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 03:39:03 -0400
Message-ID: <1414741139.3014.1.camel@jlt4.sipsolutions.net> (sfid-20141031_083945_977368_7DF57116)
Subject: Re: [PATCH v2 0/2] Add mcast event when hwsim radios are created
 and removed
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 31 Oct 2014 08:38:59 +0100
In-Reply-To: <1414683266-28427-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141030_163615_143606_638F9ADD)
References: <1414683266-28427-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141030_163615_143606_638F9ADD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jukka,

Unfortunately this failed to apply, likely because I also applied some
of Ben's patches in the meantime. Please rebase your patch on
mac80211-next.

johannes

