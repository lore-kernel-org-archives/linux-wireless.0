Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:15324 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980AbYHUW2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:28:10 -0400
Received: by ik-out-1112.google.com with SMTP id c28so104766ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:28:08 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 00/19] orinoco: WPA for Agere based cards
Date: Thu, 21 Aug 2008 23:27:45 +0100
Message-Id: <1219357685-24731-1-git-send-email-kilroyd@gmail.com> (sfid-20080822_002815_101452_4D25B377)
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series enables WPA on Agere based orinoco devices.

Patchset overview
1-2: General scanning updates
3-9: Agere firmware download to RAM
10-12: Update orinoco to work with new firmware
13-19: WPA functionality

This patchset addresses a few issues raised the last time it was
submitted:
 * fix compile/sparse warnings on 64 bit
 * scan buffer size increased

The patchset is against wireless-testing (master-2008-08-20), is
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
