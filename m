Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:58195 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab2AWQ7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 11:59:20 -0500
Received: by lahc1 with SMTP id c1so1744335lah.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 08:59:19 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 23 Jan 2012 11:59:18 -0500
Message-ID: <CALY7HC+gbzBmYJK3qQ0aMip_z6utA9jq2ZU6LtDrWpUOGn03CQ@mail.gmail.com> (sfid-20120123_175924_025189_283AB701)
Subject: frustrated by carl9170
From: Brad Bellomo <bvbellomo@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a NetGear wireless n draft dongle that uses the carl9170 driver
on an Arch system.  This module works for anywhere from several
minutes to several hours.  Then I have lose all ability to use TCP/IP
over my wireless until I modprobe -r carl9170, modprobe carl9170, and
reconnect my network.  Although ar9170usb worked fine, I would rather
troubleshoot this than revert to a deprecated driver, or at worst
case, buy a better supported device.  I do not see anything relevant
in my dmesg log.  Does this device log errors somewhere else?  Is
carl9170 actively being developed?  I don't mind digging into code
myself, but if no one is working on carl9170, I would rather buy new
hardware (recommendations appreciated) than spend time fixing
something with no future.
