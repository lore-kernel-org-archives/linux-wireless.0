Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41573 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbZHZVDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 17:03:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Fix and update LP-PHY code
Date: Wed, 26 Aug 2009 23:03:33 +0200
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1251312686-32067-1-git-send-email-netrolller.3d@gmail.com> <69e28c910908261347u375f2f5cu74672b9f4b073738@mail.gmail.com> <20090826205403.GA30119@tuxdriver.com>
In-Reply-To: <20090826205403.GA30119@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908262303.34779.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 August 2009 22:54:03 John W. Linville wrote:
> On Wed, Aug 26, 2009 at 10:47:12PM +0200, Gábor Stefanik wrote:
> > 2009/8/26 Michael Buesch <mb@bu3sch.de>:
> > > And, everything in its own patch, please. I don't see a reason for
> > > patching unrelated things in one big patch.
> > 
> > Well, this patch is already in wireless-testing, so doing that would
> > now involve reverting this patch, applying a version without the
> > channel change, and applying the channel change - certainly more
> > confusing than the status quo.
> 
> But it is not in net-next-2.6.  Please submit the patches as Michael
> requested and I'll take care of the reorganization.

You can leave it as-is. But for the future please make sure to submit
independent things in independent patches so they can be discussed
and merged independently.

-- 
Greetings, Michael.
