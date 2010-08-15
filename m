Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:55704 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab0HOE5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 00:57:48 -0400
Received: by pxi10 with SMTP id 10so1400807pxi.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 Aug 2010 21:57:47 -0700 (PDT)
Subject: After compiling Openwrt, which image should I use for my TP-Link
 WR1043ND?
From: Robert Chan <robert.chan.list@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Aug 2010 12:57:32 +0800
Message-ID: <1281848252.1932.20.camel@patrick-olevia>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I am pretty new to Openwrt.  I got through the compiling of it, and
selected the ar71xx as my target and TP-Link WR1043ND v1 as my
platform.  

Now, when I look into the /bin/ar71xx folder, however, I found quite a
few images:

openwrt-ar71xx-root.squashfs
openwrt-ar71xx-root.squashfs-4k
openwrt-ar71xx-uImage-gzip.bin
openwrt-ar71xx-uImage-lzma.bin
openwrt-ar71xx-vmlinux.bin
openwrt-ar71xx-vmlinux.elf
openwrt-ar71xx-vmlinux.gz
openwrt-ar71xx-vmlinux.lzma

Which image should I use to flash my router?  

According to the "Using the Image Builder Howto, I should be expecting
something like openwrt-ar71xx-tl-wr1043nd-v1-squashfs.bin, right?

Also, it looks to me that openwrt-ar71xx-root.squashfs is the one, but
it is 30MB big.  AFAIK, the tl-wr1043rd has only 32MB of RAM and 64MB of
flash, would it be too large?

Thanks very much in advance.

Robert


