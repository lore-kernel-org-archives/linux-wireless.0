Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kraftzwerg.no-carrier.info ([87.98.242.129]:44064 "EHLO
	mail.no-carrier.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbaEWIuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:50:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.no-carrier.info (Postfix) with ESMTP id 34A17204492
	for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:44:04 +0200 (CEST)
Received: from mail.no-carrier.info ([127.0.0.1])
	by localhost (mail.no-carrier.info [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 3V71xiKhlFGn for <linux-wireless@vger.kernel.org>;
	Fri, 23 May 2014 10:43:53 +0200 (CEST)
Received: from [192.168.1.130] (p5490C414.dip0.t-ipconnect.de [84.144.196.20])
	(Authenticated sender: mail@marc-stuermer.de)
	by mail.no-carrier.info (Postfix) with ESMTPA id 74F442041D9
	for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 10:43:53 +0200 (CEST)
Message-ID: <537F0A21.5070102@marc-stuermer.de> (sfid-20140523_105028_893243_58CA2462)
Date: Fri, 23 May 2014 10:43:13 +0200
From: =?ISO-8859-15?Q?Marc_St=FCrmer?= <mail@marc-stuermer.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Rtl8192CU: regular disconnect in managed mode after a short while
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

I've recently bought myself an USB device, based on the RTL8192CU 
chipset, running under 64bit kernel 3.15.0-rc6 at the moment.

Firmware is installed where it should be.

Debuglog of the kernel is here: http://pastebin.com/Eh6pBbra

The problem is this: I am running the device in managed mode and let it 
connect to my AP.

First all works as intended, but after a short while the device always 
stops working altogether.

No output in the kernel log, not even about deauthenticating but it just 
stops working at all, no traffic anymore, I've got to unplug it or 
unload and reload the driver and then the same starts all over again.

This seems to be a long lasting regression 
(https://www.google.com/#q=linux+rtl8192cu+disconnects+linux+) and 
there's also a repository on Github containing the original Realtek 
driver ported up to kernel version 3.11 
(https://github.com/pvaret/rtl8192cu-fixes), because the kernel driver 
seemed to be not working flawlessly until then.

So my question is: what else could/should I do to get a stable, working 
wifi connection with that device on my linux box that lasts more than 
just a few minutes?

Thanks in advance.
