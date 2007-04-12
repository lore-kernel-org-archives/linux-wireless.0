Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3376 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920AbXDMAP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 20:15:29 -0400
Date: Thu, 12 Apr 2007 19:56:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: Hide if bcm43xx-mac80211 is builtin
Message-ID: <20070412235621.GB3470@tuxdriver.com>
References: <200704111901.06403.flamingice@sourmilk.net> <20070412012051.GC3473@tuxdriver.com> <200704112155.14204.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200704112155.14204.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2007 at 09:55:08PM -0400, Michael Wu wrote:
> On Wednesday 11 April 2007 21:20, John W. Linville wrote:
> > Since the two drivers use different firmware and the (currently)
> > softmac-based driver will evolve into bcm4301 with support for older
> > hardware, I'd prefer to leave this one out.
> >
> This is just to make allyesconfig work. (wasn't Andrew Morton telling you to 
> do this?) Both drivers can still be compiled as modules.

OK, I see that now.  FWIW, the namespace changes of the old bcm43xx
driver to bcm4301 would fulfill the same goal.  But I suppose this
patch is fine for the time being.

John
-- 
John W. Linville
linville@tuxdriver.com
