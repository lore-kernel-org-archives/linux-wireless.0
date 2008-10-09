Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:42839 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185AbYJIQZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 12:25:14 -0400
Received: by fk-out-0910.google.com with SMTP id 18so79783fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 09 Oct 2008 09:25:13 -0700 (PDT)
Subject: iwl3945 randomly hangs system on boot
From: Yotam Benshalom <benshalom@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Thu, 09 Oct 2008 17:25:09 +0100
Message-Id: <1223569509.7723.10.camel@ubuntu> (sfid-20081009_182519_915749_31435666)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I am not a developer of any kind, but I wanted to draw your attention to
the problem described here:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/263059
The latest iwl3945 driver combined with 2.6.27.2 and above kernel hangs
the system randomly on boot. Removing the firmware or blacklisting the
driver solves it. Is there a workaround? Is this a driver issue or
kernel issue? And is this problem known and being taken care of?

Yours truly,
Yotam Benshalom

