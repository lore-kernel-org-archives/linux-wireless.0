Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47829 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1I2UeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Sep 2011 16:34:04 -0400
Received: by vws1 with SMTP id 1so826626vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Sep 2011 13:34:03 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Sep 2011 22:34:03 +0200
Message-ID: <CAGxArmeAH5K1ESVA79YYcUEueTB1zqcZZXTxvkUeKUG1Mjhd+Q@mail.gmail.com> (sfid-20110929_223409_254864_91A445FE)
Subject: re: carl9170 AP mode stops working in 3.0.x
From: Damian Lesiuk <ja@lesiuk.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have the same issue.

hostapd log:
http://pastebin.com/raw.php?i=23uxgBre

For me it's like 15-30 minutes. After that I can't connect to that
network but I can see it.
Only hostapd restart helps.

I tried older hostapd and 1.9.4 fw and it's the same.

I'm using Arch Linux with 3.0.4 kernel.

>
> Good day!
> I've been using TL-WN821Nv2 dongle as AP for a year or so. I'm using
> linux x86_64 desktop + hostapd. After upgrading to linux
> 3.0/compat-wireless-3.0-1/2, my AP started freezing after a while
> (Maybe several minutes or so).
> What I've tried so far:
> 1) switching hostapd in b/g mode.
> 2) checked /sys/.../power/autosuspend and various power-saving
> features. (Seems to be unsupported by my device anyway)
> 3) upgrading to firmware-1.9.4 + latest compat-wireless version.
>
> Sometimes restarting hostapd helps, sometimes not. I don't see any
> relevant error messages or something suspicious in logs. (Tried
> raising hostapd logs to maximum verbosity)
> The last good configuration was 2.6.39-r3 + compat-wireless-stable-39.1
>
> How could I help you find/debug this problem? I saw other complaint on
> the mail list and I guess it's similar issue.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@xxxxxxxxxxxxxxx
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
