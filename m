Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:58848 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbYK2QXP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 11:23:15 -0500
Received: from esebh107.NOE.Nokia.com (esebh107.ntc.nokia.com [172.21.143.143])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mATGNBGW020236
	for <linux-wireless@vger.kernel.org>; Sat, 29 Nov 2008 18:23:12 +0200
Received: from tikku (essapo-nirac25269.europe.nokia.com [10.162.252.69])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mATGN9QM023606
	for <linux-wireless@vger.kernel.org>; Sat, 29 Nov 2008 18:23:10 +0200
To: linux-wireless@vger.kernel.org
Subject: iwl3945 rate control broken in wireless-testing
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 29 Nov 2008 18:23:09 +0200
Message-ID: <87zljilcwi.fsf@nokia.com> (sfid-20081129_172322_241156_99456857)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

rate control in iwl3945 from wireless-testing seems to have been
broken for few weeks now, but I do not exactly when it exactly
happened because my ADSL connection is usually the bottleneck. 

If I set the rate manually (for example iwconfig wlan0 rate 54M)
correct rate is used, but with auto it doesn't rise from 1 Mbps. I
thought Larry's fix for the pid rate-setting algorithm (commit
d8dda0d5) would fix the problem, but that doesn't seem to be the case.

I'm using iwl3945 and latest wireless-testing (commit 3b329bc4a) on
Lenovo X60s running debian unstable 32bit. I don't have time to
investigate this further, but I can test patches.

-- 
Kalle Valo
