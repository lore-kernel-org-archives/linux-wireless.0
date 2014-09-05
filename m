Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44100 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751817AbaIEI5F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Sep 2014 04:57:05 -0400
Message-ID: <1409907423.1940.4.camel@jlt4.sipsolutions.net> (sfid-20140905_105710_682864_7C2FA2F1)
Subject: Re: [PATCH] mac80211: clean up ieee80211_i.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 05 Sep 2014 10:57:03 +0200
In-Reply-To: <1409854711-2836-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409853877-12312-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1409854711-2836-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-04 at 21:18 +0300, Emmanuel Grumbach wrote:
> Not sure how the declaration of ieee80211_tdls_peer_del_work
> landed after the double inclusion protection end.

Applied, thanks.

johannes

