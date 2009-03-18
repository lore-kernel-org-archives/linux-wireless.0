Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:33557 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZCRRlK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 13:41:10 -0400
Received: by ewy24 with SMTP id 24so139625ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2009 10:41:07 -0700 (PDT)
Message-ID: <49C12DFA.80308@giuppi.com> (sfid-20090318_184113_567224_DC41B555)
Date: Wed, 18 Mar 2009 18:23:06 +0100
From: "Info[at]Giuppi" <info@giuppi.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: rtl8187 bug report
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a rtl8187B usb dongle, works pretty well with new driver rtl8187.
Thanks for the great job you're doing.

The problem comes when I try to handle my WEP protected network in
monitor mode.
It becomes really slow in finding/showing the network and when it
appears in the list, no activity
is detected. I mean beacons or data remains at 0 in the airodump-ng
screen (from latest svn aircrack-ng suite)

Everything works fine in managed mode and the network is easily detected
and i can connect too.

I also have a rt73usb device and this one works as expected.

I'm currently using ubuntu-backport modules but I've also tryed the
compat-wireless package dated 17 march
kernel version 2.6.27-13-generic

