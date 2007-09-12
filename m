Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:44541 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937AbXILKFl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Sep 2007 06:05:41 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1IVP5i-0000Oe-4l
	for linux-wireless@vger.kernel.org; Wed, 12 Sep 2007 12:05:02 +0200
Received: from 80.169.182.16 ([80.169.182.16])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 12:05:02 +0200
Received: from marcus by 80.169.182.16 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 12 Sep 2007 12:05:02 +0200
To: linux-wireless@vger.kernel.org
From: Marcus Better <marcus@better.se>
Subject: rt2500 suspend problems
Date: Wed, 12 Sep 2007 09:41:32 +0200
Message-ID: <fc85aq$uu6$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

my laptop with rt2500 card won't wake up from suspend-to-RAM. The cause
seems to be the rt2x00 driver. Are there any known issues with this? I
tried 2.6.23-rc4 from wireless-dev head (yesterday), and also an earlier
commit based on 2.6.23-rc3.

(As a separate issue, it seems I cannot even associate to my AP with WEP
with the latest kernel. The syslog says:
Sep 12 07:55:13 better kernel: wlan0: RX WEP frame, but no key set
.)

Here's the lspci line for the WiFi card:

08:02.0 Network controller [0280]: RaLink RT2500 802.11g Cardbus/mini-PCI
[1814:0201] (rev 01)

The system is an LG LE50 Express i386 laptop.

Thanks,

Marcus


