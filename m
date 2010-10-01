Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:60870 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab0JAUaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 16:30:05 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1P1mF1-00020e-Td
	for linux-wireless@vger.kernel.org; Fri, 01 Oct 2010 22:30:03 +0200
Received: from 188.93.190.223 ([188.93.190.223])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 22:30:03 +0200
Received: from sorngard by 188.93.190.223 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 01 Oct 2010 22:30:03 +0200
To: linux-wireless@vger.kernel.org
From: Eddy Sorngard <sorngard@online.no>
Subject: Bug in p54usb (master mode)?
Date: Fri, 1 Oct 2010 19:32:33 +0000 (UTC)
Message-ID: <loom.20101001T212648-19@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have succeded in using the driver p54usb (device DWL-g120) + hostapd in 
master mode connected to an usb2 port. However when I connect the device to an 
usb1 port, it is not transmitting in master mode. No errors reported in dmesg 
or syslog, and the LEDs are dark. In ad-hoc or managed mode this problem does 
not exist. Is this due to a bug in the driver? I am using kernel 2.6.35.2, but 
I had the same problem in 2.6.31.

