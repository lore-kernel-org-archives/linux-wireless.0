Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25891 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209AbaELNxV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 09:53:21 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Alen Krmelj <krmelj.alen@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: RE: [Ilw] Wireless Centrino 2230-N issues
Date: Mon, 12 May 2014 09:32:47 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303DF0FF6@HASMSX103.ger.corp.intel.com> (sfid-20140512_155329_430624_2D8B3E17)
References: <536F6620.9030001@gmail.com>
In-Reply-To: <536F6620.9030001@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> My wireless card was working fine for some time, but after reinstallation of
> computer with Ubuntu, it stopped working and i keep getting this in my
> dmesg:

Can you please share with us the kernel versions you had used until now, and your current version?

> 
> lspci:
> 0a:00.0 Network controller: Intel Corporation Centrino Wireless-N 2230 (rev
> c4)
>          Subsystem: Intel Corporation Centrino Wireless-N 2230 BGN
> 
> 
> dmesg:
> [ 1465.050832] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> [ 1465.058299] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> [ 1465.104509] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
> failed: FW Error
> [ 1465.104522] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
> [ 1465.104527] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
> [ 1465.104818] iwlwifi 0000:0a:00.0: Unable to initialize device.
> [ 1465.105296] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> [ 1465.112770] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> [ 1465.156493] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
> failed: FW Error
> [ 1465.156500] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
> [ 1465.156504] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
> [ 1465.156784] iwlwifi 0000:0a:00.0: Unable to initialize device.
> [ 1465.158031] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> [ 1465.165471] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> [ 1465.212534] iwlwifi 0000:0a:00.0: Command COEX_PRIORITY_TABLE_CMD
> failed: FW Error
> [ 1465.212542] iwlwifi 0000:0a:00.0: Could not complete ALIVE transition: -5
> [ 1465.212546] iwlwifi 0000:0a:00.0: Failed to start RT ucode: -5
> [ 1465.212825] iwlwifi 0000:0a:00.0: Unable to initialize device.
> [ 1465.213119] iwlwifi 0000:0a:00.0: L1 Disabled; Enabling L0S
> [ 1465.220559] iwlwifi 0000:0a:00.0: Radio type=0x2-0x0-0x0
> 
> Does this mean i have issue with driver/kernel or my wifi card is
> broken? I tried copying latest uucode for 2230 wireless card
> (http://wireless.kernel.org/en/users/Drivers/iwlwifi?action=AttachFile&do=
> get&target=iwlwifi-2030-ucode-18.168.6.1.tgz)
> into /lib/firmware and reloading kernel module, no success. Still the
> same issue.
> 
> 
> Best regards,
> Alen Krmelj
> 
> _______________________________________________
> ilw mailing list
> ilw@linux.intel.com
> http://linux.intel.com/mailman/listinfo/ilw
