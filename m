Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wmail05.netvigator.com ([218.102.48.220]:35012 "EHLO
	wmail05.netvigator.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753222Ab0HOGDP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 02:03:15 -0400
Received: from [192.168.0.111] (really [116.48.112.18])
          by wmail05dat.netvigator.com
          (InterMail vM.7.05.01.01 201-2174-106-103-20060222) with ESMTP
          id <20100815060312.GXVS2050.wmail05dat.netvigator.com@[192.168.0.111]>
          for <linux-wireless@vger.kernel.org>;
          Sun, 15 Aug 2010 14:03:12 +0800
Subject: After compiling Openwrt, which image should I use for my TP-Link
 WR1043ND?
From: Robert Chan <robert.chan.list@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 15 Aug 2010 14:03:05 +0800
Message-ID: <1281852185.1932.25.camel@patrick-olevia>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

Sorry for reposting.  The last one did not seem to have gone through.

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




