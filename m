Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:6202 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752500AbXJJMcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 08:32:23 -0400
From: bruno randolf <bruno@thinktube.com>
To: Markus Feldmann <feldmann_markus@gmx.de>
Subject: Re: Patch for Kernel and Ath5k
Date: Wed, 10 Oct 2007 21:32:21 +0900
Cc: linux-wireless@vger.kernel.org
References: <feieb9$nvg$1@sea.gmane.org> <200710102059.04990.bruno@thinktube.com> <feifnq$qf4$2@sea.gmane.org>
In-Reply-To: <feifnq$qf4$2@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200710102132.21790.bruno@thinktube.com> (sfid-20071010_133242_444951_E4218CAD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 10 October 2007 21:14:51 Markus Feldmann wrote:
> Have i to change the dir to /usr/src/linux before i do this above?

nope. just check it out into any directory - this will fetch the current 
2.6.23-rc9 with the latest wireless developments.

> After this steps above do i have to activate the ath5k in the "make
> menuconfig"?

sure. and don't expect too much ;) - the driver is under heavy development and 
pretty new.

bruno
