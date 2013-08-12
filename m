Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:50902 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab3HLMHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Aug 2013 08:07:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1V8quX-0008Sd-2w
	for linux-wireless@vger.kernel.org; Mon, 12 Aug 2013 14:07:45 +0200
Message-ID: <1376309262.11514.16.camel@jlt4.sipsolutions.net> (sfid-20130812_140748_225023_21C19175)
Subject: Re: [PATCH] nl80211: clean up CQM settings code
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 12 Aug 2013 14:07:42 +0200
In-Reply-To: <1375791102-5505-1-git-send-email-johannes@sipsolutions.net> (sfid-20130806_141152_987236_ABFBBC5B)
References: <1375791102-5505-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130806_141152_987236_ABFBBC5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-06 at 14:11 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Clean up the CQM settings code a bit and while at it
> enforce that when setting the threshold to 0 (disable)
> the hysteresis is also set to 0 to avoid confusion.
> As we haven't enforce it, simply override userspace.

Applied.

johannes

