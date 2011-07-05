Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61451 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab1GEKic (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 06:38:32 -0400
Received: by bwd5 with SMTP id 5so4638557bwd.19
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jul 2011 03:38:31 -0700 (PDT)
Message-ID: <4E12E9A3.2070004@googlemail.com> (sfid-20110705_123835_906394_23BEA469)
Date: Tue, 05 Jul 2011 12:38:27 +0200
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [ath9k,hostapd]Connection broken after some time...
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

After asking several times on the IRC without getting any answer, I'll 
try to use this way of asking my question.

I am using wpa_supplicant 0.7.3 and hostapd in version 0.7.3 with a very 
simple TKIP encryption on ath9k. After some time, the machine running 
wpa_supplicant still states after "iw dev wlan0 link", that it's still 
connected, the machine running hostapd states after "iw dev wlan0 
station dump" that no device would be connected. I can't ping from 
either side. Sniffing on a third machine with a monitor card and 
wireshark shows deauthentication packets from the hostapd-machine after 
each frame sent by the wpa_supplicant machine. Given reason in the 
deauth-frames is "packet received from non-authenticated client".

Any idea, what might be the problem?

Best regards,
Dennis
