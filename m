Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48768 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbZLLKSc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 05:18:32 -0500
Received: by ewy19 with SMTP id 19so1850588ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2009 02:18:38 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 12 Dec 2009 21:18:38 +1100
Message-ID: <157c4da70912120218lc53633bk62fc9ee99377a231@mail.gmail.com>
Subject: mac80211 noob question
From: VN <vnik5287@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,
I've recently started hacking mac80211/ath5k in order to implement my
idea of cooperative relaying. I had a good look at the mac80211 code
and couldn't find anything that deals with ACKing... or is it done in
firmware and some flag is set to indicate that the frame has been
acknowledged? What I'm trying to achieve right now is to receive a
data frame while in monitor mode (e.g. ieee80211_rx_start_monitor())
and then check if it has been acknowledged by the destination node.
would be very grateful for any tips!
