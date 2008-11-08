Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s15.bay0.hotmail.com ([65.54.246.215]:29811 "EHLO
	bay0-omc3-s15.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753221AbYKHMvx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 07:51:53 -0500
Message-ID: <BAY104-DAV4C468E484B2456B3D02B799180@phx.gbl> (sfid-20081108_135158_067215_F443609D)
Message-ID: <491589ED.4090904@hotmail.com>
Date: Sat, 08 Nov 2008 23:45:33 +1100
From: Shaddy Baddah <shaddy_baddah@hotmail.com>
Reply-To: linux-wireless@vger.kernel.org,
	  Shaddy Baddah <shaddy_baddah@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: zd1211rw (2.6.26 sparc64): unaligned access (zd_mac_rx)
References: <4902DEBB.3050205@hotmail.com> <20081025112147.GA12252@Chamillionaire.breakpoint.cc> <200810251325.07916.mb@bu3sch.de> <20081025112813.GC12252@Chamillionaire.breakpoint.cc> <49033782.5040701@hotmail.com>
In-Reply-To: <49033782.5040701@hotmail.com>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi again,

On 26/10/08 02:13, Shaddy Baddah wrote:
> After applying this patch, things seem better. I can associate to an 
> open access point, get an IP address and even ping.
> 
> However on association, I am still seeing:
> 
> 
> [  179.249516] zd1211rw 4-3:1.0: zd_usb_rfwrite() value 0x01e6666 bits 24
> [  179.254524] wlan0: Initial auth_alg=0
> [  179.254549] wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
> [  179.256215] Kernel unaligned access at TPC[10129b94] 
> zd_mac_rx+0x174/0x320 [zd1211rw]
> [  179.349135] Kernel unaligned access at TPC[10129b9c] 
> zd_mac_rx+0x17c/0x320 [zd1211rw]
> [  179.442852] Kernel unaligned access at TPC[10129ba0] 
> zd_mac_rx+0x180/0x320 [zd1211rw]
> [  179.536579] Kernel unaligned access at TPC[10129ba4] 
> zd_mac_rx+0x184/0x320 [zd1211rw]
> [  179.630306] Kernel unaligned access at TPC[10129ba8] 
> zd_mac_rx+0x188/0x320 [zd1211rw]

I'm keen on troubleshooting this myself. Could you please tell me how I 
can get a disassembly intermixed with source. An objdump -S ./zd1211rw.o 
is not doing the job. I'd rather not re-compile the whole kernel if 
possible, because it takes long. Should I rm the file, do a build, take 
the command line and substitute -g for any -O option?

TIA,
Shaddy


