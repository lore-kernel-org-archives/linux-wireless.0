Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53632 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249Ab1BRGEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 01:04:02 -0500
Received: by vxb37 with SMTP id 37so1693404vxb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Feb 2011 22:04:01 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 18 Feb 2011 07:04:00 +0100
Message-ID: <AANLkTi=o8r5wwZWjYtW2ubpnZ9q3NReZ5V3vGTQWjvdZ@mail.gmail.com>
Subject: RTL8192cu in Ad-Hoc mode
From: Juan Carlos Garza <juancarlosgarza@gmail.com>
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I patched compat wireless with the first patch you released in the
mailing list ( before the redesigns ), then cross compiled it with a
2.6.24  kernel, then installed it on the running 2.6.24 system.

I am using iwconfig and ifconfig to try to configure an Ad-Hoc
connection, and everything seems to work just fine (no errors on
configuration, and iwconfig and ifconfig show the expected
configuration information), however I am not able to detect this
Ad-Hoc network in any other computer. Do you know if Ad-Hoc mode
supported? Maybe there is a bug on the broadcasting of Ad-Hoc beacons.


Best regards,

Juan Carlos
