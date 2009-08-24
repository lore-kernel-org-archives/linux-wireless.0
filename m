Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:43128 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080AbZHXMcp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 08:32:45 -0400
Received: by bwz19 with SMTP id 19so1418321bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Aug 2009 05:32:46 -0700 (PDT)
Subject: driver_nl80211 broken again
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 15:32:41 +0300
Message-Id: <1251117161.22951.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First connection works fine, but all following connections hang
wpa_supplicant hard, and more than that, this is first time,
NetworkManager confused that much that it refuses flat to connect to my
network, even if I  reload the wireless stack.

Only way to connect again, is to reload wireless stack, restart
wpa_supplicant, and restart NM, and this helps, only for one more shot.

My network is WPA2 protected, I use iwl3945, this is quite recent
regression (of course I use tip of wireless-testing)

Best regards,
	Maxim Levitsky

