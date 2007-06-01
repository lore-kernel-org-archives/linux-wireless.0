Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3302 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXFASyT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2007 14:54:19 -0400
Date: Fri, 1 Jun 2007 14:18:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "John H." <mistamaila@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: Upgrade to f7 breaks bcm43xx module
Message-ID: <20070601181838.GB5663@tuxdriver.com>
References: <5b9417770706011111u20f32192s960961dc8693f00e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5b9417770706011111u20f32192s960961dc8693f00e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 01, 2007 at 01:11:51PM -0500, John H. wrote:
> bcm43xx mac80211:
> YOUR FIRMWARE IS TOO OLD. Firmware from binary drivers older than
> version 4.x is unsupported. You must upgrade your firmware files.
> 
> I get that now with f7 and 2.6.21 and didn't with fc6 2.6.20.
> 
> However, I read that the error is not what it sounds like.  What is
> the solution?

You might start by posting on a Fedora list, lest ye draw the ire of
any other distro users on this list... :-)

In the meantime, I suggest you extract firmware[1] from the wl_apsta.o
file in this archive:

	http://downloads.openwrt.org/sources/broadcom-wl-4.80.53.0.tar.bz2

Hth!

John

[1] Using bcm43xx-fwcutter, of course.
-- 
John W. Linville
linville@tuxdriver.com
