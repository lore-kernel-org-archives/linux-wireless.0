Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailsender.cdac.in ([196.1.113.117]:40477 "EHLO
	mailsender.cdac.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbDOExZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 00:53:25 -0400
Received: from ims.pune.cdac.in (ims.pune.cdac.in [10.208.1.15])
	by mailsender.cdac.in (8.14.2/8.14.2) with ESMTP id t3F4eBTJ029447
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2015 10:10:16 +0530
Received: from mailgw.pune.cdac.in ([10.208.1.4])
	by ims.pune.cdac.in (8.14.4/8.14.4) with ESMTP id t3F4dsDP014394
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2015 10:09:54 +0530
Received: from [10.244.11.15] ([196.12.45.164])
	(authenticated bits=0)
	by mailgw.pune.cdac.in (8.14.2/8.13.8) with ESMTP id t3F4drNS023225
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2015 10:09:54 +0530
Message-ID: <552DEB98.2000301@cdac.in> (sfid-20150415_065328_722568_C0959786)
Date: Wed, 15 Apr 2015 10:09:52 +0530
From: Raghavendra <arrao@cdac.in>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Set wireless channel busy
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am developing a module which adds the support for IEEE 1609.4 for 
WAVE(Wireless Access for vehicular environments) in mac80211. One of the 
specifications of 1609.4 is channel access in alternate fashion, i.e. I 
need to switch between two channels alternatively, giving 50ms to each 
of the channel.

For the switching, the document suggests a guard band of 4ms, where in 
which I need to make sure that no transmissions are taking place during 
the guard band. Now my question is: How do I suspend the 
transmissions(although, the packets could be queued and the reception 
could remain on) of a wlan device for a certain amount of time?

Thanks and Regards,
Raghavendra

-------------------------------------------------------------------------------------------------------------------------------
[ C-DAC is on Social-Media too. Kindly follow us at:
Facebook: https://www.facebook.com/CDACINDIA & Twitter: @cdacindia ]

This e-mail is for the sole use of the intended recipient(s) and may
contain confidential and privileged information. If you are not the
intended recipient, please contact the sender by reply e-mail and destroy
all copies and the original message. Any unauthorized review, use,
disclosure, dissemination, forwarding, printing or copying of this email
is strictly prohibited and appropriate legal action will be taken.
-------------------------------------------------------------------------------------------------------------------------------

