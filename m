Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36600 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbcDVMWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 08:22:14 -0400
Received: by mail-yw0-f182.google.com with SMTP id o66so120479714ywc.3
        for <linux-wireless@vger.kernel.org>; Fri, 22 Apr 2016 05:22:14 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 22 Apr 2016 17:51:54 +0530
Message-ID: <CABPxzYLZ2thNWCQ6bQ0-Peic-X-FTpTv4wJxyXVdmBDQDRS8JA@mail.gmail.com> (sfid-20160422_142217_239943_C27C0A17)
Subject: Debug prints mac80211 drivers
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

What is the recommended method for adding
debug prints in mac80211 based drivers.

1) -DDEBUG + pr_debug ==> used by mac80211, brcm80211
2) -DDEBUG + dev_dbg ==> zd1201
3) dev_printk(KERN_DEBUG) ==> used by iwlwifi
4) printk(KERN_DEBUG) ==> Just to complete the list.

-- 
Thanks,
Regards,
Chaitanya T K.
