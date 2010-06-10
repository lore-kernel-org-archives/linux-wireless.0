Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:17958 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759709Ab0FJWOB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jun 2010 18:14:01 -0400
Received: by fg-out-1718.google.com with SMTP id d23so64097fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jun 2010 15:14:00 -0700 (PDT)
Date: Fri, 11 Jun 2010 00:13:57 +0200
From: Vladimir Botka <vbotka@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [rt2800pci] indirect register access failed
Message-ID: <20100611001357.27b316ba@vlado.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hallo,

with the wireless-testing kernel [1] and the ralink [1814:3090] I can
not load the firmware [2]. Any idea ?

[1] 2.6.35-rc2-wl-wt-ralink+

[2]
Jun 11 00:07:10 calpella kernel: [ 6828.735900] phy0 -> rt2800pci_load_firmware: Error - PBF system register not ready.
Jun 11 00:07:10 calpella kernel: [ 6828.736466] phy0 -> rt2x00pci_regbusy_read: Error - Indirect register access failed: offset=0x00007010, value=0x55555555

Thank you,
