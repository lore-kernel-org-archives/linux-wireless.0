Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50067 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab1HWPLU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 11:11:20 -0400
Received: by fxh19 with SMTP id 19so304559fxh.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 08:11:19 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Louis" <louis.m@gmx.net>
Subject: Re: carl9170-driver usable as AccessPoint
Date: Tue, 23 Aug 2011 17:11:16 +0200
Cc: linux-wireless@vger.kernel.org
References: <20110823081829.203150@gmx.net>
In-Reply-To: <20110823081829.203150@gmx.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201108231711.16397.chunkeey@googlemail.com> (sfid-20110823_171133_032310_F0CE42C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, August 23, 2011 10:18:29 AM Louis wrote:
> I am trying to set up an Accesspoint using the Fritz!WLAN USB Stick N with
> the carl9170-1.9.4 driver. The system runs on a 3.0-rc2 kernel. 
That's a misprint, right?! Because 3.0.3 still ships with 1.9.2.
 
> When trying to use hostapd-0.8, I get following error message: 
> "nl80211: Failed to set interface wlan1 into AP mode"
That's a generic error message. You'll to be more precise in fact
hostapd has a -d and -dd switch which makes the output more
verbose. 

> Can you you give me a hint if there is something wrong in my setup?
No, 'cause you haven't shown us any of your setup :D.

> Or is AP- usage not supported in the carl9170 driver?
It is. As long as noone disables it.
 
> Is there another way (or maybe driver) which can set the wifi-stick
> into master mode ? 
Well, now that you mention it: a different stick. For example the
Fritz!WLAN USB Stick N. Even though this stick has the same
name, it's quite different, they now stick AR7010+AR9280 chips
into the device and ath9k_htc is the driver.
