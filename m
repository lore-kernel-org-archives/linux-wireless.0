Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:39619 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333AbZHGS1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 14:27:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Fix hardware key index handling
Date: Fri, 7 Aug 2009 20:27:09 +0200
Cc: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de,
	gregor kowski <gregor.kowski@gmail.com>
References: <200908061036.50631.mb@bu3sch.de> <20090807143726.GB7545@tuxdriver.com>
In-Reply-To: <20090807143726.GB7545@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908072027.09771.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 07 August 2009 16:37:26 John W. Linville wrote:
> On Thu, Aug 06, 2009 at 10:36:50AM +0200, Michael Buesch wrote:
> > This fixes the hardware encryption keys index and array size handling.
> > 
> > Thanks to Gregor Kowski for reporting this issue.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> > 
> > ---
> > 
> > This should probably go as a bugfix.
> > (Does this actually fix the PHY transmission errors? I don't see them anymore...
> > Note that you need to enable debugging to see them.)
> 
> It's getting a bit late in the cycle, especially for a patch so large
> and (at least to me) non-obvious.  What is the actual bug being fixed?
> What is the effect of leaving it for 2.6.32?

AP mode might break under certain conditions (lots of STAs connected).
Please leave it for .32

-- 
Greetings, Michael.
