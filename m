Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43720 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1CPOMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 10:12:40 -0400
Received: by bwz15 with SMTP id 15so1544936bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Mar 2011 07:12:39 -0700 (PDT)
From: Peter Lemenkov <lemenkov@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@redhat.com>,
	rt2x00-dev <users@rt2x00.serialmonkey.com>,
	Peter Lemenkov <lemenkov@gmail.com>
Subject: [PATCH 0/4] Few missing USB IDs for rt2x00 USB WiFi adapters
Date: Wed, 16 Mar 2011 17:12:14 +0300
Message-Id: <1300284739-7797-1-git-send-email-lemenkov@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Here are few missing USB IDs for several USB WiFi adapters.
Also I tested Asus USB-N11 device and can confirm now that
it works just fine as rt2870 device (only model with swapped
vendor and device IDs was tested).

Peter Lemenkov (4):
  rt2x00: Add rt2870 device id
  rt2x00: Add Planex Communications, Inc. RT8070 under
    CONFIG_RT2800USB_UNKNOWN
  rt2x00: Add 2L Central Europe BV 8070 under CONFIG_RT2800USB_UNKNOWN
  rt2x00: Add unknown Toshiba device, mentioned in rt3572sta sources,
    under CONFIG_RT2800USB_UNKNOWN

 drivers/net/wireless/rt2x00/rt2800usb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

-- 
1.7.4

