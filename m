Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXHSE7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 00:59:37 -0400
Date: Sun, 19 Aug 2007 00:59:43 -0400
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Yi Zhu <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: ipw2200: sparse warnings
Message-ID: <20070819005943.1b53cc4d@oldman.hemminger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lots of sparse warnings come out of this driver:

drivers/net/wireless/ipw2200.c:833:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:877:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:921:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:966:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:1002:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:1037:6: warning: symbol 'led' shadows an earlier one
drivers/net/wireless/ipw2200.c:93:12: originally declared here
drivers/net/wireless/ipw2200.c:1793:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_x' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:4239:12: warning: symbol '_y' shadows an earlier one
drivers/net/wireless/ipw2200.c:4239:12: originally declared here
drivers/net/wireless/ipw2200.c:6169:7: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:6285:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:6751:5: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:7854:6: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:8612:5: warning: symbol 'channel' shadows an earlier one
drivers/net/wireless/ipw2200.c:87:12: originally declared here
drivers/net/wireless/ipw2200.c:9606:6: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:9664:6: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:9770:6: warning: symbol 'mode' shadows an earlier one
drivers/net/wireless/ipw2200.c:88:12: originally declared here
drivers/net/wireless/ipw2200.c:10265:7: warning: symbol 'remaining_bytes' shadows an earlier one
drivers/net/wireless/ipw2200.c:10134:6: originally declared here
drivers/net/wireless/ipw2200.c:1236:23: error: bad constant expression
