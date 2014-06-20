Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34016 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353AbaFTHEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 03:04:45 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: kbuild test robot <fengguang.wu@intel.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [wireless-next:master 81/103] debugfs.c:undefined reference to `__udivdi3'
Date: Fri, 20 Jun 2014 10:04:38 +0300
Message-ID: <2726638.LfDSnF5pNj@lx-wigig-72> (sfid-20140620_090450_613391_559A4CA2)
In-Reply-To: <53a34eca.II3U4c3qnUUeOSk1%fengguang.wu@intel.com>
References: <53a34eca.II3U4c3qnUUeOSk1%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday, June 20, 2014 04:57:46 AM kbuild test robot wrote:
> tree:  
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git
> master head:   2e91606f5e1ec7329557dfc0e298c4c021acbb80
> commit: 7c0acf868d2e470c9d6a40091acf8d6444c01b57 [81/103] wil6210: Tx
> performance monitoring config: i386-randconfig-ha3-0620 (attached as
> .config)
> 
> All error/warnings:
> 
>    drivers/built-in.o: In function `wil_vring_debugfs_show':
> >> debugfs.c:(.text+0x39b9be): undefined reference to `__udivdi3'
> 
> ---
> 0-DAY kernel build testing backend              Open Source Technology
> Center http://lists.01.org/mailman/listinfo/kbuild                 Intel
> Corporation

Interesting finding. I use this code for long time and it was OK on both
32-bit and 64-bit platforms. I have different .config and compile
this driver as module. Anyway, bug is bug.
Sending patch in the separate mail.

Thanks, Vladimir
