Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173003pub.verizon.net ([206.46.173.3]:59063 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078Ab0KISTV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 13:19:21 -0500
Received: from [192.168.1.6] ([unknown] [173.66.155.143])
 by vms173003.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0LBM00II5QVRA3A0@vms173003.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 09 Nov 2010 12:19:03 -0600 (CST)
Message-id: <4CD99096.5020105@verizon.net>
Date: Tue, 09 Nov 2010 13:19:02 -0500
From: Clyde McPherson <ccmcphe@verizon.net>
MIME-version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Wireless and RFKILL
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I build and use the compat-wireless source for use with SBC 
applications, and I have a question about the wireless portion of the 
code. Our SBCs do not have RFKILL capabilities, and since we use 
wireless we are forced to include it in our kernel due to the depends in 
wireless. What are the chances of adding #ifdef's for CONFIG_RFKILL on 
the code segments that require RFKILL, this way integrators like myself 
would not need to load and/or build the rfkill modules? This would also 
save us memory and storage that is limited on a SBC system.


Thanks much
Tex

