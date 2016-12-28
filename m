Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wj0-f178.google.com ([209.85.210.178]:36169 "EHLO
        mail-wj0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbcL1Q7t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Dec 2016 11:59:49 -0500
Received: by mail-wj0-f178.google.com with SMTP id c11so136173470wjx.3
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2016 08:59:49 -0800 (PST)
MIME-Version: 1.0
From: Greg Oliver <oliver.greg@gmail.com>
Date: Wed, 28 Dec 2016 10:59:47 -0600
Message-ID: <CAF4tN+9-1X=VhQ-=zMHJzpPL6f35TysboSpr4OqLFfM89-kE-g@mail.gmail.com> (sfid-20161228_180002_809930_2BE65E8A)
Subject: BCM43602 -- Bluetooth while WiFi on 2.4GHz networks
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been fighting this laptop (MacBookPro11,5) for a year now with
linux (mainly on Thunderbolt and power issues), but this is one of the
last ones that remains.

The system contains a BCM 43602 (rebranded by Apple of course):

04:00.0 Network controller [0280]: Broadcom Limited BCM43602 802.11ac
Wireless LAN SoC [14e4:43ba] (rev 01)
    Subsystem: Apple Inc. Device [106b:0152]
    Flags: bus master, fast devsel, latency 0, IRQ 49
    Memory at b0800000 (64-bit, non-prefetchable) [size=32K]
    Memory at b0400000 (64-bit, non-prefetchable) [size=4M]
    Capabilities: [48] Power Management version 3
    Capabilities: [58] MSI: Enable+ Count=1/16 Maskable- 64bit+
    Capabilities: [68] Vendor Specific Information: Len=44 <?>
    Capabilities: [ac] Express Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [13c] Device Serial Number cd-97-9b-ff-ff-0b-a0-99
    Capabilities: [150] Power Budgeting <?>
    Capabilities: [160] Virtual Channel
    Capabilities: [1b0] Latency Tolerance Reporting
    Capabilities: [220] #15
    Capabilities: [240] L1 PM Substates
    Kernel driver in use: brcmfmac
    Kernel modules: brcmfmac

Modules options in use:
alternative_fw_path ::
debug ::  0
roamoff ::  1

Linux macbook 4.8.14-301.fc25.x86_64 #1 SMP Sun Dec 25 12:49:05 CST
2016 x86_64 x86_64 x86_64 GNU/Linux

Basically when wifi is on a 2.4G frequency, bluetooth (my keyboard and
mouse) are erratic (all over the place) - mouse stutters and keyboard
loses / repeats keys constantly.  In the past I have used atheros and
intel nics with their bt coexistent modes, but I do not see that
option for broadcom modules.

Is there a trick to getting them to play nice?  At home, it is not an
issue as I use 5GHz bands, but many times at customers they only have
2.4 on their "vendor supported" APs for me to use, so my mouse is a
no-go (and I truly hate trackpads).

Thanks for any help, and I can provide any info needed.  This seems to
be a common issue, but I do not see where anyone has fixed it or
posted to linux-wireless as of yet.

Thanks

-Greg
