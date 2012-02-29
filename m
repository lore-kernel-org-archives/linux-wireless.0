Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.watchguard.com ([206.191.171.101]:41599 "EHLO
	watchguard.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030827Ab2B2Hje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 02:39:34 -0500
From: Bryan Phillippe <Bryan.Phillippe@watchguard.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: compat-wireless-3.3-rc1-2 unusably slow: unknown action category 131
Date: Wed, 29 Feb 2012 07:39:30 +0000
Message-ID: <6654CE5C-B8FF-4428-9852-8BE856B31D86@watchguard.com> (sfid-20120229_083938_042705_025B60BF)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


After upgrading from compat-wireless-3.0-2 on Linux-2.6.35.12, which was reasonably solid and fast, to compat-wireless-3.3-rc1-2 (same kernel, same hostapd-0.7.3), I now get unusably slow performance from my iPhone (2.4Ghz), and the hostapd logs are flooding with these:

Feb 28 23:30:09 2012 bpnewcastle local3.debug hostapd: ath1: STA 00:26:b0:8f:1c:61 IEEE 802.11: handle_action - unknown action category 131 or invalid fraH
Feb 28 23:30:09 2012 bpnewcastle local3.debug hostapd: ath1: STA 00:26:b0:8f:1c:61 IEEE 802.11: handle_action - unknown action category 131 or invalid fraH
Feb 28 23:30:37 2012 bpnewcastle local3.debug hostapd: ath1: STA 00:26:b0:8f:1c:61 IEEE 802.11: handle_action - unknown action category 131 or invalid fraH
Feb 28 23:30:39 2012 bpnewcastle local3.debug hostapd: ath1: STA 00:26:b0:8f:1c:61 IEEE 802.11: handle_action - unknown action category 131 or invalid fraH

Reverting back to compat-wireless-3.0-2 corrects the speed problem, but it has other bugs so I'm trying to move forward.

Thanks,
--
-bp


