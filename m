Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:46966 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932294Ab2CFAkZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 19:40:25 -0500
From: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: WARNING: driver-ops.h:10 -- how do I fix this?
Date: Tue, 6 Mar 2012 00:40:25 +0000
Message-ID: <461155E6-5B2C-48C3-AD1C-4D07B6EECE4B@watchguard.com> (sfid-20120306_014028_944755_47BCD942)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


on compat-wireless-2012-02-06 as well as compat-wireless-3.3-rc1-2, I see this:

WARNING: at ath9k/net/mac80211/driver-ops.h:10 ieee80211_bss_info_change_notify+0x150/0x18c [mac80211]()

any time I change from one band to another.  How do I fix this?

--
-bp


