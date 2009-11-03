Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:3337 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285AbZKCAjz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 19:39:55 -0500
Received: by fg-out-1718.google.com with SMTP id 16so245452fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 16:39:58 -0800 (PST)
Subject: iwl3945 microcode errors
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Nov 2009 02:39:54 +0200
Message-ID: <1257208794.6556.2.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see that iwl3945 began to show some microcode errors like that:

[   18.259947] iwl3945 0000:06:00.0: firmware: requesting iwlwifi-3945-2.ucode
[   18.766225] iwl3945 0000:06:00.0: loaded firmware version 15.32.2.9
[   18.817952] iwl3945 0000:06:00.0: Microcode SW error detected. Restarting 0x82000008.
[   18.817971] iwl3945 0000:06:00.0: Error Reply type 0x00000000 cmd UNKNOWN (0x88) seq 0xDB3B ser 0x00880000
[   18.822468] iwl3945 0000:06:00.0: Can't stop Rx DMA.
[   20.790058] iwl3945 0000:06:00.0: Wait for START_ALIVE timeout after 2000ms.

Now it still works, but there were cases it didn't.

I post more detailed info soon.

Best regards,
	Maxim Levitsky

