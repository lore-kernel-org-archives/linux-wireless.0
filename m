Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f176.google.com ([209.85.216.176]:61765 "EHLO
	mail-px0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722AbZIJMLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 08:11:37 -0400
Received: by pxi6 with SMTP id 6so39918pxi.21
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 05:11:40 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 10 Sep 2009 17:33:58 +0530
Message-ID: <683e2de40909100503k619fdf6fp1e1ab267d68aa457@mail.gmail.com>
Subject: First Data (EAPOL) frame goes missing
From: Paresh Sawant <paresh.sawant@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am running wpa_supplicant on Linux (Kernel 2.6.30.5) with iwl3945
and mac80211. I am working in WPA2 Enterprise mode.

It came to my notice that after a successful association, first EAPOL
packet sent by the access point is missing and never reached the
mac80211. The wireless sniffer shows the frame shipped from the access
point.

I have put printk to dump the inbound frames in function
"__ieee80211_rx" in net/mac80211/rx.c. I see that though the frame is
shown on wireless sniffer but the dump for the same is missing.

Thanks
- Paresh
