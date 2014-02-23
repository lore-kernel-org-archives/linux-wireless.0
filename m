Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:46586 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbaBWOIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 09:08:53 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v1 0/6] mac80211: move specific tx flags into info->control.flags
Date: Sun, 23 Feb 2014 15:08:41 +0100
Message-Id: <1393164527-13800-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140223_150927_496339_4422ED41)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All usable  bits in enum mac80211_tx_control_flags are depleted. In
order to allow aditional control flag assigments this patchserie moves
all flags that got only used in the tx-path from info->flags into
info->control.flags. There are now 6 bits freed in enum mac80211_tx_control
that are usable for e.g. upcoming transmit power control (tpc).

Greetings Thomas

v1: fix compile errors when all drivers are properly selected

