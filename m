Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:35189 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbYGNLhl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2008 07:37:41 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1484782nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jul 2008 04:37:39 -0700 (PDT)
Message-ID: <f6ca9fed0807140437i2563cfa1ge68a06ef1040d0f8@mail.gmail.com> (sfid-20080714_133744_850260_52B1BB2F)
Date: Mon, 14 Jul 2008 13:37:39 +0200
From: drago01 <drago01@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: iwl3945 random firmware crashes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I noticed some weird firmware restarts with iwl3945 lately.
-----------------
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Error Reply type 0x00000005 cmd REPLY_SCAN_CMD (0x80) seq
0x4419 ser 0x0000004B
iwl3945: Can't stop Rx DMA.
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Error Reply type 0x00000005 cmd REPLY_LEDS_CMD (0x48) seq
0x0408 ser 0x0000004B
iwl3945: Can't stop Rx DMA.
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Error Reply type 0x00000005 cmd REPLY_LEDS_CMD (0x48) seq
0x0408 ser 0x0000004B
iwl3945: Can't stop Rx DMA.
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Error Reply type 0x00000005 cmd REPLY_LEDS_CMD (0x48) seq
0x0407 ser 0x0000004B
iwl3945: Can't stop Rx DMA.
---------------
There seem to be random (can not reproduce them always) but the only
way to get the wireless working is to
1) unload the module
2) go to another room
3) load module
4) connect to AP
5) go back to the room and it works

If I stay in the same room after reloading the module the firmware
crashes happen again.

I have no output with the event log because they happen randomly and I
cannot reproduce them.

Any ideas?
