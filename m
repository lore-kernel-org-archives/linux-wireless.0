Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:51104 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab2ACOKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 09:10:41 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Ri54Z-00030y-F1
	for linux-wireless@vger.kernel.org; Tue, 03 Jan 2012 15:10:39 +0100
Received: from ii143133.directconnect.no ([84.247.143.133])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 15:10:39 +0100
Received: from ltson36 by ii143133.directconnect.no with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 15:10:39 +0100
To: linux-wireless@vger.kernel.org
From: Thanh Son Le <ltson36@yahoo.com>
Subject: [PATCH 0/2] add support for mcs masks
Date: Tue, 3 Jan 2012 14:10:27 +0000 (UTC)
Message-ID: <loom.20120103T150820-24@post.gmane.org> (sfid-20120103_151056_571554_B91708A9)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Simon

I have read your patches on adding supports for MCS rates, both iw and compat-
wireless, it seems interesting.

For evaluation purpose, I have added the patches to Compat-wireless and IW. It 
seems compiling and running fine.

But when I tried to set up the rate, through iw set bitrates command, it does 
not work. Please refer to the following dumping message for further details:
----------------------------------------------
root@Openwrt:/sys/kernel/debug/ieee80211/phy0# iw dev wlan0.sta1 set bitrates 
mcs-5 14
root@Openwrt:/sys/kernel/debug/ieee80211/phy0# iw dev wlan0.sta1 station dump
Station 00:xx::xx:xx:xx (on wlan0.sta1)
        inactive time:  490 ms
        rx bytes:       1739675
        rx packets:     15179
        tx bytes:       7421803
        tx packets:     14051
        tx retries:     714
        tx failed:      139
        signal:         -45 dBm
        signal_ctl0:    -46 dBm
        signal_ctl1:    -45 dBm
        tx bitrate:     6.0 MBit/s
        rx bitrate:     6.0 MBit/s
root@Javelin:/sys/kernel/debug/ieee80211/phy0# 
--------------------------------------------------------------------------------
-------

I have tested both with ack and noack, but it still does not work
Both AP and STA are in WDS.

Can you check for me whether the set command is correct and whether it can work 
in AP/STA mode ?

Once again, Thanks you very much for your kind helps and considerations and I 
look forward to receiving information from you.

Yours sincerely

Le

