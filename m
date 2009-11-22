Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47740 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316AbZKVRwS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 12:52:18 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
Date: Sun, 22 Nov 2009 18:52:17 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Lorenzo Nava <navalorenx@gmail.com>
References: <200911192224.29491.mb@bu3sch.de>
In-Reply-To: <200911192224.29491.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200911221852.19143.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 November 2009 22:24:29 Michael Buesch wrote:
> This rewrites the error handling policies in the TX status handler.
> It tries to be error-tolerant as in "try hard to not crash the machine".
> It won't recover from errors (that are bugs in the firmware or driver),
> because that's impossible. However, it will return a more or less useful
> error message and bail out. It also tries hard to use rate-limited messages
> to not flood the syslog in case of a failure.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

So did somebody try this with opensource firmware, yet?

-- 
Greetings, Michael.
