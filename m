Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38249
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755241AbXD0Duh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2007 23:50:37 -0400
Date: Thu, 26 Apr 2007 20:50:45 -0700 (PDT)
Message-Id: <20070426.205045.122940453.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix locking in wiphy_new
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070427014744.GE25332@tuxdriver.com>
References: <20070427014744.GE25332@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 26 Apr 2007 21:47:44 -0400

> From: Johannes Berg <johannes@sipsolutions.net>
> 
> This patch fixes the locking in wiphy new. Ingo Oeser <netdev@axxeo.de>
> noticed that locking in the error case was wrong and also suggested this
> fix.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Applied.
