Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hapkido.dreamhost.com ([66.33.216.122]:57568 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbYLPLHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Dec 2008 06:07:24 -0500
Received: from homiemail-a1.g.dreamhost.com (sd-green-bigip-207.dreamhost.com [208.97.132.207])
	by hapkido.dreamhost.com (Postfix) with ESMTP id C2FFB17C0E5
	for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 03:07:23 -0800 (PST)
Received: from [192.168.1.65] (host-84-221-209-190.cust-adsl.tiscali.it [84.221.209.190])
	by homiemail-a1.g.dreamhost.com (Postfix) with ESMTP id 3767A119E1E
	for <linux-wireless@vger.kernel.org>; Tue, 16 Dec 2008 03:05:51 -0800 (PST)
Message-ID: <49478B8E.7050906@iacchi.org> (sfid-20081216_120728_487006_CC709CAE)
Date: Tue, 16 Dec 2008 12:05:50 +0100
From: iacchi <registrazioni@iacchi.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Kernel panic while loadind ipw2200 module
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I don't know if I shoul report this error (bug?) here or to kernel 
bugzilla, but let's try here first!
First of all, this: http://bugzilla.kernel.org/show_bug.cgi?id=12234 is 
what I tried to do before looking at compat-wireless and since it wasn't 
working, I tried with compat-wireless.
I made to tries with compat-wireless, version 2008-12-10 and 2008-12-11. 
In the first try I used the default config.mk (except 
CONFIG_MAC80211_LEDS set to "n" because it gave me problems compiling), 
the second one compiling only the ipw2200 driver (I don't need all the 
others!).
In both tries, I was able to "make" and "make install" it, but during 
"make load" the kernel panics and it doesn't reboot (I can take a 
picture of the error). In the second try, make load was triing to load 
ipw2100, too, giving a fatal error because I didn't compile it (I don't 
need it!).

The console output of make load is something like:
loading ipw2100
loading ipw2200

and then the kernel panic.

Is this a peculiar problem of mine or a module problem? If the first is 
true, may you help me?

thanks,
Iacopo
