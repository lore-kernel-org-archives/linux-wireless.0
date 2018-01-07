Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:38304 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754649AbeAGXtd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Jan 2018 18:49:33 -0500
Received: by mail-lf0-f45.google.com with SMTP id d19so2070765lfj.5
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jan 2018 15:49:33 -0800 (PST)
MIME-Version: 1.0
From: William Dauchy <wdauchy@gmail.com>
Date: Mon, 8 Jan 2018 00:49:11 +0100
Message-ID: <CAJ75kXYLOV8aVZpftBFRbMv=KCaxCoQpJFaL0m0QDjVOytq3Vg@mail.gmail.com> (sfid-20180108_004937_995338_02F3315F)
Subject: brcmfmac: set p2p_disc error on BCM4350
To: linux-wireless@vger.kernel.org
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Using the last v4.14.x I am getting this error at each boot, on my
BCM4350 802.11ac Wireless Network Adapter:

brcmfmac: brcmf_p2p_create_p2pdev: set p2p_disc error
brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlp58s0 type 10
failed: err=-16

The firmware used is:
brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Oct 22 2015
06:16:26 version 7.35.180.119 (r594535) FWID 01-e791c176

I was wondering if this error could be fixed?

Best,
-- 
William
