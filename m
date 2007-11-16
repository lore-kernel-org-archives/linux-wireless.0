Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2800 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbXKPO4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 09:56:55 -0500
Date: Fri, 16 Nov 2007 09:56:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ssb: Fix compilation errors in ssb
Message-ID: <20071116145632.GA25828@tuxdriver.com> (sfid-20071116_145657_243779_05D37292)
References: <473d3d37.IWXGkSribrkSiHBl%Larry.Finger@lwfinger.net> <200711161130.46770.mb@bu3sch.de> <473DA777.2090203@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <473DA777.2090203@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 16, 2007 at 08:21:43AM -0600, Larry Finger wrote:
> Michael Buesch wrote:
> > On Friday 16 November 2007 07:48:23 Larry Finger wrote:
> >> Recent changes in ssb sprom handling break compilation. These two patches
> >> fix the problem.

> > are your sprom r4 changes already applied? I didn't test that in the b44, yet.
> 
> I did a git pull yesterday and the sprom r3 and r4 changes were in wireless-2.6/everything.

And now, so is this one.  I'll probably roll it into the main ssb
sprom patch before actually sending it to Jeff.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
