Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38253
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755229AbXD0DvN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 23:51:13 -0400
Date: Thu, 26 Apr 2007 20:51:21 -0700 (PDT)
Message-Id: <20070426.205121.16515101.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] clarify locking comment in cfg80211
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070427015055.GF25332@tuxdriver.com>
References: <20070427015055.GF25332@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 26 Apr 2007 21:50:55 -0400

> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This patch clarifies the comment about locking in wiphy_unregister.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Also applied, thanks.
