Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62770 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab1FCGnS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 02:43:18 -0400
Received: by bwz15 with SMTP id 15so1533009bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 23:43:16 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 3 Jun 2011 14:43:16 +0800
Message-ID: <BANLkTimnkGyQmEJ2fcowoiv_f+aLm2AQcg@mail.gmail.com> (sfid-20110603_084321_386276_CCE5C7F6)
Subject: master-2011-06-01 git tree can't recognize my AR9285 chip.
From: Matt Chen <machen@novell.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I git pull the latest version of wireless-testing tree and built whole
the kernel and related driver. I found my AR9285 (10ec:002b) can't be
recognized, and the ath9k is not loaded automatically. I tried the
kernel 2.6.39, it is working right.

Some info as below :
1) linux:/home/linux/git/wireless-testing # git describe
    master-2011-06-01
2) linux:/home/linux/git/wireless-testing # lspci -nnk
     ....
     09:00.0 Network controller [0280]: Atheros Communications Inc.
AR9285 Wireless Network Adapter
     (PCI-Express) [168c:002b] (rev 01)
     ff:00.0 Host bridge [0600]: Intel Corporation Core Processor
QuickPath Architecture Generic Non-core Registers
     [8086:2c62] (rev 02)
     .....


-- 
Thanks ~
Matt Chen
