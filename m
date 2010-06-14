Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:51421 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751050Ab0FNUu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:50:26 -0400
Message-ID: <4C169610.5020907@dlasys.net>
Date: Mon, 14 Jun 2010 16:50:24 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: CARL9170
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     I am trying to digest some things in the carl9170 firmware.

     Many routines are coded to look like interrupt handlers, but the 
code seems to be entirely polled ?
     Am I correct there ? If so do you know if the AR9170-fw code or 
something else might show an example of interrupt handling for the 
AR9170. I must have tx complete interrupts.

     Next there are remarks throught the driver and firmware regarding 
cookies.
     I think a cookie is a u8 that uniquely identifies a packet - is 
that correct ?
     In the firmware there is a remark somewhere that suguests that the 
cookie AND something else are needed - is that correct or is the cookie 
sufficient ?

     Thank you.



