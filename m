Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:57384 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141AbYKIPoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2008 10:44:10 -0500
Received: from vaebh105.NOE.Nokia.com (vaebh105.europe.nokia.com [10.160.244.31])
	by mgw-mx06.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id mA9Fi6De030533
	for <linux-wireless@vger.kernel.org>; Sun, 9 Nov 2008 17:44:07 +0200
Received: from localhost.localdomain (essapo-nirac252197.europe.nokia.com [10.162.252.197])
	by mgw-int02.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id mA9Fi1i5014022
	for <linux-wireless@vger.kernel.org>; Sun, 9 Nov 2008 17:44:03 +0200
From: Kalle Valo <kalle.valo@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211 dynamic powersave
Date: Sun,  9 Nov 2008 17:43:57 +0200
Message-Id: <1226245439-30329-1-git-send-email-kalle.valo@nokia.com> (sfid-20081109_164415_642287_B3572C33)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's my first version of dynamic powersave patches. I have tested them
only with stlc45xx on Nokia N810. Unfortunately stlc45xx's psm command is
buggy and I haven't been able to run any longer tests, yet. Next week I will 
also test with iwl3945.

These are RFC patches, not to be applied.

TODO:
o Johannes' subif_start_xmit suggestion
o test with intel hardware (only in-tree driver using IEEE80211_CONF_PS)
o disable power save when software scanning
o association check to the work structs?
o cancel_work_sync()


