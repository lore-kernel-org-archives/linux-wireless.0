Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36836 "EHLO
        mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752708AbdCFNXq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2017 08:23:46 -0500
Received: by mail-yw0-f182.google.com with SMTP id o4so57095151ywd.3
        for <linux-wireless@vger.kernel.org>; Mon, 06 Mar 2017 05:23:15 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Mon, 6 Mar 2017 21:23:14 +0800
Message-ID: <CABWe71x69veyzepd=+Pgn6JtV4PMhFfn1nfM3K+Peb4aVRU-yw@mail.gmail.com> (sfid-20170306_142528_006619_6EB59BEC)
Subject: Atheros ath9k superchannel
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

I am reading ath9k code. And try use superchannel (2312 ~ 2732) on
openwrt. I have successfully opened these channels, and verified by
mikrotik. But when use hostapd on these superchannel , ath9k can not
send out any packets. A large number of Global Tx Timeout (GTT) and
Carrier Sense Timeout (CST) were interrupted.

root@OpenWrt:~# cat /sys/kernel/debug/ieee80211/phy0/ath9k/interrupt

                  CST:        791
                  GTT:        660


My chip is ar9331 which is ar9003 family.  I am confused by some
registers in ar9003_phy.h. In ar9331 datasheet many registers are
reserved.

I do not know how to go on now. Can you give me a hint?

Regards
