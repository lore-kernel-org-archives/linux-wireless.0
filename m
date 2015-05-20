Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37164 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbETNA2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:00:28 -0400
Message-ID: <1432126823.19214.7.camel@sipsolutions.net> (sfid-20150520_150031_842629_7583F6D4)
Subject: Re: [PATCH] net: rfkill: Switch to PM ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:00:23 +0200
In-Reply-To: <1431779035-5256-1-git-send-email-lars@metafoo.de>
References: <1431779035-5256-1-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-05-16 at 14:23 +0200, Lars-Peter Clausen wrote:
> Use dev_pm_ops instead of the legacy suspend/resume callbacks for the
> rfkill class suspend and resume operations.

Applied.

johannes

