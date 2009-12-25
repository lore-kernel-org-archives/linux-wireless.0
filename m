Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mis15.de ([93.186.196.60]:43794 "EHLO mis15.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004AbZLYUeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2009 15:34:10 -0500
Message-ID: <4B351F3C.70104@fitzenreiter.de>
Date: Fri, 25 Dec 2009 21:23:24 +0100
From: Arne Fitzenreiter <arne@fitzenreiter.de>
MIME-Version: 1.0
To: mcgrof@winlab.rutgers.edu, linux-wireless@vger.kernel.org
Subject: compat-2.6: The included usbnet modul produle oops with other usb
 lan drivers.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

i have added the compat-wireless-stable-2.6.32.2 module to a kernel
2.6.27.42
If i try to use the asix or moschip7830 modul (both include usbnet.h)
the system crash after bringing the ethernet device up.
The usbnet.h in compat wireless remove the stats from the netdev struct.
I think this triggers this problem but im not sure.
I have worked arounnd this by rebulding the modules that use usbnet
within the compat wireless build.
This should be checked and fixed.

Thanx in advance.

Now something complete different:
Merry Xmas at all.
-- 

Arne Fitzenreiter



