Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:53723 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2GIHbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 03:31:55 -0400
Date: Mon, 09 Jul 2012 00:31:55 -0700 (PDT)
Message-Id: <20120709.003155.284089706826738623.davem@davemloft.net> (sfid-20120709_093220_020494_A6A78005)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2012-07-06
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120706192034.GA1879@tuxdriver.com>
References: <20120706192034.GA1879@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 6 Jul 2012 15:20:35 -0400

> Please let me know if there are problems!

This indentation is not correct:

commit 01f9cb073c827c60c43f769763b49a2026f1a897
Author: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Date:   Thu Jun 28 14:39:51 2012 -0700

    mwl8k: fix possible race condition in info->control.sta use
 ...
+			sta = ieee80211_find_sta_by_ifaddr(hw, wh->addr1,
+								wh->addr2);
