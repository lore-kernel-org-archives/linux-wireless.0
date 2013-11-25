Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38508 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347Ab3KYQR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:17:57 -0500
Message-ID: <1385396275.4443.45.camel@jlt4.sipsolutions.net> (sfid-20131125_171805_109035_67FD4F4D)
Subject: Re: [PATCH v2] iw: Use NL80211_FREQUENCY_ATTR_NO_IR channel
 attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:17:55 +0100
In-Reply-To: <1384413334-31631-1-git-send-email-ilan.peer@intel.com> (sfid-20131114_081506_020123_09410FBA)
References: <1384413334-31631-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20131114_081506_020123_09410FBA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-14 at 09:15 +0200, Ilan Peer wrote:
> Align iw with the change in nl80211.h where NL80211_FREQUENCY_ATTR_NO_IBSS
> and NL80211_FREQUENCY_ATTR_PASSIVE_SCAN were replaced by
> NL80211_FREQUENCY_ATTR_NO_IR.
> 
> In case both NL80211_FREQUENCY_ATTR_NO_IR and __NL80211_FREQUENCY_ATTR_NO_IBSS
> are set, assume that a new kernel is used and use the NO_IR notation,
> otherwise use the previous notation.

Applied, sorry for the delay.

johannes

