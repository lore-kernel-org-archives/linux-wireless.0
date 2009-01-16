Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:17205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763699AbZAPRHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 12:07:52 -0500
Received: by fg-out-1718.google.com with SMTP id 19so860073fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 09:07:50 -0800 (PST)
Message-ID: <3ace41890901160907w2d04da91r61744477ac64e018@mail.gmail.com> (sfid-20090116_180758_078948_080B0990)
Date: Fri, 16 Jan 2009 17:07:50 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: garbaged AP mac address in dmesg in wireless-testing?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since a few days ago, my dmesg is looking like this - instead of the
older AA:BB:CC:DD:EE:FF form
with the mac address of the AP.
That ffff88* looks like a pointer/address to me? Is this change intentional?

--------------
wlan2 direct probe responded
wlan2: authenticate with AP ffff880070995aa0
wlan2: authenticated
wlan2: associate with AP ffff880070995aa0
wlan2: RX ReassocResp from ffff88001431f01a (capab=0x431 status=0 aid=1)
wlan2: associated
-------------
