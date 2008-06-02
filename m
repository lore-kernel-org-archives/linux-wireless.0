Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:17264 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262AbYFBRXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:23:47 -0400
Received: by yw-out-2324.google.com with SMTP id 9so559846ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Jun 2008 10:23:45 -0700 (PDT)
Message-ID: <1deddf2e0806021023j156ff226n98838622ad77ea9d@mail.gmail.com> (sfid-20080602_192351_543437_77B44EF1)
Date: Mon, 2 Jun 2008 10:23:44 -0700
From: "Ryan Loebs" <obsidianx@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Broadcom 4311 and Master Mode
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey folks,

I was wondering if it was possible to get the 4311 chipset to switch
into master mode? I've been trying, I'm running 2.6.26-rc4 with the
Johannes Berg patches and the latest git for hostapd.  I read about
success with the nl80211 driver and b43 so I gave that a shot but this
is what came up:

Configuration file: hostapd.conf
Hardware does not support configured mode
wlan0: IEEE 802.11 Hardware does not support configured mode (0)
Could not select hw_mode and channel. (-1)
rmdir[ctrl_interface]: No such file or directory

I hope this doesn't mean I'm SOL...  Any help would be great.

Thanks!
-Ryan Loebs
