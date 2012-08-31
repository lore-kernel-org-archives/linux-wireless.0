Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62130 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab2HaBCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2012 21:02:54 -0400
Received: by pbbrr13 with SMTP id rr13so4025895pbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2012 18:02:54 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Aug 2012 19:02:54 -0600
Message-ID: <CAMLZHHTtJZZ4a0MJAUTPdwgdEX4zcSmR8ZU57bjwAF1ksre+5A@mail.gmail.com> (sfid-20120831_030347_073820_3624EB86)
Subject: linux-firmware updates for Marvell wifi
From: Daniel Drake <dsd@laptop.org>
To: ben@decadent.org.uk, David Woodhouse <dwmw2@infradead.org>
Cc: Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Please pull from git://dev.laptop.org/users/dsd/linux-firmware (master
branch) to receive 2 firmware updates for Marvell wifi hardware
shipped in OLPC laptops:

commit bac3567cdb38d5cfcf3045718618026d60478d05
Author: Daniel Drake <dsd@laptop.org>
Date:   Thu Aug 30 18:19:45 2012 -0600

    Marvell SD8787: update to v14.66.9.p96

commit 6a08d149c162cbca574f9e586b2c2f46beb866ac
Author: Daniel Drake <dsd@laptop.org>
Date:   Thu Aug 30 11:31:06 2012 -0600

    Marvell SD8686: update to v9.70.20.p0

Thanks
Daniel
