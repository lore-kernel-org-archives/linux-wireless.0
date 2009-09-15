Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45274 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbZIOJtX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 05:49:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43: Don't abuse wl->current_dev in the led work
Date: Tue, 15 Sep 2009 11:49:19 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <200909142322.09152.mb@bu3sch.de> <4AAECA8A.1060200@lwfinger.net>
In-Reply-To: <4AAECA8A.1060200@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909151149.22565.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 15 September 2009 00:58:18 Larry Finger wrote:
> Michael Buesch wrote:
> > Don't abuse wl->current_dev in the LED work for checking whether we're
> > going down. Add an explicit variable.
> > This fixes a crash on rmmod dereferencing the wl->current_dev NULL pointer
> > in various other places of the driver.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> This patch does not apply. What other patches should I have beyond the
> current state of wireless-testing?

All patches that are currently queued up.


-- 
Greetings, Michael.
