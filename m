Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51672
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751093AbXJREQe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Oct 2007 00:16:34 -0400
Date: Wed, 17 Oct 2007 21:16:32 -0700 (PDT)
Message-Id: <20071017.211632.40832065.davem@davemloft.net> (sfid-20071018_051638_872167_D50743A4)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: only honor IW_SCAN_THIS_ESSID in STA, IBSS,
 and AP modes
From: David Miller <davem@davemloft.net>
In-Reply-To: <11926328942540-git-send-email-linville@tuxdriver.com>
References: <200710162329.55966.flamingice@sourmilk.net>
	<20071017145315.GC5744@tuxdriver.com>
	<11926328942540-git-send-email-linville@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 17 Oct 2007 10:54:54 -0400

> The previous IW_SCAN_THIS_ESSID patch left a hole allowing scan
> requests on interfaces in inappropriate modes.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

John I've pulled from your tree and added this patch on top.

Thanks!
