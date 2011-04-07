Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:59513 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1DGVth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 17:49:37 -0400
Received: by yia27 with SMTP id 27so1211519yia.19
        for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 14:49:36 -0700 (PDT)
Message-ID: <4D9E316E.4000908@lwfinger.net>
Date: Thu, 07 Apr 2011 16:49:34 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jett Chen <jett_chen@ralinktech.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Questions about rt2800usb
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I know from experience that the staging driver rt82860sta has been replaced by 
rt2800pci and I plan to push a patch deleting the driver from staging.

It appears that rt2870sta has been replaced by rt2800usb. Is that correct? If 
so, I will also include the deletion of that driver from staging in the patch.

I noticed that rt2870sta includes a few USB IDs not found in rt2800usb, namely:

0x2001:0x3c09, 0x2001:0x3c0a, and 0x2019:0xed14.

Any reasons why these should not be included in rt2800usb?

Please let me know of any objections to removing those two staging drivers.

Thanks,

Larry
