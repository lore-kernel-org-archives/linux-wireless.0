Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:58251 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753965AbYJASUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2008 14:20:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Kl6Is-0007ae-Mv
	for linux-wireless@vger.kernel.org; Wed, 01 Oct 2008 18:20:02 +0000
Received: from adsl-dyn239.78-99-97.t-com.sk ([78.99.97.239])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 18:20:02 +0000
Received: from trigves by adsl-dyn239.78-99-97.t-com.sk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 01 Oct 2008 18:20:02 +0000
To: linux-wireless@vger.kernel.org
From: Trigve <trigves@yahoo.com>
Subject: intel wifi 5100 (iwlagn) authentication timed out
Date: Wed, 1 Oct 2008 18:18:38 +0000 (UTC)
Message-ID: <loom.20081001T181402-749@post.gmane.org> (sfid-20081001_202011_490991_7F4D4C3B)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I have problem connecting to my router with iwlagn driver installed. I'm using
WPA-PSK but also with no encryption set I wasn't able to connect. When trying to
connect this message comes out repeatedly: "wlan0: authentication with AP
00:4f:6a:00:5e:ef timed out"

Here is the part of output:
ACPI: PCI interrupt for device 0000:02:00.0 disabled
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100002,
writing 100006)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: authenticate with AP 00:4f:6a:00:5e:ef
wlan0: authenticate with AP 00:4f:6a:00:5e:ef
wlan0: authenticate with AP 00:4f:6a:00:5e:ef
wlan0: authentication with AP 00:4f:6a:00:5e:ef timed out


Anybody could help, please?

thanks

Trigve 

