Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2116 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161456AbXDLBph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 21:45:37 -0400
Date: Wed, 11 Apr 2007 21:20:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcm43xx: Hide if bcm43xx-mac80211 is builtin
Message-ID: <20070412012051.GC3473@tuxdriver.com>
References: <200704111901.06403.flamingice@sourmilk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200704111901.06403.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2007 at 07:01:06PM -0400, Michael Wu wrote:
> bcm43xx: Hide if bcm43xx-mac80211 is builtin
> 
> From: Michael Wu <flamingice@sourmilk.net>
> 
> This prevents users from compiling bcm43xx (softmac) and bcm43xx-mac80211
> into the kernel at the same time. In the case that it is attempted, make
> bcm43xx (softmac) not build.

Since the two drivers use different firmware and the (currently)
softmac-based driver will evolve into bcm4301 with support for older
hardware, I'd prefer to leave this one out.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
