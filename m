Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:60925 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab3BRTeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 14:34:20 -0500
Received: by mail-la0-f41.google.com with SMTP id fo12so5826568lab.28
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 11:34:19 -0800 (PST)
MIME-Version: 1.0
From: Markus Ulfberg <jag@markusulfberg.se>
Date: Mon, 18 Feb 2013 20:33:59 +0100
Message-ID: <CACNBsWgOu3xFS+kV7-C5rWW0hvTtVgweCJpmacppKWwU7mpREQ@mail.gmail.com> (sfid-20130218_203425_163932_F0BEBFE1)
Subject: Prism54 issues after kernel upgrade
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently upgraded from Debian Lenny to Squeezy and noticed that the
prism54 driver started spitting out these messages in the syslog:
Feb  1 23:05:23 lappy586 kernel: [  789.291198] p54pci 0000:01:00.0:
rx'd frame size exceeds length threshold.
Feb  1 23:05:23 lappy586 kernel: [  789.292165] p54pci 0000:01:00.0:
rx'd frame size exceeds length threshold.
Feb  1 23:05:23 lappy586 kernel: [  789.297478] p54pci 0000:01:00.0:
rx'd frame size exceeds length threshold.

Well actually I noticed because this is usually followed by a dropped
connection for all my wireless devices in the house.

I'm running kernel: 2.6.32-5-486 from the debian repositories.
My wireless device is the 3Com OfficeConnect Wireless 11g PC Card (3CRWE154G72)

As far as I know this worked fine until I updated the kernel, if
memory serves me right I was running something like 2.6.24...

I'll be happy to provide more information if you require,


Thanks for providing a driver for my card. I really appreciate all the
effort you have put into it!

Best regards
Markus Ulfberg
