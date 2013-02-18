Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42619 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942Ab3BRMsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 07:48:01 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U7Q8W-0003Iy-0q
	for linux-wireless@vger.kernel.org; Mon, 18 Feb 2013 13:48:00 +0100
Message-ID: <1361191677.8555.11.camel@jlt4.sipsolutions.net> (sfid-20130218_134810_774768_A6DB3C29)
Subject: Re: [PATCH] mac80211: fix harmless station flush warning
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 18 Feb 2013 13:47:57 +0100
In-Reply-To: <1360925396-18355-1-git-send-email-johannes@sipsolutions.net> (sfid-20130215_115014_486099_278D969B)
References: <1360925396-18355-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130215_115014_486099_278D969B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 11:49 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If an interface is set down while authenticating or
> associating, there's a station entry that will be
> removed by the flushing in do_stop() and that will
> cause a warning. It's otherwise harmless, but avoid
> the warning by calling ieee80211_mgd_stop() first.

Applied.

johannes

