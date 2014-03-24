Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:65341 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902AbaCXNtR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 09:49:17 -0400
Received: by mail-wg0-f48.google.com with SMTP id l18so3389651wgh.31
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 06:49:16 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 24 Mar 2014 19:19:16 +0530
Message-ID: <CADNhdGFmM09hb_EhJ3dHB0r0t+YJic7zH3T9Av24sjZjd1zmQA@mail.gmail.com> (sfid-20140324_144931_843534_F5CFE087)
Subject: mac80211: WPA2-PSK encrypted packet Rx issue
From: shankar swaminathan <shankswa@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have an AP with ath9k drivers that completes 4-way handshake and
generates PTK using CCMP and  WPA-PSK with a client.

A ping from the wired side to the client (through the AP) reaches the
client as an encrypted packet (confirmed through a wireless capture).
The client also sends an encrypted response.
However, the response does not seem to reach the AP.

I have a function registered through dev_add_pack() in my kernel
module. However the function never seems to be hit.

Is there some configuration that is required in the Rx path of the AP
in the mac80211 driver that needs to be done?

Kindly help.

regards,
-shankar
