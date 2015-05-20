Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37166 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655AbbETNAe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:00:34 -0400
Message-ID: <1432126831.19214.8.camel@sipsolutions.net> (sfid-20150520_150036_465824_0313F703)
Subject: Re: [PATCH] cfg80211: Switch to PM ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:00:31 +0200
In-Reply-To: <1431779754-12106-1-git-send-email-lars@metafoo.de>
References: <1431779754-12106-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-05-16 at 14:35 +0200, Lars-Peter Clausen wrote:
> Use dev_pm_ops instead of the legacy suspend/resume callbacks for the wiphy
> class suspend and resume operations.

Also applied.

johannes

