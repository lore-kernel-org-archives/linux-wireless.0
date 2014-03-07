Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:35518 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaCGFzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 00:55:49 -0500
Received: by mail-wg0-f50.google.com with SMTP id x13so4413152wgg.21
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 21:55:48 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 7 Mar 2014 11:25:48 +0530
Message-ID: <CADNhdGE+SYkP5x=qvkCVHy4mN-JZx33L9An97SObGj_+8h1qnw@mail.gmail.com> (sfid-20140307_065552_709551_A1263D5E)
Subject: rtl8192cu: beacons issue with hostapd
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i am using a USB dongle that has the RTL 8188 chipset.
On Linux Kernel 3.3.4 it gets detected and the rtl8192cu driver is used.
Upon running hostapd (to use nl80211) in 802.11g mode, I am able to
connect a client, however i do not see beacons when i capture the wifi
packets through a laptop with its wifi interface in monitor mode.

1. Why am i not seeing any beacons? The beacon interval configured in
hostapd is default 100ms.

2. The connection is flaky and i often see Ping drops when i ping an
entity beyond the AP. Is this because of beacon issue?

Please help.

regards,
-shankar
