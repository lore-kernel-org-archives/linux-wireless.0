Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58527
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754013AbYGOJJX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 05:09:23 -0400
Date: Tue, 15 Jul 2008 02:09:23 -0700 (PDT)
Message-Id: <20080715.020923.213382355.davem@davemloft.net> (sfid-20080715_110929_601774_EBD247E3)
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] wireless: fix warnings from QoS patch
From: David Miller <davem@davemloft.net>
In-Reply-To: <1216109364.23746.17.camel@johannes.berg>
References: <20080714.204532.116542087.davem@davemloft.net>
	<1216107805.23746.14.camel@johannes.berg>
	<1216109364.23746.17.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 15 Jul 2008 10:09:24 +0200

> When I removed the special "default" meaning from the QoS
> parameters, I forgot to update drivers and this lead to
> warnings because some drivers were checking for the special
> values and putting in defaults. This fixes that by removing
> the default special-casing completely.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Applied, thanks for fixing this so fast Johannes.
