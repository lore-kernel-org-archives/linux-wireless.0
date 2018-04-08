Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr10050.outbound.protection.outlook.com ([40.107.1.50]:10691
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751423AbeDHG6l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Apr 2018 02:58:41 -0400
To: <linux-wireless@vger.kernel.org>, <centos-devel@centos.org>
From: Dusan Bruncko <dusan.bruncko@cern.ch>
Subject: iwlwifi-7265-ucode-25.30.14.0.tgz. in Centos 7
Message-ID: <fe3605be-8ce1-ee6f-7ea2-7f736f5493fb@cern.ch> (sfid-20180408_085848_062348_FD3F9A27)
Date: Sun, 8 Apr 2018 08:58:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Allow me to ask you the following question:

I have laptop with: "02:00.0 Network controller: Intel Corporation 
Wireless 7265 (rev 59)".
For this device I found firmware iwlwifi-7265-ucode-25.30.14.0.tgz.

My problem is following: This firmware was created for kernel 4.2+, but 
I am using
Centos 7 with kernels a la 3.10. Therefore I see during booting and 
after switch off some
problematic messages a la:
capa flags index 3 larger than supported by driver  or
failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware ...

Wi-fi works properly, not to look on the previous messages.

My question to you: do you have in schedule to include proper firmware 
also for
centos 7/redhat 7?

Regards,
                  Dusan
