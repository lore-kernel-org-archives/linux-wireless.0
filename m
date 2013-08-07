Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:61018 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab3HGSIU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Aug 2013 14:08:20 -0400
Received: by mail-ea0-f178.google.com with SMTP id a15so975549eae.37
        for <linux-wireless@vger.kernel.org>; Wed, 07 Aug 2013 11:08:19 -0700 (PDT)
Received: from [192.168.1.52] (93-139-20-144.adsl.net.t-com.hr. [93.139.20.144])
        by mx.google.com with ESMTPSA id t6sm11640714eel.12.2013.08.07.11.08.18
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 07 Aug 2013 11:08:18 -0700 (PDT)
Message-ID: <52028D10.1020008@gmail.com> (sfid-20130807_200826_481606_15A24D0B)
Date: Wed, 07 Aug 2013 20:08:16 +0200
From: =?UTF-8?B?S3Jpc3RpYW4gU2tyYcSNacSH?= <kristian.skracic@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WL-1700USB connection unstable
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

For about 6 months now I have been using the WL-1700USB wireless
adapter. I am using Debian (7) and the rtl8187 driver, while my wireless
is protected with WPA2-PSK.
After I connect to my router via the adapter, everything works fine for
a short while (about 10minutes), and after that the connection speed
starts falling until it is completely frozen and i can't even ping
Google, let alone open a web page.

The adapter works fine on windows, but so far every distribution and/or
fix i tried works the same (I tried Debian 6, Arch linux, Ubuntu 11 and
12...).

I have tried lowering the rate, tx power and other options listed here:
https://wiki.archlinux.org/index.php/Rtl8187_wireless#Connection_always_times_out

I tried playing with the channel settings for the wireless network on my
router - same results.
Another strange think i noticed (although perhaps not relevant to the
deterioration of speed) is that the blue LED light on the adapter is
allways blinking extremely rapidly in all linux distros i tried. While
on Windows, it blinks depending on the current amount of network traffic
(although, even when i am downloading something at full speed on windows
the LED light does not blink that rapidly!).

Hope I gave enough information for someone to point me in the right
direction.
Any feedback regarding this issue is greatly appreciated!

Best regards,
Kristian

