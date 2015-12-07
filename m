Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36493 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbbLGTBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2015 14:01:48 -0500
Received: by qkcb135 with SMTP id b135so28410041qkc.3
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2015 11:01:48 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Dec 2015 16:01:47 -0300
Message-ID: <CAKCMXx2ZAT8QMgs6g4ryxNQ2jiZ9-JmSiS+fOWCpX0Vz+xLEug@mail.gmail.com> (sfid-20151207_200151_726825_B4FFED6E)
Subject: brcmsmac: signal lost after connecting to AP
From: Ivan Castellucci Vidal <ivanc.vidal@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone!

This is my first post so if I forget about anything I hope you can
help me make this useful for everyone.
Currently I own a Laptop which comes with a Broadcom BCM4313 WLAN
card. I'm in a far place from the AP but I still have enough signal to
watch HD videos on YouTube most of the time, but from time to time
signal fades because of environment factors.

What I've observed is that if I keep pinging the AP it replies unthil
signal fades, then I reconnect to the network and ping shows replies
for at least one packet and it can work for a couple more sometimes.
That makes me think the WLAN card and the AP have enough power to keep
working between each other despite of the distance but something makes
the card go in a low-power mode or something because signal
immediately drops and stop replying.

Did it happened to anyone else? Is it a known bug or feature (maybe a
regulatory feature) ?

Anyhow, if you need any information just let me know, the AP is a
TP-LINK router and it works with my phone for even longer distances.
BTW: I have a decent C programming background and I can help with
anything you need with the only detail of time being a constraint
sometimes.

Thanks in advance

--
Iván Castellucci Vidal
