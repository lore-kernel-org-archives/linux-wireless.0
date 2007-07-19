Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4633 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763373AbXGSTdZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 15:33:25 -0400
Date: Thu, 19 Jul 2007 15:16:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: jbenc@suse.cz, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net
Subject: Re: [PATCH v2 2/2] mac80211: implement ERP info change notifications
Message-ID: <20070719191633.GE6603@tuxdriver.com>
References: <20070715140822.C9DC07B409F@zog.reactivated.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070715140822.C9DC07B409F@zog.reactivated.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 15, 2007 at 03:08:22PM +0100, Daniel Drake wrote:
> zd1211rw and bcm43xx are interested in being notified when ERP IE conditions
> change, so that they can reprogram a register which affects how control frames
> are transmitted.
> 
> This patch adds an interface similar to the one that can be found in softmac.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

Jiri, Michael -- just like the other, this applies to upstream w/
just some offsets if you ignore the driver bits that aren't upstream.
Let me know if you are happy w/ this patch.

John
-- 
John W. Linville
linville@tuxdriver.com
