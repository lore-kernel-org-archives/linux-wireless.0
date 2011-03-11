Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47442 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1CKVRZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 16:17:25 -0500
Received: by wya21 with SMTP id 21so2821465wya.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 13:17:23 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Mar 2011 15:17:23 -0600
Message-ID: <AANLkTi=de0vzqA-+CpmK1V88Ypj6TN4C+a4j4=KiyTJX@mail.gmail.com>
Subject: Unusual saw-wave like ping times from linux wireless AP to MacBook
 Pro, iPhone
From: =?ISO-8859-1?Q?Chris_Dos=E9?= <chris.dose@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have a ubuntu 10.04 based wireless router running hostapd 0.7.3, the
latest compat-wireless ath9k.  The same experiments were tried using
hostapd 0.6.9 and ath9k from 2.6.32 and 2.6.35 as well.  also, hostapd
was tried in g mode and n mode, with wpa/wpa2 on and off, and with
high throughput on and off. I always get the same (or similar)
results.

The symptoms are like this: pinging a macbook pro, or an iphone, from
the AP results in an almost perfectly regular saw-wave like pattern.
The ping time starts at 50ms, steadily rises every subsequent ping
until it reaches somewhere over 200ms, then abruptly resets back to
50ms, and rises again.  Graphing it in excel shows it is strangely
very precise.  Between all the different version I've tried, I've seen
slight variations on this, running the latest versions of everything
now it seems like it starts closer to 1ms and rises to 200ms then
starts over.

Pinging another wireless device on my network (an HP wireless printer)
results in very fast, steady 5ms ping times.  So it's not ALL wireless
clients, just some.  In this case it seems apple products, but I have
nothing else currently to test with.

Pings look like this:
http://tinypaste.com/9dc704

Two graphs I made:
http://imagebin.org/142438
http://imagebin.org/142439

daemon.log: http://tinypaste.com/7a452e
dmesg: http://tinypaste.com/1cbe32
kern.log: http://tinypaste.com/cd1a1

lspci for my wireless card:
00:0e.0 Network controller: Atheros Communications Inc. AR922X
Wireless Network Adapter (rev 01)

If I can supply any more information, please let me know what.
