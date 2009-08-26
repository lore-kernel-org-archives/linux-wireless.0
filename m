Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44368 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbZHZVAY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 17:00:24 -0400
Date: Wed, 26 Aug 2009 16:54:03 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Fix and update LP-PHY code
Message-ID: <20090826205403.GA30119@tuxdriver.com>
References: <1251312686-32067-1-git-send-email-netrolller.3d@gmail.com> <1251312686-32067-2-git-send-email-netrolller.3d@gmail.com> <200908262242.50729.mb@bu3sch.de> <69e28c910908261347u375f2f5cu74672b9f4b073738@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910908261347u375f2f5cu74672b9f4b073738@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 10:47:12PM +0200, Gábor Stefanik wrote:
> 2009/8/26 Michael Buesch <mb@bu3sch.de>:
> > And, everything in its own patch, please. I don't see a reason for
> > patching unrelated things in one big patch.
> 
> Well, this patch is already in wireless-testing, so doing that would
> now involve reverting this patch, applying a version without the
> channel change, and applying the channel change - certainly more
> confusing than the status quo.

But it is not in net-next-2.6.  Please submit the patches as Michael
requested and I'll take care of the reorganization.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
