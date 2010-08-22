Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from imsm057.netvigator.com ([218.102.48.210]:51986 "EHLO
	imsm057.netvigator.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708Ab0HVSSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Aug 2010 14:18:10 -0400
Received: from [192.168.0.111] (really [119.236.69.139])
          by imsm057dat.netvigator.com
          (InterMail vM.7.05.01.01 201-2174-106-103-20060222) with ESMTP
          id <20100822181809.EMAQ28063.imsm057dat.netvigator.com@[192.168.0.111]>
          for <linux-wireless@vger.kernel.org>;
          Mon, 23 Aug 2010 02:18:09 +0800
Subject: Please help! The SYS LED on TL-WR1043ND stays dark after flashig
 OpenWRT ...
From: Robert Chan <robert.chan.list@gmail.com>
To: linux-wireless@vger.kernel.org
In-Reply-To: <000901cb4225$5ba42ba0$12ec82e0$@chan.list@gmail.com>
References: <000901cb4225$5ba42ba0$12ec82e0$@chan.list@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 02:18:08 +0800
Message-ID: <1282501088.1982.1.camel@patrick-olevia>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear OpenWRT and 802.11s experts,

Sorry for posting this question to both groups at the same time, but
this problem is killing me and the deadline is coming up real soon!

After playing around with the kernel_menuconfig, I finally enabled “mesh
networking (pre-802.11s) and compiled the kernel.  I then flashed the
kernel (using the openwt-ar71xx-tl-wr1043nd-v1-squashfs-facory.bin) onto
the TL-WR1043ND (from the original firmware’s firmware upgrade).  The
flash was reported successful, however the SYS LED stays dark ever since
(of course I rebooted the router many times).  The PWR and LAN port LED
are ON, though.

Needless to say, I cannot even connect to the firmware through
192.168.1.1.  so what is going on?  After search google and numerous
forums on OpenWRT, I still cannot find this kind of “brick” scenario.
So is the router “bricked”?  

I have seen many posts regarding opening the case and solder the serial
port to the board.  However, no one in my company has that kind of
experience. So would this be the ONLY option I have right now?

I appreciate for any hints I may be given.  Thanks very much in advance.

Regards,

Robert


