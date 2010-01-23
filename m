Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:21559 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab0AWUpj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 15:45:39 -0500
Received: by fg-out-1718.google.com with SMTP id 16so396691fgg.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 12:45:37 -0800 (PST)
Subject: mac80211: Breakage in software encryption (iwl3945)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 22:10:59 +0200
Message-ID: <1264277460.13250.10.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I updated the kernel and lost connection to my WPA2
AP. Strangely the WPA handshake completes, but DHCP not.

I also unfortunately found that all that time I was using software
encryption (this is iwl3945 loaded with swcrypto=1).
Hardware encryption doesn't work ether and didn't work in the slightly
older kernel (but it did work once, I sure)

Now, the commit a6bae9e7ab19876a157c91019852395539e4f20e breaks software
encryption, with behaviour like described above.

Best regards,
Maxim Levitsky

