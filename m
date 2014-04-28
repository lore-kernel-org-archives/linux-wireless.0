Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:61454 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635AbaD1Ovc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 10:51:32 -0400
Received: by mail-oa0-f44.google.com with SMTP id n16so7359472oag.31
        for <linux-wireless@vger.kernel.org>; Mon, 28 Apr 2014 07:51:31 -0700 (PDT)
Received: from larrylap2.site (cpe-69-76-245-152.kc.res.rr.com. [69.76.245.152])
        by mx.google.com with ESMTPSA id su13sm74402618oeb.9.2014.04.28.07.51.30
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 28 Apr 2014 07:51:30 -0700 (PDT)
Message-ID: <535E6AF2.1000608@lwfinger.net> (sfid-20140428_165136_341338_68DEC83C)
Date: Mon, 28 Apr 2014 09:51:30 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Driver for RTL8192EE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are apparently a lot of Lenovo T440s laptops in the wild. In fact, I have 
had enough requests for the patches to add driver r8192ee to the staging tree, 
that I am making it available on my FTP site.

To obtain this driver, download the following two files:

http://www.lwfinger.com/realtek_drivers/0001-staging-r8192ee-Add-new-driver.patch
http://www.lwfinger.com/realtek_drivers/0002-staging-r8192ee-Add-new-driver.patch

Use these two files, in turn, to modify the standard 3.14.X or 3.15.0-rcX code 
for this device. Then build a custom kernel for your computer.

I am presently testing a modified version of this code that uses the standard 
rtlwifi structure, and hope to have it ready for submission in time for kernel 3.16.

Larry
