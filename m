Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab2IFN47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 09:56:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1T9cZl-0006jS-Nq
	for linux-wireless@vger.kernel.org; Thu, 06 Sep 2012 15:56:57 +0200
Message-ID: <1346939855.5469.11.camel@jlt4.sipsolutions.net> (sfid-20120906_155702_782463_D44D0DBF)
Subject: Re: [PATCH] mac80211: don't hang on to sched_scan_ies
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 06 Sep 2012 15:57:35 +0200
In-Reply-To: <1346784169-2929-1-git-send-email-johannes@sipsolutions.net> (sfid-20120904_204223_738128_C3F5DE70)
References: <1346784169-2929-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120904_204223_738128_C3F5DE70)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 20:42 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no need to keep a copy of the scheduled
> scan IEs after the driver has been told, if it
> requires a copy it must make one. Therefore, we
> can move sched_scan_ies into the function.

Applied. I had to pull mac80211.git into mac80211-next.git to preempt a
conflict here.

johannes

