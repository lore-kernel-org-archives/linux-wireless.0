Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay.ptn-ipout02.plus.net ([212.159.7.36]:49576 "EHLO
	relay.ptn-ipout02.plus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbZL1MaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Dec 2009 07:30:17 -0500
Received: from [87.114.88.98] (helo=mayos.plus.com)
	 by relay02.plus.net with esmtp (Exim) id 1NPEaX-0006Ax-1I
	for linux-wireless@vger.kernel.org; Mon, 28 Dec 2009 12:20:41 +0000
Message-ID: <4B38A298.7070103@googlemail.com>
Date: Mon, 28 Dec 2009 12:20:40 +0000
From: Chris Mayo <aklhfex@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: staging: No option to select rtl8192su in linux-2.6.33-rc2
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you have no other wireless drivers selected then RealTek RTL8192SU
does not show up in menuconfig for staging.

rtl8192su needs the "select WIRELESS_EXT" fix for "wext: refactor"?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=3d23e349d807177eaf519d444677cee86b1a04cf

as done for some in:
http://git.kernel.org/?p=linux/kernel/git/gregkh/staging-2.6.git;a=commitdiff;h=125b181aec7a67c71234284ecf6d9c729d05deda


Also:
rtl8192u, wlan-ng, wlags49_h2(?)

