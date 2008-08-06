Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61868 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757253AbYHFCqD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 22:46:03 -0400
Message-ID: <4899106A.9060103@lwfinger.net> (sfid-20080806_044609_132085_8CEB38B2)
Date: Tue, 05 Aug 2008 21:46:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Future handling of AR5416
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In my helping with wireless on the openSUSE Forums, I recently tried to help a 
user with an AR5416 (Vendor ID 168c, PCI ID 0023). The user has kernel 2.6.25.11 
and gets the "Device not yet supported." message. By looking at the code, I see 
that same situation still exists in wireless-testing.

So that I may advise the OP accurately, will this chip be supported in the near 
future, or should I recommend that he use ndiswrapper?

Larry
