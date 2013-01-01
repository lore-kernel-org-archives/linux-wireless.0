Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm14-vm0.bullet.mail.ird.yahoo.com ([77.238.189.193]:43582 "EHLO
	nm14-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932Ab3AAAQ1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Dec 2012 19:16:27 -0500
Message-ID: <1356999385.78279.YahooMailClassic@web172301.mail.ir2.yahoo.com> (sfid-20130101_011633_447843_71F4462D)
Date: Tue, 1 Jan 2013 00:16:25 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: rtl8187 WARN slowpath on suspend with 3.6.11 
To: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@canonical.com>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Does either Larry or Herton see the sort of behavior (https://bugzilla.redhat.com/show_bug.cgi?id=891019) on suspend? John, is there anything changed between 3.6.9 and 3.6.11 which would cause this?

Other than a genuine kernel regression, it is possible that it might be fedora specific - I just went from F17 to F18. F18 seems to have an systemd integrated udevd which might behaves differently from the older udevd's... or general funniness with F18 (I noticed another bug https://bugzilla.redhat.com/show_bug.cgi?id=891018 but that might be unrelated).

Anyway, other than whole sale downgrade I think I can try booting 3.6.9 (which suspended cleanly under F17) and see whether it is a F18-specific problem.

Hin-Tak
