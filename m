Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4814 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbYFJP6s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 11:58:48 -0400
Date: Tue, 10 Jun 2008 11:24:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
Message-ID: <20080610152418.GD13267@tuxdriver.com> (sfid-20080610_175855_193162_040104BC)
References: <20080610105058.GA6961@jm.kir.nu> <1213096575.3668.6.camel@johannes.berg> <20080610123007.GB1571@tuxdriver.com> <1213103469.3668.13.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213103469.3668.13.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 03:11:09PM +0200, Johannes Berg wrote:

> > Jouni this looks great.  Let's get this into the kernel.
> 
> I wonder where to stick it. net/mac80211/virtual-hw.c? Or
> drivers/net/wireless/mac80211-virt.c? Heh. Not that it matters :)

drivers/net/wireless seems appropriate to me.

-- 
John W. Linville
linville@tuxdriver.com
