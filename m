Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757827Ab3D2OYa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Apr 2013 10:24:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1UWp0H-0007FN-Hj
	for linux-wireless@vger.kernel.org; Mon, 29 Apr 2013 16:24:29 +0200
Message-ID: <1367245467.8289.5.camel@jlt4.sipsolutions.net> (sfid-20130429_162433_615895_6BF8B821)
Subject: Re: [PATCH] cfg80211: fix WoWLAN wakeup tracing
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 29 Apr 2013 16:24:27 +0200
In-Reply-To: <1367230223-16740-1-git-send-email-johannes@sipsolutions.net> (sfid-20130429_121039_695193_E0DA9A6F)
References: <1367230223-16740-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130429_121039_695193_E0DA9A6F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-29 at 12:10 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> If the device reports a non-wireless wakeup reason, the
> tracing code crashes trying to dereference a NULL pointer.
> Fix this by checking the pointer on all accesses and also
> add a non_wireless tag to the event.

tested & applied.

johannes

