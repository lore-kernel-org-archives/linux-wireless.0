Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52362 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1KVSLq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 13:11:46 -0500
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id pAMIBjNH024404
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2011 10:11:45 -0800
Message-ID: <4ECBE5E1.3000209@candelatech.com> (sfid-20111122_191149_242124_20DA201C)
Date: Tue, 22 Nov 2011 10:11:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Compile failure related to iwlegacy
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just pulled wireless-testing and tried building:

   BUILD   arch/x86/boot/bzImage
Setup is 14908 bytes (padded to 15360 bytes).
System is 3555 kB
CRC 36c2015b
Kernel: arch/x86/boot/bzImage is ready  (#28)
   MODPOST 2828 modules
ERROR: "il_dbgfs_unregister" [drivers/net/wireless/iwlegacy/iwl4965.ko] undefined!
ERROR: "il_dbgfs_register" [drivers/net/wireless/iwlegacy/iwl4965.ko] undefined!
ERROR: "il_dbgfs_unregister" [drivers/net/wireless/iwlegacy/iwl3945.ko] undefined!
ERROR: "il_dbgfs_register" [drivers/net/wireless/iwlegacy/iwl3945.ko] undefined!
WARNING: modpost: Found 7 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

