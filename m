Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:48426 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1AVVBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Jan 2011 16:01:52 -0500
Message-ID: <4D3B4057.5000206@t-online.de>
Date: Sat, 22 Jan 2011 21:38:47 +0100
From: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k prevents CPU from entering C4 state (kernel 2.6.37 regression)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I noticed that from kernel 2.6.37 on (i've tested 2.6.38-rc2, too) ath9k 
prevents my CPU (Intel Atom N450) from entering the C4 power state. It 
only goes down to C2 (there's no C3) instead. In 2.6.36(.3) everything 
is still fine. The CPU will only go down to C4 with 2.6.37 when the 
wireless interface is brought down.

used wireless device:
05:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)

-- 
Regards,
Richard Schütz
