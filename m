Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51995 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2HPPGb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 11:06:31 -0400
Received: by wgbdr13 with SMTP id dr13so2499167wgb.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2012 08:06:30 -0700 (PDT)
Message-ID: <502D0C72.2050207@lwfinger.net> (sfid-20120816_170635_404509_F239FBF6)
Date: Thu, 16 Aug 2012 10:06:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Intel Linux Wireless <ilw@linux.intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: Missing firmware iwlwifi-2030-5.ucode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to help an openSUSE 12.1 user who is running kernel 3.1.9, who has 
an Intel 802.11 b/g/n card with Bluetooth mounted in an HP dvdt-7000 Quad 
Edition Series computer.

The driver is asking for firmware named "iwlwifi-2030-5.ucode"; however, that 
particular file does not exist in /lib/firmware, nor is in the linux-firmware 
git repo where only the version 6 firmware exists.

I could find no record of the firmware ever being in the git repo, nor could I 
find it using a Google search. For users of kernel 3.1, I request that this 
firmware file be submitted to linux-firmware. In addition, if you send me a copy 
of the file, I will see that the OP on the openSUSE Forum gets a copy.

Thanks,

Larry
