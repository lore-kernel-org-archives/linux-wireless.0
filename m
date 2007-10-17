Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2202 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbXJQCIy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 22:08:54 -0400
Date: Tue, 16 Oct 2007 21:03:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] ssb: Fix regression in 2.6.23-git3 due to change in
	calling add_uevent_var
Message-ID: <20071017010338.GA3441@tuxdriver.com> (sfid-20071017_030859_743439_024495A7)
References: <47119f37.hwmEVx/qSP6GAYhm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47119f37.hwmEVx/qSP6GAYhm%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 13, 2007 at 11:46:47PM -0500, Larry Finger wrote:
> In commit 7eff2e7a8b65c25920207324e56611150eb1cd9a, the calling sequence
> for add_uevent_var was changed, but the ssb driver was not modified, which
> leads to a "Unable to handle kernel paging request" oops. This patch fixes
> the problem.

Sorry, Al Viro got a patch merged before I got to yours!

Thanks anyway!

John
-- 
John W. Linville
linville@tuxdriver.com
