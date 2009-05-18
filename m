Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:36973 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZERSVP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 14:21:15 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] b43/legacy: fix beacon change processing
Date: Mon, 18 May 2009 20:19:55 +0200
Cc: Matthieu CASTET <castet.matthieu@free.fr>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <loom.20090511T202208-851@post.gmane.org> <1242636798.8425.2.camel@johannes.local>
In-Reply-To: <1242636798.8425.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905182019.56184.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 18 May 2009 10:53:18 Johannes Berg wrote:
> Process beacon change even if the BSSID doesn't
> change at the same time. Also fix what I think

ACK.

> is a small locking error in b43legacy, there's
> a spin_unlock_irqrestore that looks out of place.

Yeah, I think a patch was already submitted by larry.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>


-- 
Greetings, Michael.
