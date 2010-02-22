Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54723 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0BVNCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 08:02:04 -0500
Received: by fg-out-1718.google.com with SMTP id e21so335657fga.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2010 05:02:02 -0800 (PST)
Message-ID: <4B828048.7020303@googlemail.com>
Date: Mon, 22 Feb 2010 14:02:00 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Main documentation on ath9k+802.11n
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi linux-wireless list,
hi hostap list!

I am trying to get a 802.11n-network as test running. I want to test the
highest throughput, that I can do with this setup to see, what could be
possible for me.

My setup is a Senao EMP-7605 card and ath9k with a 2.6.32.8-kernel.
Thanks to Jouni Malinen, I am now using the latest snapshot of
hostapd-0.6.10. If I start hostapd, my Lenovo Thinkpad(I think, there is
an Intel card running inside there) can find the network, that I
established with ath9k, but another Senao EMP-7905 with the same setup
as mentioned above won't find the wireless network at all, even during a
scan. If I do an iperf between the Lenovo and the board, that runs the
AP with hostapd, I get throughput rates of about 6 Mbit/s. iwconfig on
the Lenovo shows the bitrate set to "0" - meaning auto.

I cannot find valuable documentation about setting up a wireless-link
with ath9k using 802.11n-capabilities. Is there any hint, that someone
could give me or a webpage that I could be pointed to? I just want to do
some speed-tests, but even the "ht_kapab"-field of hostapd leaves me
without any knowledge, what to put in there...

Any help would be appreciated!

Very kind regards,
Dennis Borgmann
