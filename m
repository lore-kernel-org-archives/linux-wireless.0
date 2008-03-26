Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59510
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750727AbYCZDDY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 23:03:24 -0400
Received: from localhost (localhost [127.0.0.1])
	by sunset.davemloft.net (Postfix) with ESMTP id BE46CC8C304
	for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 20:03:20 -0700 (PDT)
Date: Tue, 25 Mar 2008 20:03:20 -0700 (PDT)
Message-Id: <20080325.200320.156846782.davem@davemloft.net> (sfid-20080326_030327_729100_98939B27)
To: linux-wireless@vger.kernel.org
Subject: warning in current tree...
From: David Miller <davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


The current net-2.6.26 build warns on allmodconfig because:

WARNING: net/wireless/cfg80211: 'ieee80211_get_channel' exported twice. Previous exprort was in net/ieee80211/ieee80211.ko

Please fix this up, thanks!
