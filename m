Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:58413 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaCGL7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 06:59:47 -0500
Received: by mail-wg0-f48.google.com with SMTP id l18so472897wgh.7
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 03:59:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADNhdGE+SYkP5x=qvkCVHy4mN-JZx33L9An97SObGj_+8h1qnw@mail.gmail.com>
References: <CADNhdGE+SYkP5x=qvkCVHy4mN-JZx33L9An97SObGj_+8h1qnw@mail.gmail.com>
Date: Fri, 7 Mar 2014 17:29:45 +0530
Message-ID: <CADNhdGH7QrVXJccRcGOGDC83P82rBF5b2MfqaHzfdcCb1SEyNg@mail.gmail.com> (sfid-20140307_125955_621958_A493D5A9)
Subject: Fwd: rtl8192cu: beacons issue with hostapd
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resending this...kindly help / clarify.

---

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
