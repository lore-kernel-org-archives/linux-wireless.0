Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34181 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342AbcHAMY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 08:24:58 -0400
Message-ID: <1470054294.17912.8.camel@sipsolutions.net> (sfid-20160801_142501_317511_B4F46C80)
Subject: Re: [PATCH] iw: display 5/10 MHz channel widths
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 01 Aug 2016 14:24:54 +0200
In-Reply-To: <20160721153948.32171-1-me@bobcopeland.com> (sfid-20160721_174006_254207_A60A70E7)
References: <20160721153948.32171-1-me@bobcopeland.com>
	 (sfid-20160721_174006_254207_A60A70E7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-07-21 at 11:39 -0400, Bob Copeland wrote:
> iw was showing 'width: unknown' for channels on OCB interfaces; teach
> it the values for 5/10 MHz so it will show the configured width.
> 
Applied, thanks.

johannes
