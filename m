Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173021pub.verizon.net ([206.46.173.21]:52254 "EHLO
	vms173021pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbaKDTiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 14:38:46 -0500
Received: from [192.168.1.2] ([108.28.174.148]) by vms173021.mailsrvcs.net
 (Oracle Communications Messaging Server 7.0.5.32.0 64bit (built Jul 16 2014))
 with ESMTPA id <0NEJ001PK2EXPI80@vms173021.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 04 Nov 2014 12:37:46 -0600 (CST)
Message-id: <54591CF9.7030106@verizon.net> (sfid-20141104_203850_228702_C706EE9A)
Date: Tue, 04 Nov 2014 13:37:45 -0500
From: "C. McPherson" <ccmcphe@verizon.net>
MIME-version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@radiotap.org
Subject: Vendor Namespace Question
Content-type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all:
I was just trying to use the latest stable backports-3.18-rc1-1 and I 
noticed that there is no longer structure members in the 
ieee80211_rx_status structure for Vendor namespace information?  In my 
backports 3.14 version I used them to add some register information to 
the radiotap header in the lab. How does one use the vendor name space 
without those structure members?

Thanks for you assistance
Clyde


