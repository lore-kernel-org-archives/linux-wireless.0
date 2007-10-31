Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12037 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753523AbXJaBEi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2007 21:04:38 -0400
Subject: Re: iwl3945 in 2.6.24-rc1 dies under load
From: Zhu Yi <yi.zhu@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-wireless@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20071031005202.GA1534@elf.ucw.cz>
References: <20071031005202.GA1534@elf.ucw.cz>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 08:54:58 +0800
Message-Id: <1193792098.9704.16.camel@debian.sh.intel.com> (sfid-20071031_010444_034468_1A0E95CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Wed, 2007-10-31 at 01:52 +0100, Pavel Machek wrote:
> tcpspray -n 1 -b 10000000 10.0.0.2
> 
> Oct 31 01:42:56 amd kernel: iwl3945: Microcode SW error detected.
> Restarting 0x82000008.
> Oct 31 01:42:56 amd kernel: iwl3945: Error Reply type 0x00000005 cmd
> REPLY_TX (0x1C) seq 0x02C7 ser 0x0000004B
> Oct 31 01:42:58 amd kernel: iwl3945: Can't stop Rx DMA.

Please attach the dmesg with module param debug=0x43fff (make sure
CONFIG_IWLWIFI_DEBUG is selected). This will dump the firmware event log
for debug.

Thanks,
-yi
