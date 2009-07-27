Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:35304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbZG0Mnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 08:43:32 -0400
Received: by fg-out-1718.google.com with SMTP id e21so812385fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 05:43:31 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 27 Jul 2009 14:43:31 +0200
Message-ID: <6ed49abf0907270543r7d8630bdu68177e9be6f6ae9c@mail.gmail.com>
Subject: hostapd and mac80211
From: Sibel Demirkol <sibel.demirkol@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
I am not a Linux expert and I have difficulty to understand the
message passing from kernel space to user space.
I use a PC Engines WRAP board and ath9k chip as an AP. I wanted to use
openWRT to install my packages and 2.6.28 kernel.
What I have difficulty to understand is, once a message received with
interrupt handler at ath9k driver, it is passed to mac80211 package
for mac processing (As I understood)? Then if I use hostapd for
example, how is it passed the message to hostapd deamon from mac80211
stack? I know about nl80211 link class and cfg80211.. But could you
explain me where the code lies for these message passings?
