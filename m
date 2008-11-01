Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:45783 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbYKAObd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 10:31:33 -0400
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA1EVSRP027313
	for <linux-wireless@vger.kernel.org>; Sat, 1 Nov 2008 16:31:30 +0200
Received: from tikku (essapo-nirac252172.europe.nokia.com [10.162.252.172])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA1EVRlI032251
	for <linux-wireless@vger.kernel.org>; Sat, 1 Nov 2008 16:31:27 +0200
To: linux-wireless@vger.kernel.org
Subject: Michael MIC failures in AP mode?
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 01 Nov 2008 16:31:26 +0200
Message-ID: <87wsfnldq9.fsf@nokia.com> (sfid-20081101_153138_893209_47C4FC8F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Now that AP mode works in mac80211 I want to use it to test Michael
MIC failures in a wlan driver. Any recommendations, or tips, how to
easily create them with mac80211 and hostapd?

-- 
Kalle Valo
