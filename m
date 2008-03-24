Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx01.sadecehosting.com ([77.92.152.20]:33395 "EHLO
	mx01.sadecehosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbYCXKQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2008 06:16:38 -0400
Message-ID: <47E77D68.5060904@symbolengine.com> (sfid-20080324_101642_639002_DE725406)
Date: Mon, 24 Mar 2008 12:07:36 +0200
From: Jim Qode <jim-bug@symbolengine.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: B43 driver - severely reduced range
Content-Type: text/plain; charset=ISO-8859-9
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am moving this bug upstream from ubuntu launchpad:

Bug description

Binary package hint: b43-fwcutter

Kubuntu Hardy 8.04 Beta installed on Compaq V5204NR

Wifi chipset is Broadcom 4311. While the B43 driver works, the range
seems to be severely effected. On version 7.10 using ndiswrapper, I am
able to use my laptop throughout my entire house without problems. On
8.04 using B43, i am unable to use the laptop more than about 50 feet
from the router. I have two routers side by side, operating on different
channels broadcasting different SSID. One doesnt even show up in the
next room, the other shows but cant connect.

The problem seems to be isolated to the B43 driver, as it works
flawlessly with ndiswrapper.

One more thing, I cannot get ndiswrapper to work properly in 8.04, even
after blacklisting B43 and ssb.

-----

I am also experiencing the same problem with bcm4312 rev 1 card on Dell
xps m1330. Wifi-radar shows ap's constantly switching from 0/10 signal
to 10/10. iwlist scanning show a different set of ap's apparently
randomly each time. This does not seem to be a hardware issue as I can
capture beacon signals from very far away ap's using kismet.

I can connect to my home wireless network when I am really close (5-6m
at most).

