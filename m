Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37909
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557Ab0BZFfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 00:35:53 -0500
Date: Thu, 25 Feb 2010 21:36:11 -0800 (PST)
Message-Id: <20100225.213611.263531055.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-kernel@vger-kernel.org, linux-wireless@vger.kernel.org,
	stable@kernel.org
Subject: Re: [PATCH] netdevice.h: check for CONFIG_WLAN instead of
 CONFIG_WLAN_80211
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267116589-12199-1-git-send-email-linville@tuxdriver.com>
References: <20100225150423.GA5101@faui49.informatik.uni-erlangen.de>
	<1267116589-12199-1-git-send-email-linville@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 25 Feb 2010 11:49:49 -0500

> In "wireless: remove WLAN_80211 and WLAN_PRE80211 from Kconfig" I
> inadvertantly missed a line in include/linux/netdevice.h.  I thereby
> effectively reverted "net: Set LL_MAX_HEADER properly for wireless." by
> accident. :-(  Now we should check there for CONFIG_WLAN instead.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> Reported-by: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
> Cc: stable@kernel.org
> ---
> Unless there is objection, I'll push this up through my tree as normal.

Definitely no objections :-)
