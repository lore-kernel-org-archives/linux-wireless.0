Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp109.rog.mail.re2.yahoo.com ([68.142.225.207]:37952 "HELO
	smtp109.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753682AbYEGBJz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 21:09:55 -0400
Message-ID: <4820FFCD.7060905@rogers.com> (sfid-20080507_030906_566030_E7D466A5)
Date: Tue, 06 May 2008 21:03:09 -0400
From: Fred Odendaal <freshshelf@rogers.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: at76_usb driver for WUSB11 v.26 wireless adapter doesn't work for
 kernels newer than 2.6.24.3-12.fc8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a bug report for this here: 
https://bugzilla.redhat.com/show_bug.cgi?id=438606

Essentially, this driver used to work, but no longer does. The driver 
doesn't seem to be able to communicate signal level and link quality.

If someone needs me to test a fix for this, or to try test loads I'm 
willing to help.

regards,
Fred Odendaal


