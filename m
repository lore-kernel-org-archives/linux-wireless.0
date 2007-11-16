Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:46599
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763586AbXKPVyR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 16:54:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ssb: Fix compilation errors in ssb
Date: Fri, 16 Nov 2007 22:53:03 +0100
Cc: Larry Finger <larry.finger@lwfinger.net>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <473d3d37.IWXGkSribrkSiHBl%Larry.Finger@lwfinger.net> <473DA777.2090203@lwfinger.net> <20071116145632.GA25828@tuxdriver.com>
In-Reply-To: <20071116145632.GA25828@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711162253.03566.mb@bu3sch.de> (sfid-20071116_215430_501435_016079DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 16 November 2007 15:56:32 John W. Linville wrote:
> On Fri, Nov 16, 2007 at 08:21:43AM -0600, Larry Finger wrote:
> > Michael Buesch wrote:
> > > On Friday 16 November 2007 07:48:23 Larry Finger wrote:
> > >> Recent changes in ssb sprom handling break compilation. These two patches
> > >> fix the problem.
> 
> > > are your sprom r4 changes already applied? I didn't test that in the b44, yet.
> > 
> > I did a git pull yesterday and the sprom r3 and r4 changes were in wireless-2.6/everything.
> 
> And now, so is this one.  I'll probably roll it into the main ssb
> sprom patch before actually sending it to Jeff.

Ok, cool.

-- 
Greetings Michael.
