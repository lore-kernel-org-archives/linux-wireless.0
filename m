Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm2.bullet.mail.ird.yahoo.com ([77.238.189.59]:21933 "HELO
	nm2.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754184Ab1CRFS1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 01:18:27 -0400
Message-ID: <813132.20275.qm@web29506.mail.ird.yahoo.com>
Date: Fri, 18 Mar 2011 05:18:25 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: rtl8187b throughput-related regression in 2.6.35.x fixed in 2.6.37.x
To: Larry Finger <Larry.Finger@lwfinger.net>, herton@mandriva.com.br
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry/Herton/John,

There appears to be some kind of throughput related regression in 2.6.35.x (11-85-ish fedora, current long-term maintainance kernel) which is fixed by putting compat-wireless 2.6.37.x (4) on. I just thought I should mention this, in case somebody files a bug about rtl8187(b) being too slow, that putting compat-wireless on might help.

My AP machine was out for almost a year so I have not been using my rtl8187b for a while. When I finally got that fixed, after a while I noticed the throughput between the two machines was low (60KB/s, or 0.5Mb/s, although iwconfig says rate=11Mb/s, etc). Putting compat-wireless on gets me back the throughput I expect from a year ago (400KB/s+ onwards, or a few Mb/s at least). So 2.6.31.x a year ago was okay, 2.6.37.x is okay, but there appear to be something not quite right with 2.6.35.x in the middle. There are too many changes, and it is probably not important since current-ish kernel head is okay.

Regards,
Hin-Tak


      
