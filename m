Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f42.google.com ([209.85.219.42]:53138 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaBVFAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Feb 2014 00:00:16 -0500
Received: by mail-oa0-f42.google.com with SMTP id j17so3151551oag.15
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 21:00:16 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 21 Feb 2014 21:00:14 -0800
Message-ID: <CAC45b7kjErBZ=bZEnbsmdbXkEowQRtkkoN-obSxpn3cRLrCvwQ@mail.gmail.com> (sfid-20140222_060021_280703_A165C4EB)
Subject: RX laggy/choppy/stuck without TX on Intel Wireless 7260 with iwlwifi
From: Stephen Kent <smkent@smkent.net>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resending as plain text)

I have a strange issue with my Intel Wireless 7260 adapter on my Dell
XPS 13 (Haswell). It seems that packets are received but aren't
processed by the kernel or something until more packets are
transmitted. The net effect is that the laptop's wireless seems
somewhat choppy. I can demonstrate this by running something in a
remote ssh session that generates periodic output, and that output
doesn't appear until I generate more outgoing traffic. It's hard to
describe it beyond that, but I took a screen capture which
demonstrates this very well:
http://www.youtube.com/watch?v=4RMURSMszmc

lspci shows the wireless card as: 02:00.0 Network controller: Intel
Corporation Wireless 7260 (rev 6b)
uname -a: Linux dalek 3.11.0-12-generic #19-Ubuntu SMP Wed Oct 9
16:20:46UTC 2013 x86_64 x86_64 x86_64 GNU/Linux

I googled this without success. I can gather diagnostic information if
you send me instructions, I'm just not sure where to start or what to
look for. Is this a bug in the driver? Maybe in the card microcode
itself? Has anyone else reported this issue? It seems very strange.
Any help is appreciated.

Thanks,

Stephen
