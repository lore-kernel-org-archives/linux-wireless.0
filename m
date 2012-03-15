Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56461 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031532Ab2COSji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:39:38 -0400
Subject: Re: compiler warning in wireless-testing.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4F6236D0.40505@candelatech.com> (sfid-20120315_193710_650107_511DE533)
References: <4F6236D0.40505@candelatech.com>
	 (sfid-20120315_193710_650107_511DE533)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 19:39:37 +0100
Message-ID: <1331836777.3432.31.camel@jlt3.sipsolutions.net> (sfid-20120315_193941_542665_3088228D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-15 at 11:37 -0700, Ben Greear wrote:
> Looks like this is the compiler's fault to me..but might be
> worth explicitly initializing the sta variable just to make
> it quiet.

I disagree, doing that will only hide legitimate warnings if somebody
changes the code. Initializing for compiler happiness is almost always
the worst thing you can do.

johannes

