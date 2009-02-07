Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:61499 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbZBGLUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2009 06:20:46 -0500
Received: by bwz5 with SMTP id 5so230371bwz.13
        for <linux-wireless@vger.kernel.org>; Sat, 07 Feb 2009 03:20:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090207071701.21485.18763.stgit@tikku>
References: <20090207071701.21485.18763.stgit@tikku>
Date: Sat, 7 Feb 2009 13:20:44 +0200
Message-ID: <da94abde0902070320g6a98320dhfdb05de8867d5fa7@mail.gmail.com> (sfid-20090207_122107_061613_E3C21C68)
Subject: Re: [PATCH] at76c50x-usb: mac80211 port of at76_usb
From: Kalle Valo <kalle.valo@iki.fi>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 7, 2009 at 9:27 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> John, please consider this driver as inclusion to the linux-testing tree. I
> don't consider this ready for mainline yet, I want to test this more first in
> case there are critical bugs.

I have been testing this for few hours now on ubuntu 8.10 with
networkmanager. With iperf I got this warning in some cases:

phy0: at76_mac80211_tx called while tx urb is pending

Also sometimes first association attempt failed and a second attempt
was needed, but otherwise the driver seems to be usable, at least for
me. The device I used for testing:

Bus 002 Device 006: ID 050d:0050 Belkin Components F5D6050 802.11b
Wireless Adapter

Kalle
