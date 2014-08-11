Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56411 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbaHKPFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 11:05:40 -0400
Message-ID: <1407769535.9844.9.camel@jlt4.sipsolutions.net> (sfid-20140811_170543_188052_A64A022B)
Subject: Re: [PATCH] cfg80211: re-enable CSA for drivers that support it
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Aug 2014 17:05:35 +0200
In-Reply-To: <1406553665-16355-1-git-send-email-michal.kazior@tieto.com> (sfid-20140728_153026_085838_915C33C7)
References: <1406553665-16355-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140728_153026_085838_915C33C7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-07-28 at 15:21 +0200, Michal Kazior wrote:
> This reverts commit dda444d52496aa8ddc501561bca580f1374a96a9.
> 
> Channel switching code has been reworked and
> improved significantly since the time original
> locking issues were found.

Applied.

johannes

