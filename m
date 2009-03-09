Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.230]:47621 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377AbZCIFtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 01:49:13 -0400
Received: by rv-out-0506.google.com with SMTP id g37so1495701rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Mar 2009 22:49:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 9 Mar 2009 11:19:10 +0530
Message-ID: <d9360e520903082249w43a2c670oad8f5c56ca0df638@mail.gmail.com> (sfid-20090309_064923_770405_64689F6E)
Subject: crash in wlan stack due to my code
From: Bharat Bhushan <bharat.b.bhushan@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

   i am trying to develop open source mac driver fo our wlan device
and Due to some inherent issues with my embedded platform i need to
stick to the kernel veriosn 2.6.22(i guess the version when the open
source mac was released in mainline kernel tree). i am facing a crash
with sysfs_create_fs where BUG_ON(!kobj || !kobj->dentry || !name);
statement is getting hit and system is crashing. Can anyone point out
where should i initialize kobject file system in context of open
source mac.

Any help is much appreciated.

Thanks

bharat
