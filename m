Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:49070 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbZB1AQ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:57 -0500
Received: by ewy25 with SMTP id 25so1545480ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 16:16:53 -0800 (PST)
Date: Sat, 28 Feb 2009 01:13:49 +0100
From: "Christoph .J Thompson" <cjsthompson@gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: D-Link GWL-122 and AP/WPA2
Message-Id: <20090228011349.bf8ab119.cjsthompson@gmail.com> (sfid-20090228_011659_895007_F3FFF3BB)
In-Reply-To: <3ace41890902270734v5a70ffb6x3b797c25a51734c9@mail.gmail.com>
References: <20090226223155.d2d40946.cjsthompson@gmail.com>
	<3ace41890902270734v5a70ffb6x3b797c25a51734c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Feb 2009 15:34:48 +0000
Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> Sorry to hear about your misfortune... can I ask if the F5D7050 works
> well with the in-kernel rtl8187 driver in STA mode?

Well I can't be sure, because I don't have a known working AP here. That's what I'm trying to build. I have a PCMCIA rt2x00 (RT2561/RT61) based wireless card on a laptop running 2.6.29-rc6. It should work as an AP (at least that's what 'iw dev wlan0 info' advertises). I installed hostapd 0.6.8, configured it to not hide the SSID. If I do 'iwlist scan' on the router with the Belkin USB wifi dongle with the Realtek chip on it, I can see the wireless networks of some neighbors, but not the AP I just configured on the laptop. The router also runs 2.6.29-rc6. So it's like a chicken and egg problem.


-- 
Christoph .J Thompson <cjsthompson@gmail.com>
