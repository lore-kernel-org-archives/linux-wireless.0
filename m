Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.178]:8775 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbYHBKOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 06:14:48 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1578395ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 03:14:47 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH 00/19] orinoco: WPA for Agere based cards
Date: Sat,  2 Aug 2008 11:14:14 +0100
Message-Id: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> (sfid-20080802_121453_061973_4234392F)
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series enables WPA on Agere based orinoco devices.

Patchset overview
1-2: General scanning updates
3-9: Agere firmware download to RAM
10-12: Update orinoco to work with new firmware
13-19: WPA functionality

This patchset is against wireless-testing (master-2008-07-16), is
sparse clean (UP), and should be bisectable. It is almost checkpatch
clean - the single warning looks like a false positive to me.

To use WPA, you will need an Agere firmware image. You can get the
necessary file at
<http://marc.info/?l=orinoco-devel&m=121078835610877>, just extract
and rename orinoco.fw to agere_sta_fw.bin and place it in
/lib/firmware (or distro equivalent). Alternatively you can try
extract firmware from a Windows driver using the program in
<http://marc.info/?l=orinoco-devel&m=120846933719051>.



Regards,

Dave.
