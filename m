Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp86.iad3a.emailsrvr.com ([173.203.187.86]:56353 "EHLO
        smtp86.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755795AbdLOWGs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Dec 2017 17:06:48 -0500
Received: from smtp35.relay.iad3a.emailsrvr.com (localhost [127.0.0.1])
        by smtp35.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 017FB5D63
        for <linux-wireless@vger.kernel.org>; Fri, 15 Dec 2017 16:58:47 -0500 (EST)
Received: by smtp35.relay.iad3a.emailsrvr.com (Authenticated sender: forest-AT-forestbond.com) with ESMTPSA id CF9F65B48
        for <linux-wireless@vger.kernel.org>; Fri, 15 Dec 2017 16:58:47 -0500 (EST)
Date: Fri, 15 Dec 2017 16:58:47 -0500
From: Forest Bond <forest@forestbond.com>
To: linux-wireless@vger.kernel.org
Subject: Status of AP mode on RTL8188CU?
Message-ID: <20171215215846.GB14015@Forests-MacBook-Air.local> (sfid-20171215_230653_936426_33D01077)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am attempting to get AP mode working with an RTL8188CU device.  I'm using the
rtl8192cu driver from backports-4.2.6-1 with hostapd 2.6, but this doesn't seem
to be working.  I can provide details if needed, but for now I'd just like to
know if AP mode is supported using vanilla kernel drivers and hostapd?

Or should I be using these instead?

https://github.com/pritambaral/hostapd-rtl871xdrv
https://github.com/dz0ny/rt8192cu

Thanks,
Forest
-- 
Forest Bond
http://www.forestbond.com/
http://www.rapidrollout.com/
